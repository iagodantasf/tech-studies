---
title: Haystack
track: ai-agents
group: Frameworks
tags: [ai-agents, rag]
prerequisites: [rag-and-vector-databases, rest-api-knowledge]
see-also: [llamaindex, integration-testing-for-flows]
---

# Haystack

An open-source framework (by deepset) for building LLM apps as explicit **pipelines of typed components**, with a production bias toward search, RAG, and deployable APIs.

## Why it matters

Haystack treats a RAG or agent app as a wired graph of components with declared input/output types, so connections are validated *before* you run — a sharp contrast to frameworks that fail at runtime on a shape mismatch. It targets teams shipping to production: pipelines serialize to YAML, deploy behind a REST service (Hayhooks), and swap retrievers or models without code changes. This makes it a strong fit when the app is a durable [[rest-api-knowledge|service]], not a notebook experiment.

## How it works

A **Pipeline** is a DAG; you `add_component` then `connect("a.output", "b.input")`, and Haystack type-checks each edge.

| Concept | Role |
|---|---|
| Component | typed unit (retriever, prompt builder, generator) |
| Pipeline | DAG wiring components by socket |
| Document Store | vector/keyword backend (OpenSearch, etc.) |
| Connection | validated `out → in` edge |

- **Explicit sockets** mean a retriever's `documents` output won't connect to an input expecting a `str`; mismatches error at build time.
- A standard RAG pipeline is `text embedder → retriever → prompt builder → generator`, each a swappable node (see [[rag-and-vector-databases]]).
- **Branching/loops** use routers and conditional connections; an agent is a pipeline that cycles a generator back through a tool-invoker.
- Pipelines **serialize to YAML**, so the same graph runs in tests, CI, and the deployed [[rest-api-knowledge|API]] unchanged.

## Example

A minimal RAG pipeline, wired by socket name:

```python
p = Pipeline()
p.add_component("emb", TextEmbedder())
p.add_component("ret", Retriever(document_store=store))
p.add_component("prompt", PromptBuilder(template=TMPL))
p.add_component("llm", Generator(model="..."))
p.connect("emb.embedding", "ret.query_embedding")
p.connect("ret.documents", "prompt.documents")   # type-checked here
p.connect("prompt.prompt", "llm.prompt")
p.run({"emb": {"text": q}, "prompt": {"question": q}})
```

If `ret.documents` didn't match `prompt.documents`, the `connect` raises immediately — the bug surfaces at wiring time, not in production.

## Pitfalls

- **Socket-name mismatches.** Most errors are a misnamed input/output in `connect`; read the component's declared sockets, don't guess.
- **Feeding inputs to the wrong node.** `run()` takes a dict keyed by component name; a stray key is ignored silently and the node gets empty input.
- **v1 vs v2 confusion.** Haystack 2.x rewrote the pipeline API; v1 tutorials don't apply — match the major version.
- **Untested branches.** Conditional routes are easy to leave uncovered; exercise each path with [[integration-testing-for-flows]].

## See also

- [[llamaindex]]
- [[integration-testing-for-flows]]
