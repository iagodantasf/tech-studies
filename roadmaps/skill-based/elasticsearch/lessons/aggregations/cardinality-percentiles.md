---
title: Cardinality & percentiles
track: elasticsearch
group: Aggregations
tags: [elasticsearch, aggregations]
prerequisites: [metric-aggregations, bucket-aggregations]
see-also: [pipeline-aggregations, nested-aggregations]
---

# Cardinality & percentiles

Two **approximate** metric aggregations: `cardinality` counts distinct values (HyperLogLog++), and `percentiles` estimates distribution points like the p95 (t-digest). Both trade exactness for bounded memory.

## Why it matters

Exact distinct-counting or exact percentiles over billions of values would need to hold every value in memory — infeasible across [[shards-replicas|shards]]. These sketches give answers in kilobytes with single-digit error, which is why "unique visitors" and "p99 latency" are cheap to compute. The catch: the numbers are estimates, and people routinely forget that.

## How it works

Both build a fixed-size sketch per shard, then merge sketches at the coordinator.

| Agg | Algorithm | Tuning knob | Typical error |
|---|---|---|---|
| `cardinality` | HyperLogLog++ | `precision_threshold` (max 40 000) | < 1% near threshold |
| `percentiles` | t-digest | `compression` (default 100) | tighter at the tails |
| `percentiles` (alt) | HDR histogram | `number_of_significant_value_digits` | bounded by range |

- **`cardinality` is exact below the threshold** — counts under `precision_threshold` are precise; above it, error grows but stays small. Memory ≈ `precision_threshold * 8` bytes per sketch.
- **t-digest** spends resolution on the **extremes**, so p50 is rougher than p99 — good, since tails are what you usually care about.
- **HDR histogram** is an alternative for fixed value ranges (e.g. 0–60 000 ms) with guaranteed precision per digit, at higher memory.
- **`percentile_ranks`** inverts the question: "what fraction of requests were under 500 ms?"

## Example

```
GET /events/_search
{ "size": 0,
  "aggs": {
    "users": { "cardinality": { "field": "user_id", "precision_threshold": 3000 } },
    "lat":   { "percentiles": { "field": "ms", "percents": [50, 95, 99] } } } }
```

`users` is accurate to within ~1% up to ~3000 distinct ids; beyond that it stays close but estimated. `lat` returns the median, p95 and p99 from the merged t-digest.

## Pitfalls

- **Treating estimates as exact** — two `cardinality` results that differ by 1 may be identical underlying sets; never assert equality or compute exact diffs from them.
- **Non-additive across buckets** — summing per-bucket `cardinality` over-counts (a value in two buckets counts twice); you cannot recover a global distinct count by adding bucket counts.
- **Cranking `precision_threshold`** — pushing toward 40 000 raises memory and merge cost on every shard; most "unique" use cases are fine at a few thousand.
- **Percentiles on tiny samples** — p99 of 30 documents is statistically meaningless; the sketch returns a value but it's noise. Check the bucket `doc_count` first.

## See also

- [[metric-aggregations]]
- [[bucket-aggregations]]
