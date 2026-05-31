---
title: Sorting
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, sorting]
prerequisites: [core-field-types-text-keyword-numeric-date-boolean, mappings]
see-also: [pagination-from-size-search-after-scroll, relevance-scoring-bm25, range-queries]
---

# Sorting

The `sort` clause orders hits by one or more fields (or `_score`), overriding the default [[relevance-scoring-bm25|relevance]] ranking.

## Why it matters

Tables, time-ordered logs, and price-sorted catalogs all need explicit ordering. Sorting on the wrong field type silently fails or is slow, and sorting on analyzed `text` is an outright error — so understanding `doc_values`, multi-level sort, and tiebreakers is essential, especially because deterministic sort underpins `search_after` [[pagination-from-size-search-after-scroll|pagination]].

## How it works

Sort reads columnar **`doc_values`** (on-disk, per-segment), not the [[inverted-index]].

| Field | Sortable? | Mechanism |
|---|---|---|
| numeric / `date` / `boolean` | yes | `doc_values` |
| `keyword` | yes | `doc_values` |
| `text` | no | needs `fielddata` (heap-heavy) |
| `_score` | yes | computed at query time |

- **Multi-level** — `sort` is an array; ties at level 1 break by level 2, etc. Append a unique field for stable order.
- **`missing`** — `_first`/`_last` or a default value controls where null fields land.
- **`mode`** — for multi-valued fields choose `min`/`max`/`avg`/`sum`/`median` (e.g. sort by the cheapest variant `mode:min`).
- **Skips scoring** — sorting by a field alone sets `_score: null`; add `"track_scores": true` if you still need scores.

## Example

```
{ "sort": [
    { "price": { "order": "asc", "mode": "min", "missing": "_last" } },
    { "rating": "desc" },
    { "_shard_doc": "asc" } ] }
```

Cheapest variant first; ties broken by rating, then by `_shard_doc` so `search_after` cursors stay deterministic.

## Pitfalls

- **Sorting on `text`** — throws "Fielddata is disabled"; sort on the `.keyword` sub-field, never enable `fielddata` on a high-cardinality `text` field (it can blow heap).
- **Non-unique sort + pagination** — ties cause skipped/duplicated rows across pages; always end with a unique tiebreaker.
- **Sort vs `track_total_hits`** — when sorting, ES may stop early and report `total` as a lower bound (`"gte"`) unless `track_total_hits:true`.
- **Geo/script sort cost** — `_geo_distance` and `script` sorts compute per doc per shard; expensive on large result sets.

## See also

- [[pagination-from-size-search-after-scroll]]
- [[relevance-scoring-bm25]]
