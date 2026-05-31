---
title: Metric aggregations
track: elasticsearch
group: Aggregations
tags: [elasticsearch, aggregations]
prerequisites: [query-dsl-overview, fields-data-types]
see-also: [bucket-aggregations, cardinality-percentiles, runtime-fields]
---

# Metric aggregations

Aggregations that compute a single number (or small set of numbers) over a set of documents — sums, averages, min/max, and statistical summaries — usually as the leaf of a [[bucket-aggregations|bucket]] tree.

## Why it matters

Every dashboard number — total revenue, average latency, max queue depth — is a metric aggregation. They run on **doc values** (a columnar, on-disk per-field store), not the [[inverted-index|inverted index]], so they read one contiguous column instead of scanning documents. Getting the field type and `missing` handling right is the difference between a correct KPI and a silently wrong one.

## How it works

A metric agg consumes the documents in its enclosing bucket (or the whole result set at the top level) and emits values.

| Agg | Output | Notes |
|---|---|---|
| `avg` / `sum` / `min` / `max` | one value | single-value |
| `stats` | count, min, max, avg, sum | one pass |
| `extended_stats` | stats + variance, std dev, bounds | adds sum-of-squares |
| `value_count` | count of values (not docs) | counts each array element |
| `weighted_avg` | weighted mean | needs `value` + `weight` |

- **Doc values required** — disable them (`doc_values: false`) and the field can't be aggregated; `text` fields have none, so you aggregate on a [[multi-fields|keyword sub-field]].
- **`missing`** — supply a default (e.g. `"missing": 0`) or docs lacking the field are skipped entirely, skewing `avg` and `value_count`.
- **Scripted/runtime values** — a [[runtime-fields|runtime field]] or `script` can compute the metric per doc, at CPU cost since there's no precomputed column.
- **Numeric only** — `sum`/`avg` need a numeric or `date` field; pointing them at a keyword errors.

## Example

```
GET /orders/_search
{ "size": 0,
  "aggs": {
    "revenue":   { "sum": { "field": "amount" } },
    "avg_basket":{ "avg": { "field": "amount", "missing": 0 } },
    "latency":   { "stats": { "field": "ms" } } } }
```

`size:0` skips returning hits (you only want the numbers). `stats` returns count/min/max/avg/sum in a single pass instead of four separate aggs.

## Pitfalls

- **`value_count` ≠ doc count** — it counts field *values*; a doc with a 3-element array contributes 3. Use the bucket `doc_count` for documents.
- **Floating-point sums** — summing millions of `float` values accumulates rounding error; use `scaled_float` or integer cents for money.
- **`avg` over missing docs** — without `missing`, the denominator is "docs that have the field," not your bucket size — a classic dashboard discrepancy.
- **Aggregating `text`** — fails with "fielddata disabled"; enabling fielddata loads terms into heap and can OOM. Aggregate the `.keyword` instead.

## See also

- [[bucket-aggregations]]
- [[cardinality-percentiles]]
