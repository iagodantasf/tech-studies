---
title: Embeddings and Vector Search
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, embeddings]
prerequisites: []
see-also: [rag-and-vector-databases, long-term-memory]
---

# Embeddings and Vector Search

An embedding maps text to a fixed-length vector so that semantically similar text lands nearby; vector search then finds the nearest vectors to a query.

## Why it matters

This is the retrieval engine under agent memory and RAG. Keyword search misses "car" when the doc says "automobile"; embeddings match by *meaning*, so an agent can pull the relevant chunk regardless of wording. It powers [[rag-and-vector-databases]], [[long-term-memory]], deduplication, and clustering — anywhere an agent must find "things like this" in a large corpus.

## How it works

An embedding model turns a string into a dense vector (e.g. 1536 dims). Similarity is **cosine** (angle); on normalized vectors that's just a dot product. At scale, an **ANN** index (HNSW, IVF) trades exactness for speed.

- **Chunk → embed → index.** Split docs to ~200–500 tokens, embed each chunk, store vector + metadata + source text.
- **Query → embed → top-k.** Embed the query with the *same* model, return the k nearest chunks, feed them to the LLM.
- **ANN graphs** (HNSW) give sub-millisecond search over millions of vectors at ~95–99% recall — exact brute force is O(N) and too slow.
- **Hybrid retrieval** fuses vector + keyword (BM25), often re-ranked by a cross-encoder, to beat either alone.

| Concept | Meaning |
|---|---|
| Dimensions | vector length (384–3072 typical) |
| Cosine similarity | 1.0 identical, ~0 unrelated |
| top-k | how many neighbors to retrieve |
| ANN (HNSW/IVF) | approximate, fast nearest-neighbor |

## Example

Semantic search over a docs corpus:

```
"how do I reset my password?"  → embed → [0.01, -0.23, ...] (1536d)
ANN top-3 from 50k chunks:
  0.91  "Resetting your account credentials"
  0.84  "Forgot password flow"
  0.79  "Login troubleshooting"
→ pass these 3 chunks as context to the LLM
```

The exact words "reset" and "password" never appear in the top hit — meaning, not lexical overlap, ranked it first.

## Pitfalls

- **Mismatched models.** Querying with a different embedding model (or version) than you indexed with silently destroys recall — pin one model.
- **Bad chunking.** Chunks too big dilute the vector; too small lose context. Tune size and overlap to the content.
- **Cosine ≠ truth.** High similarity isn't relevance; re-rank and set a score threshold or you'll retrieve confident garbage.
- **Stale index.** Embeddings don't auto-update; re-embed when source docs or the model change, or retrieval drifts.

## See also

- [[rag-and-vector-databases]]
- [[long-term-memory]]
