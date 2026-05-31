---
title: kNN / vector search
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, vector-search]
prerequisites: [mappings, query-dsl-overview]
see-also: [relevance-scoring-bm25, full-text-search, bool-query-must-should-must-not-filter]
---

# kNN / vector search

Finds the documents whose dense embedding vectors are nearest to a query vector, ranking by semantic similarity instead of by matching [[inverted-index|inverted-index]] terms.

## Why it matters

Embeddings from a model turn text, images, or audio into points in a high-dimensional space where "meaning" maps to distance, so "car" can retrieve "automobile" with zero shared tokens. This powers semantic search, recommendations, dedup, and the retrieval half of RAG. Exact nearest-neighbour is O(N·dims) per query — unworkable at scale — so Elasticsearch uses an approximate index (HNSW) that trades a few percent recall for sub-100 ms latency over millions of vectors.

## How it works

Vectors live in a `dense_vector` field; Lucene builds a per-segment **HNSW** graph (a navigable small-world structure layered like a [[graphs|skip list]]) so search walks a few hundred nodes, not all N.

| Parameter | Where | Effect |
|---|---|---|
| `m` | index | graph edges/node; higher = better recall, more RAM |
| `ef_construction` | index | build-time effort; higher = denser graph, slower indexing |
| `num_candidates` | query | nodes explored; higher = better recall, slower search |
| `k` | query | hits returned per shard |

- **`similarity`** — `cosine` (default; auto-normalizes), `dot_product` (faster, needs unit vectors), `l2_norm`. Score is normalized so higher = closer.
- **Approximate `knn`** at top level uses the graph; a `knn` inside a `script_score` does exact brute force (no graph, no `num_candidates`).
- **Per-shard** — `num_candidates` and `k` apply per [[shards-replicas|shard]], then results are merged; over-sharding hurts recall.
- **Quantization** — `int8_hnsw` (default ≥8.x) cuts memory ~4× with negligible recall loss; `bbq` (binary) cuts ~32×.
- **Hybrid** — combine kNN with a [[bool-query-must-should-must-not-filter|bool]] [[full-text-search|BM25]] query and fuse via RRF for the best of lexical + semantic.

## Example

```
PUT /docs { "mappings": { "properties": {
  "emb": { "type": "dense_vector", "dims": 768, "similarity": "cosine",
           "index_options": { "type": "int8_hnsw", "m": 16, "ef_construction": 100 } } } } }

POST /docs/_search { "knn": {
  "field": "emb", "query_vector": [0.12, -0.4, ...],
  "k": 10, "num_candidates": 100,
  "filter": { "term": { "lang": "en" } } } }
```

768-dim query searches the HNSW graph, explores 100 candidates/shard, applies the `lang` pre-filter during the walk, and returns the 10 nearest English docs.

## Pitfalls

- **Heap vs off-heap RAM** — HNSW graphs must stay in the OS page cache for speed; if vectors exceed RAM, latency falls off a cliff. Quantize or scale out.
- **Filter ≠ post-filter** — kNN's `filter` runs *during* graph traversal; a bad filter can starve the search of candidates, so raise `num_candidates` when filtering hard.
- **`dims` is fixed** — change embedding model or dimension and you must [[reindex-api|reindex]]; the field can't be altered in place.
- **Recall is invisible** — approximate search silently misses true neighbours; measure recall against a brute-force baseline before trusting it, and don't set `num_candidates` ≈ `k`.

## See also

- [[relevance-scoring-bm25]]
- [[full-text-search]]
