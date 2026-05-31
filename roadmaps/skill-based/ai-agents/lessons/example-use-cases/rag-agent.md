---
title: RAG Agent
track: ai-agents
group: Example Use Cases
tags: [ai-agents, rag]
prerequisites: [rag-and-vector-databases, agent-loop]
see-also: [embeddings-and-vector-search, database-queries]
---

# RAG Agent

A RAG agent is an [[agent-loop]] where retrieval is a *tool the model chooses to call* — it decides when to search, with what query, and whether to search again — rather than a fixed prefetch before generation.

## Why it matters

Plain [[rag-and-vector-databases|RAG]] retrieves once on the raw user question and hopes the top-k is enough; that breaks on multi-hop questions ("compare our 2023 and 2024 churn"), vague queries, and questions the corpus can't answer. An *agentic* RAG loop fixes this by letting the model rewrite the query, retrieve across multiple turns, and stop when it has enough — trading a few extra calls for far higher answer quality on hard questions. It powers doc-Q&A bots, support copilots, and "chat with your data" features.

## How it works

Retrieval becomes one or more tools in the loop; the model interleaves search and reasoning like [[react-reason-act|ReAct]].

- **Query rewriting.** The model turns a vague question into a focused search string (and may decompose multi-hop questions into sub-queries).
- **Retrieve tool.** Embeds the query, runs ANN top-k over the [[embeddings-and-vector-search|vector index]], returns chunks with source IDs; a hybrid path fuses BM25 keyword hits.
- **Grounding + cite.** Generate strictly from retrieved text and emit source IDs so answers are verifiable.
- **Self-check / loop.** If retrieved chunks are weak or contradictory, the model re-queries or admits "not in the docs" instead of guessing.

| Pattern | Retrievals | Best for |
|---|---|---|
| Naive RAG | exactly 1, raw query | simple lookups |
| Query-rewrite RAG | 1, cleaned query | vague questions |
| Multi-hop / agentic | N, model-driven | compare, chain, aggregate |

## Example

A two-hop question the naive pattern fails:

```
Q: "Did the feature in our latest release fix the bug from ticket 412?"
  search("latest release notes") → "v3.2 adds retry backoff…"
  search("ticket 412 description") → "412: requests fail, no retry…"
  reason: backoff addresses the missing-retry cause
  → "Yes — v3.2's retry backoff fixes the no-retry issue in 412." [v3.2, t412]
```

One naive retrieval on the full question would mix both topics and miss the link; two targeted searches plus reasoning get it right and cite both sources.

## Pitfalls

- **Endless re-querying.** Without a retrieval cap (e.g. 3) the loop searches forever on an unanswerable question; bound it and let it say "not found".
- **No score floor.** Top-k always returns *something*; feed low-similarity chunks and the model answers confidently from junk — threshold and re-rank.
- **Lost-in-the-middle.** Stuffing 20 chunks buries the answer; keep top 3–5 and put the best first (see [[context-windows]]).
- **Skipping citations.** An ungrounded answer is indistinguishable from a hallucination — require source IDs so it is checkable.

## See also

- [[embeddings-and-vector-search]]
- [[database-queries]]
