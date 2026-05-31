---
title: Langfuse
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, observability]
prerequisites: [structured-logging-tracing]
see-also: [langsmith, helicone]
---

# Langfuse

An open-source LLM observability and evaluation platform — traces, prompt management, evals, and cost analytics — that you can self-host or use as a managed cloud.

## Why it matters

It's the leading **open-source** answer to [[langsmith]]: same trace-tree-plus-evals model, but Apache-2.0 and self-hostable, which matters when prompts and outputs contain regulated data you can't ship to a vendor. It also bundles **prompt management** (versioned prompts fetched at runtime) so you can change a prompt without redeploying, and decoupled SDKs that work with any model or framework.

## How it works

The data model mirrors OpenTelemetry: a **trace** contains **observations**, which are spans, events, or **generations** (a model call, with token counts and cost).

| Object | Captures |
|---|---|
| Trace | one end-to-end request |
| Span | a step / sub-operation |
| Generation | model call + tokens + cost + latency |
| Score | a metric attached to a trace/observation |

- **SDK + decorators.** `@observe()` in Python wraps a function into a span; native integrations exist for OpenAI, LangChain, LlamaIndex, and OTel.
- **Scores are the eval primitive.** Attach a score (numeric/boolean/categorical) from any source — human review, an LLM-judge, or code — to any trace; dashboards aggregate them.
- **Prompt management.** Store prompts with labels (`production`, `staging`); the SDK fetches and caches them, and links each generation back to the prompt version that produced it.
- **Self-host.** Docker Compose / Helm with Postgres + ClickHouse; cost analytics break spend down by model, user, or tag ([[token-based-pricing]]).

## Example

Tracing and scoring a generation:

```python
from langfuse.decorators import observe, langfuse_context

@observe()
def answer(q):
    prompt = langfuse_context.get_prompt("support-bot", label="production")
    out = call_llm(prompt.compile(question=q))   # generation auto-captured
    langfuse_context.score_current_trace(name="grounded", value=1.0)
    return out
```

The trace shows the prompt version, token cost, latency, and the `grounded=1.0` score, all queryable in one place.

## Pitfalls

- **Self-host scaling.** High trace volume needs the ClickHouse backend tuned; the all-in-one container is for evaluation, not production load.
- **Forgetting to flush.** In short-lived scripts/serverless, call `flush()` before exit or trailing traces are dropped.
- **Score sprawl.** Inventing dozens of ad-hoc score names fragments dashboards; standardize a small metric set ([[metrics-to-track]]).
- **Logging secrets.** Generations capture full prompts; scrub keys/PII before they reach the store ([[data-privacy-pii-redaction]]).

## See also

- [[langsmith]]
- [[helicone]]
