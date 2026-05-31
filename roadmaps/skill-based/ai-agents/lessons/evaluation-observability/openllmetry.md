---
title: OpenLLMetry
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, opentelemetry]
prerequisites: [structured-logging-tracing]
see-also: [langfuse, helicone]
---

# OpenLLMetry

An open-source set of **OpenTelemetry** extensions (by Traceloop) that auto-instrument LLM and vector-DB calls, emitting standard OTel traces you can send to *any* compatible backend.

## Why it matters

Vendor SDKs ([[langsmith]], proprietary parts of others) can lock your telemetry into one platform. OpenLLMetry instead speaks **OpenTelemetry**, the industry-standard tracing protocol, so LLM spans flow into the same Datadog/Grafana/Jaeger/Honeycomb stack your backend already uses — no separate silo. It auto-instruments OpenAI, Anthropic, LangChain, LlamaIndex, Pinecone, and more, capturing prompts, completions, token counts, and latency as semantic-convention attributes.

## How it works

It ships OTel **instrumentations** that monkey-patch SDK calls to emit spans following the GenAI semantic conventions, plus an SDK that wires up export.

| Piece | Role |
|---|---|
| Instrumentations | patch SDKs → emit LLM spans |
| SDK (`Traceloop`) | init + configure OTLP export |
| `@workflow`/`@task` | group spans into a logical trace |
| OTLP exporter | ship to any OTel backend |

- **One-line init.** `Traceloop.init()` turns on instrumentation and starts exporting over OTLP; spans carry model, prompt, completion, and usage attributes.
- **Backend-agnostic.** Point the OTLP endpoint at Traceloop, Datadog, Grafana Tempo, Jaeger, [[langfuse]] (OTel-compatible), etc. — switch by config, not code.
- **Standard correlation.** Because it's plain OTel, an LLM span nests inside the *same* trace as your HTTP and DB spans, so you see the whole request end-to-end.
- **Workflow grouping.** Decorators tag a multi-step [[agent-loop]] as one workflow so its spans aggregate into a single tree.

## Example

Instrument an app and export anywhere:

```python
from traceloop.sdk import Traceloop
from traceloop.sdk.decorators import workflow

Traceloop.init(app_name="agent", api_endpoint=OTLP_URL)  # one line

@workflow(name="answer_question")     # groups the calls below into one trace
def answer(q):
    docs = retrieve(q)                # Pinecone span auto-captured
    return call_llm(q, docs)          # OpenAI span auto-captured
```

The resulting OTel trace shows retrieval + generation as child spans, ingestible by whatever observability backend you already run.

## Pitfalls

- **Capturing prompt content.** Span attributes include full prompts/completions by default — disable content capture or redact for PII ([[data-privacy-pii-redaction]]).
- **Attribute size limits.** Backends cap attribute length; very long prompts get truncated, hiding part of the input — check limits.
- **Missing collector.** OTLP needs a reachable collector/backend; without one, traces silently drop — verify the pipeline end-to-end.
- **Conventions still evolving.** The GenAI semantic conventions change between versions; pin and re-check that dashboards still map fields.

## See also

- [[langfuse]]
- [[structured-logging-tracing]]
