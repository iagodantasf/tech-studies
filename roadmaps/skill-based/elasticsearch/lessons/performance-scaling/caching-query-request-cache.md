---
title: Caching (query / request cache)
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, caching]
prerequisites: [query-vs-filter-context]
see-also: [bucket-aggregations, force-merge-refresh-interval, relevance-scoring-bm25]
---

# Caching (query / request cache)

Elasticsearch keeps several distinct caches — node query cache, shard request cache, and the OS page cache — that together make repeated [[query-vs-filter-context|filters]] and [[bucket-aggregations|aggregations]] cheap on warm data.

## Why it matters

Dashboards and filtered searches re-run nearly identical queries constantly; recomputing the same filter bitset or aggregation every time wastes CPU and I/O. Knowing *which* cache serves *what* — and what invalidates it — is the difference between a snappy Kibana board and one that hammers the cluster on every refresh.

## How it works

Three layers, each keyed and invalidated differently:

| Cache | Scope | Caches | Invalidated by |
|---|---|---|---|
| Node query cache | Per node, LRU | Filter-context bitsets per [[segments]] | Segment merge/delete |
| Shard request cache | Per shard | Whole-request results (aggs, hits.total) | Any refresh on the shard |
| OS page cache | Per node | Raw Lucene file blocks | Memory pressure |

- **Only filter context is query-cached** — scored [[query-vs-filter-context|query-context]] clauses ([[relevance-scoring-bm25|BM25]]) aren't cached because scores depend on the query; put cacheable predicates in `filter`/`must_not`.
- **Request cache requires `size:0`** by default — it shines for aggregations and `hits.total` where the hit list is empty; it's keyed on the whole request JSON, so any difference (even key order) misses.
- **Refresh busts the request cache** — on a frequently refreshing index the cache barely helps; it pays off on read-only [[hot-warm-cold-architecture|warm/cold]] indices where data is stable.
- **Heuristic admission** — the node query cache only caches filters it sees reused and on segments above a size threshold, to avoid churn on tiny/rare filters.

## Example

A dashboard runs the same `range` on `@timestamp` plus a `terms` agg every 30 s. Wrapped in `filter` with `size:0` against a read-only warm index, the first call computes; subsequent calls hit the shard request cache and return in single-digit ms. Move the same query to today's hot index (refreshing every 1 s) and the request cache misses almost every time — the agg recomputes.

## Pitfalls

- **Putting cacheable predicates in query context** — a date filter inside `must` (scored) skips the query cache; move it to `filter`.
- **Expecting caching on a hot index** — per-second refresh invalidates the request cache continuously; cache benefit lives on stable data.
- **`now` in range filters** — `gte: now-1h` rounds to the millisecond, so the cache key changes constantly; use `now-1h/h` rounding to make it cacheable.
- **Sizing heap for caches** — node query cache defaults to ~10% of heap and request cache ~1%; raising them blindly steals heap from indexing and search.

## See also

- [[query-vs-filter-context]]
- [[bucket-aggregations]]
