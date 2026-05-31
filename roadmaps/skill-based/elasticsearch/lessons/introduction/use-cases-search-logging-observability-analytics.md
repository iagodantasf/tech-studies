---
title: Use cases (search, logging, observability, analytics)
track: elasticsearch
group: Introduction
tags: [elasticsearch, use-cases]
prerequisites: []
see-also: [what-is-elasticsearch, the-elastic-stack-elk-elastic, data-streams]
---

# Use cases (search, logging, observability, analytics)

The four workloads Elasticsearch is bought for — and how their data shape and access patterns differ enough to change how you configure the cluster.

## Why it matters

"Search" and "logs" pull a cluster in opposite directions: search is read-heavy with mutable, low-volume documents; logs are write-heavy, append-only, and time-partitioned. Picking the wrong [[sharding-strategy|sharding]] or lifecycle model for the workload is the most common cause of a cluster that's slow or runs out of disk.

## How it works

The same engine, configured differently per workload.

- **Site/app search** — relatively static documents, [[relevance-scoring-bm25|BM25]] relevance matters, plus [[suggesters-autocomplete|autocomplete]] and [[bucket-aggregations|faceting]]. A few well-sized indices.
- **Logging** — append-only events keyed by `@timestamp`; use [[data-streams|data streams]] + [[index-lifecycle-management-ilm|ILM]] to roll over and age out.
- **Observability / APM** — logs + metrics + traces unified; high cardinality, retention tiers via [[hot-warm-cold-architecture|hot-warm-cold]].
- **Analytics / BI** — heavy [[metric-aggregations|metric]] and [[pipeline-aggregations|pipeline]] aggregations over large windows; [[runtime-fields|runtime fields]] for ad-hoc dimensions.

| Workload | Write pattern | Key feature | Lifecycle |
|---|---|---|---|
| Search | Mutable, low volume | BM25, autocomplete | Manual reindex |
| Logging | Append-only, high volume | Data streams | ILM rollover |
| Observability | Mixed signals | Correlation | Tiered retention |
| Analytics | Bulk loads | Aggregations | Snapshot/archive |

## Example

A logging index sized for ~50 GB/day with 7-day hot retention:

```
data stream "logs-app-prod"
  ILM: rollover at 50GB or 1d  ──▶ hot (7d) ──▶ warm (30d) ──▶ delete
  shard target ≈ 30–50 GB each
```

Compare a product-search index: 1 primary + 1 replica, tuned [[analyzers-standard-language-custom|analyzers]], rebuilt via [[reindex-api|reindex]] on mapping changes.

## Pitfalls

- **One config for all** — over-sharding a search index or under-using ILM for logs both end badly.
- **High-cardinality aggregations** — `terms`/[[cardinality-percentiles|cardinality]] over millions of unique values blows up memory; bound them.
- **Time-series without rollover** — a single ever-growing index becomes unmanageable; use [[data-streams|data streams]] from day one.

## See also

- [[the-elastic-stack-elk-elastic]]
- [[data-streams]]
