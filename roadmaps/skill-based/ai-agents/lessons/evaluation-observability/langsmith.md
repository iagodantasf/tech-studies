---
title: LangSmith
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, observability]
prerequisites: [structured-logging-tracing]
see-also: [langfuse, langchain]
---

# LangSmith

LangChain's hosted platform for tracing, evaluating, and monitoring LLM apps — framework-agnostic despite the name, but tightest with [[langchain]] and [[langgraph]].

## Why it matters

When an [[agent-loop]] makes 12 nested model and tool calls, a flat log is useless; you need the **trace tree** to see which step hallucinated or stalled. LangSmith captures that tree, lets you turn any captured run into a **dataset**, and run **evaluators** over it in CI — closing the loop from "saw a bad prod run" to "added it to the regression set". It's the default if your stack already speaks LangChain.

## How it works

The core object is a **run** (one unit of work); nested runs form a trace. You attach evaluators that score runs against a reference dataset.

| Concept | Meaning |
|---|---|
| Run | one LLM/tool/chain call, nestable |
| Trace | the full tree for one request |
| Dataset | input→reference examples for eval |
| Evaluator | fn or LLM judge scoring a run |
| Experiment | one eval pass over a dataset |

- **Auto-instrumentation.** Set `LANGCHAIN_TRACING_V2=true` and LangChain/LangGraph runs trace themselves; outside the framework, wrap functions with the `@traceable` decorator.
- **Evaluators.** Built-in (exactness, embedding distance, LLM-as-judge for correctness/helpfulness) or custom Python; run them via `evaluate()` over a dataset.
- **Datasets from prod.** Click a bad trace → add to dataset → it becomes a permanent test case (see [[integration-testing-for-flows]]).
- **Monitoring.** Dashboards for latency, cost, error rate, and feedback ([[metrics-to-track]]); supports online evals on sampled live traffic.

## Example

Regression-testing a prompt change:

```python
from langsmith import evaluate
def correct(run, example):                 # custom evaluator
    return {"score": run.outputs["answer"] == example.outputs["answer"]}

evaluate(my_agent, data="qa-goldset-v3",
         evaluators=[correct, "qa"])        # "qa" = built-in LLM judge
# → experiment: 91% correct, vs 88% on previous prompt
```

Every run is browsable in the trace UI; the experiment diff shows which examples flipped.

## Pitfalls

- **Sending PII to a hosted backend.** Traces include raw prompts/outputs — redact or self-host before logging user data ([[data-privacy-pii-redaction]]).
- **Trusting the LLM judge blindly.** Calibrate its verdicts against [[human-in-the-loop-evaluation|human labels]] before gating on them.
- **Tracing in the hot path.** Default export is async/batched; a synchronous custom wrapper can add latency — keep it off the critical path.
- **Assuming LangChain-only.** It traces any code via `@traceable`; don't rewrite your agent just to use it.

## See also

- [[langfuse]]
- [[langchain]]
