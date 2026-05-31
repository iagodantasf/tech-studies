---
title: Code Execution / REPL
track: ai-agents
group: Tools an Agent Can Use
tags: [ai-agents, code-execution]
prerequisites: [acting-tool-invocation]
see-also: [file-system-access, data-analysis]
---

# Code Execution / REPL

A tool that lets the agent write code (usually Python) and run it in a sandbox, returning stdout, return values, and errors as the [[observation-reflection]] step.

## Why it matters

LLMs are terrible at arithmetic and exact data manipulation but great at *writing code that does it*. Giving the model a REPL converts "compute the 90th percentile of this column" from an unreliable token-prediction into a deterministic execution. It underpins [[data-analysis]] agents, chart generation, and any task where the answer must be *computed*, not guessed. The REPL is also stateful, so the model builds up variables across turns like a notebook.

## How it works

The tool receives a code string, executes it in an isolated kernel (a Jupyter kernel, a `subprocess`, or a microVM), and returns captured output. State persists between calls within a session — a variable set in call 1 is visible in call 3.

- **Capture everything** — stdout, stderr, the last expression's value, *and* tracebacks. A traceback is a feature: the model reads it and fixes its own bug.
- **Sandbox hard** — no network by default, a non-root user, a read-only FS except `/tmp`, CPU/memory/wall-clock limits. Untrusted-code execution is the threat model.
- **Truncate output** — a `print(df)` on a million rows will blow your [[context-windows]]; cap returned bytes (e.g. 4–8 KB) with a "...truncated" marker.
- **Persist artifacts** — files the code writes (a PNG plot, a CSV) are saved out-of-band and surfaced as links, not pasted into context.

| Sandbox option | Isolation | Startup |
|---|---|---|
| Restricted subprocess | weak | ~ms |
| Container (Docker) | medium | ~1 s |
| microVM (Firecracker/gVisor) | strong | ~150 ms |

## Example

A typical self-correcting loop:

```
turn 1 → import pandas as pd; df = pd.read_csv("sales.csv"); df.describe()
obs    → ParserError: Error tokenizing data. C error...
turn 2 → df = pd.read_csv("sales.csv", sep=";"); df["rev"].sum()
obs    → 184213.55
```

The model recovered from a bad delimiter purely by reading the error — no human in the loop.

## Pitfalls

- **No sandbox = RCE.** A naive `exec()` on model output is remote code execution against your own box. Always isolate.
- **Unbounded loops/output** hang the kernel or flood context; enforce wall-clock and byte limits.
- **Hidden state confusion** — leftover variables from earlier calls cause "works on retry" non-determinism; offer a reset and log kernel state.
- **Package availability** — the model assumes `scipy` is installed; pre-bake a known image and tell the model what's available, or it loops on `ModuleNotFoundError`.

## See also

- [[file-system-access]]
- [[data-analysis]]
