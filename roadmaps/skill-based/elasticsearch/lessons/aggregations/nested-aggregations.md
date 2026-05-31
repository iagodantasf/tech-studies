---
title: Nested aggregations
track: elasticsearch
group: Aggregations
tags: [elasticsearch, nested]
prerequisites: [bucket-aggregations, object-nested-fields]
see-also: [metric-aggregations, pipeline-aggregations]
---

# Nested aggregations

Two distinct ideas share the word "nested": **sub-aggregating** (placing one aggregation inside another) and the **`nested` aggregation** that descends into [[object-nested-fields|nested-type]] fields. This page covers both.

## Why it matters

Sub-aggregation is how analytics gets depth — "per region, per product, average price" is three levels deep. The `nested` agg solves a correctness problem: fields under a `nested` mapping are indexed as hidden sub-documents, invisible to a normal agg, so aggregating them needs a `nested` scope to step into that hidden space and `reverse_nested` to climb back out.

## How it works

Sub-aggregation simply means an `aggs` block inside another agg's body; the child runs once per parent bucket.

- **Tree shape** — a [[bucket-aggregations|bucket]] agg can hold more bucket aggs (deeper grouping) and [[metric-aggregations|metric]] aggs (leaf numbers). Metric aggs are leaves — nothing nests under them.
- **`nested` agg** — required to aggregate a `nested` field; without it the agg sees zero values because the inner docs aren't part of the parent's flat space.
- **`reverse_nested`** — inside a `nested` agg, jumps back to the root document to aggregate a parent-level field (e.g. count *orders*, not line items).
- **Multiplication** — a 3-level tree of sizes 20×20×20 is 8 000 buckets per shard; bucket counts multiply, so depth is the fast path to `search.max_buckets`.

| Construct | Purpose |
|---|---|
| `aggs` inside `aggs` | group within group / metric per bucket |
| `nested` agg | enter `nested`-type sub-docs |
| `reverse_nested` | return to the parent document scope |

## Example

```
GET /products/_search
{ "size": 0,
  "aggs": {
    "variants": {
      "nested": { "path": "skus" },
      "aggs": {
        "by_color": {
          "terms": { "field": "skus.color" },
          "aggs": { "avg_price": { "avg": { "field": "skus.price" } } } } } } } }
```

`variants` enters the hidden `skus` docs; inside it a normal `terms` + `avg` works. Aggregating `skus.color` *without* the `nested` wrapper returns nothing.

## Pitfalls

- **Forgetting the `nested` wrapper** — aggs on `nested` fields silently return empty buckets; the data is there, just out of scope.
- **`doc_count` is inner-doc count** — inside a `nested` agg, `doc_count` counts sub-documents (SKUs), not parent products; use `reverse_nested` to count parents.
- **Bucket explosion by depth** — each nesting level multiplies bucket count; a deep `terms` tree on high-cardinality fields trips the bucket limit fast.
- **Memory of wide trees** — all buckets for a request are held in heap on the coordinating node before reduce; deep + wide can OOM even within `max_buckets`.

## See also

- [[object-nested-fields]]
- [[bucket-aggregations]]
