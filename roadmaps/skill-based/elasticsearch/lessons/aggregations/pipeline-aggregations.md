---
title: Pipeline aggregations
track: elasticsearch
group: Aggregations
tags: [elasticsearch, aggregations]
prerequisites: [bucket-aggregations, metric-aggregations]
see-also: [nested-aggregations, cardinality-percentiles]
---

# Pipeline aggregations

Aggregations that take the **output of other aggregations** as their input — derivatives, moving averages, cumulative sums, bucket selection — rather than reading documents directly.

## How it works

A pipeline agg references a sibling or ancestor via a `buckets_path` string (a dotted path with `>` to descend buckets and `.` to pick a metric).

| Agg | Reads | Produces |
|---|---|---|
| `derivative` | a metric per bucket | bucket-to-bucket delta |
| `cumulative_sum` | a metric per bucket | running total |
| `moving_fn` | a window of buckets | smoothed/lagged value |
| `bucket_script` | several sibling metrics | a computed per-bucket value |
| `bucket_selector` | sibling metrics | keeps/drops buckets (filter) |
| `bucket_sort` | sibling metrics | reorders / paginates buckets |

- **Parent vs sibling** — *parent* pipelines (`derivative`, `cumulative_sum`, `moving_fn`) live **inside** the [[bucket-aggregations|histogram]] and add a value to each bucket; *sibling* pipelines (`bucket_selector`, `bucket_script`, `bucket_sort`, `*_bucket`) live **next to** the buckets and operate across them.
- **`gap_policy`** — empty buckets yield no metric; `skip` (default) ignores gaps, `insert_zeros` treats them as 0 — this changes a `derivative` dramatically.
- **Runs last** — pipelines execute on the **reduce** phase after buckets are built, so they can't change which documents fall where; they only post-process.
- **Composable** — a `bucket_script` can feed a `bucket_selector`, e.g. compute a ratio then keep buckets where it exceeds a threshold.

## Why it matters

These answer questions the raw buckets can't: "week-over-week growth," "7-day moving average," "only days where error_rate > 5%." Without them you'd pull every bucket to the client and post-process; pipelines keep that logic server-side and let `bucket_selector` act as a HAVING clause.

## Example

```
"aggs": {
  "daily": {
    "date_histogram": { "field": "ts", "calendar_interval": "day" },
    "aggs": {
      "sales":    { "sum": { "field": "amount" } },
      "growth":   { "derivative": { "buckets_path": "sales" } },
      "to_date":  { "cumulative_sum": { "buckets_path": "sales" } } } } }
```

`growth` is the day-over-day change in `sales`; `to_date` is the running total. Both reference the sibling `sales` metric by path.

## Pitfalls

- **`buckets_path` typos fail silently-ish** — a wrong path errors or returns nulls; the path is relative to the pipeline's position, not the request root.
- **First bucket has no derivative** — there's nothing before it, so `derivative` omits the first bucket; don't assume aligned arrays.
- **`bucket_selector` ≠ `query` filter** — it prunes buckets *after* metrics are computed, so removed buckets still cost CPU and still counted toward `search.max_buckets`.
- **Gap policy on sparse data** — defaulting to `skip` over missing days can make a `moving_fn` average non-adjacent points; use `insert_zeros` when zero is the true value.

## See also

- [[bucket-aggregations]]
- [[metric-aggregations]]
