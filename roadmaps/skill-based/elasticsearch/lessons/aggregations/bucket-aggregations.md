---
title: Bucket aggregations
track: elasticsearch
group: Aggregations
tags: [elasticsearch, aggregations]
prerequisites: [metric-aggregations, fields-data-types]
see-also: [nested-aggregations, pipeline-aggregations, cardinality-percentiles]
---

# Bucket aggregations

Aggregations that partition documents into groups ("buckets") by some key — a term, a numeric range, a date interval — each carrying a `doc_count` and able to hold child aggregations.

## Why it matters

Buckets are the GROUP BY of Elasticsearch: "errors per service," "sales per day," "users per age band." They give analytics its shape, and a single misjudged `size` or interval can either truncate the answer or blow up heap. Bucketing is also where approximate-vs-exact tradeoffs (`terms` counts) and memory limits (`search.max_buckets`, default 65 536) bite hardest.

## How it works

Each bucket type computes keys differently and may sub-aggregate via [[nested-aggregations|nesting]].

| Agg | Buckets by | Exact? |
|---|---|---|
| `terms` | distinct field values | approximate counts |
| `date_histogram` | calendar/fixed interval | exact |
| `histogram` | fixed numeric interval | exact |
| `range` / `date_range` | explicit `[from,to)` ranges | exact |
| `filters` | one bucket per named query | exact |
| `composite` | every key combo, paged | exact |

- **`terms` is approximate** — each [[shards-replicas|shard]] returns its top `shard_size` (≈ `size * 1.5 + 10`) terms; the coordinator merges them, so a globally top term that's #4 on every shard can be missed. `doc_count_error_upper_bound` quantifies the risk.
- **`date_histogram`** — `calendar_interval` (month, week) respects DST and month length; `fixed_interval` (`30m`, `90d`) is constant-width. Mixing them up shifts buckets.
- **`composite`** — the only bucket agg that **paginates** via `after`, built for exhaustively streaming every combination without exceeding the bucket limit.
- **Order** — sort by `_count` (default) or `_key`; ordering by a child metric is allowed but worsens `terms` error.

## Example

```
GET /logs/_search
{ "size": 0,
  "aggs": {
    "per_service": {
      "terms": { "field": "service.keyword", "size": 10 },
      "aggs": { "p95": { "percentiles": { "field": "ms", "percents": [95] } } } } } }
```

This yields the top 10 services by document count, and for each the 95th-percentile latency — a [[metric-aggregations|metric]] nested under a bucket.

## Pitfalls

- **`terms` truncation** — `size:10` returns 10 buckets, not "the 10 biggest globally"; raise `shard_size` or use `composite` when completeness matters.
- **Too many buckets** — a `date_histogram` of `1s` over a year is ~31M buckets and trips `search.max_buckets`; pick a coarser interval.
- **High-cardinality `terms`** — bucketing a unique ID builds millions of buckets and can OOM the coordinating node; consider [[cardinality-percentiles|cardinality]] if you only need a count.
- **Calendar vs fixed** — `fixed_interval:"1M"` is illegal (months vary); months/quarters/years require `calendar_interval`.

## See also

- [[nested-aggregations]]
- [[pipeline-aggregations]]
