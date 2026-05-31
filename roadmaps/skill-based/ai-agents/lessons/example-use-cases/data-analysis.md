---
title: Data Analysis
track: ai-agents
group: Example Use Cases
tags: [ai-agents, data-analysis]
prerequisites: [code-execution-repl, agent-loop]
see-also: [database-queries, code-generation]
---

# Data Analysis

A data-analysis agent answers questions about a dataset by *writing and running code* (pandas/SQL) in a stateful REPL, reading the result, and iterating — not by guessing numbers from the prompt.

## Why it matters

LLMs cannot reliably do arithmetic or aggregate a table by eye, but they are excellent at writing the [[code-execution-repl|code]] that does. Routing every numeric question through execution converts "what's the 90th-percentile latency?" from an unreliable token-prediction into a deterministic, reproducible computation. This is the engine behind ChatGPT Advanced Data Analysis, notebook copilots, and "ask your spreadsheet" tools — and it lets a non-coder interrogate a CSV in plain English while keeping the answer auditable (the code is the receipt).

## How it works

A loop over a [[code-execution-repl|REPL]] (and/or a [[database-queries|SQL]] tool) with persistent kernel state, so variables built in one turn survive to the next like a notebook.

- **Profile first.** The agent inspects schema/`dtypes`/`head()` before computing — it can't analyze columns it hasn't seen.
- **Compute, then read.** It writes the transformation, runs it, and reads the *small* result (a number, a 5-row frame), not the whole dataset.
- **Self-correct from tracebacks.** A `KeyError` or bad delimiter is an observation the model fixes on the next turn.
- **Plot to a file.** Charts are written to disk and surfaced as artifacts/links, never pasted into [[context-windows|context]] as base64.

| Backend | Good for | Watch out |
|---|---|---|
| pandas (REPL) | <~1M rows, ad-hoc transforms | loads into RAM |
| DuckDB | larger-than-RAM files, fast SQL | columnar, file-based |
| SQL warehouse | the data already lives there | network + cost per query |

## Example

A self-correcting numeric answer:

```
Q: "average order value for EU customers in Q2?"
  df.info() → region, amount, order_date  (amount is object!)
  df["amount"].mean() → TypeError: str + str
  obs → cast: df["amount"]=pd.to_numeric(df.amount.str.strip("$"))
  filter region=="EU" & Q2 → .mean() → 73.42
  → "Average EU Q2 order value: $73.42"
```

The dirty `$`-string column broke the first attempt; the model read the error, cleaned the type, and returned an exact figure — fully reproducible from the emitted code.

## Pitfalls

- **Trusting un-run numbers.** If the model "estimates" instead of executing, it will be confidently wrong — force every figure through the REPL.
- **Dumping the dataframe.** `print(df)` on a million rows floods context and costs a fortune; aggregate first, cap output bytes.
- **Silent dtype/NaN bugs.** Strings-as-numbers, dropped NaNs, and timezone-naive dates skew results without erroring — have it profile and sanity-check.
- **No sandbox / unbounded queries.** Arbitrary code is RCE and a `SELECT *` on a billion rows OOMs; isolate, set row/byte/time limits.

## See also

- [[database-queries]]
- [[code-generation]]
