---
title: Structured Logging / Tracing
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, tracing]
prerequisites: [agent-loop]
see-also: [openllmetry, metrics-to-track]
---

# Structured Logging / Tracing

Emitting machine-readable, queryable records of what an agent did — structured key-value logs for events and nested spans (traces) for the causal tree of a multi-step run.

## Why it matters

A prose `print("calling tool...")` is unsearchable; when one [[agent-loop]] fans out into 15 nested model and tool calls, you cannot reconstruct *why* it failed from flat text. Structured logs let you filter "all runs where tool X errored for user Y", and **tracing** reconstructs the parent-child tree so you see that step 4's bad retrieval caused step 9's hallucination. This is the substrate every observability tool ([[langfuse]], [[openllmetry]]) builds on.

## How it works

Two complementary primitives: **structured logs** (discrete events as JSON) and **traces** (a tree of timed **spans** sharing a `trace_id`).

| Concept | Captures |
|---|---|
| Structured log | one event as key-value JSON |
| Span | a timed unit of work (one call) |
| Trace | spans linked by `trace_id` into a tree |
| Span attributes | model, tokens, latency, status |

- **Correlation IDs.** A `trace_id` (whole request) plus `span_id` (each step) thread every record together; without them, concurrent runs interleave into noise.
- **Parent-child spans.** Each model/tool call opens a span under its caller, so the trace mirrors the agent's actual control flow.
- **Capture per LLM span.** Prompt, completion, model, `temperature`, token counts, latency, and stop reason — enough to replay and debug the step.
- **Sampling.** Log every error trace; sample successes (e.g. 1–10%) to bound cost and volume at scale.

## Example

A trace tree for one task vs an unstructured log:

```
trace 7f3a (task: "refund status")
 └─ span agent.step1   llm   1.2s  812 tok
     └─ span tool.lookup_order  db  0.3s  status=ok
 └─ span agent.step2   llm   2.9s  640 tok  status=error("bad JSON")
                                              ↑ root cause, instantly visible
```

```json
{"trace_id":"7f3a","span":"agent.step2","event":"tool_call",
 "tool":"refund","status":"error","tokens":640,"latency_ms":2900}
```

You can now query `status=error` across millions of runs; the flat `print` could not.

## Pitfalls

- **Logging blobs as strings.** A f-string message isn't queryable; emit fields (`tool=...`, `status=...`) as structured data.
- **No correlation ID.** Without a shared `trace_id`, you can't stitch a multi-step run back together — generate one per request and propagate it.
- **Logging secrets/PII.** Prompts and tool args carry sensitive data; redact before write ([[data-privacy-pii-redaction]]).
- **Synchronous logging in the hot path.** Blocking I/O per span adds latency; batch and export asynchronously.

## See also

- [[openllmetry]]
- [[metrics-to-track]]
