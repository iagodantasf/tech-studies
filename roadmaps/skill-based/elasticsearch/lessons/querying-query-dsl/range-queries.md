---
title: Range queries
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, term-queries]
prerequisites: [core-field-types-text-keyword-numeric-date-boolean, term-level-queries]
see-also: [term-level-queries, query-vs-filter-context, sorting]
---

# Range queries

A `range` query matches documents whose numeric, `date`, or `ip` field falls within `gte`/`gt`/`lte`/`lt` bounds.

## Why it matters

Time windows ("last 24h"), price bands, and IP subnets are everywhere in [[use-cases-search-logging-observability-analytics|logging and analytics]]. `range` on a `date` field with `now`-based math is the backbone of every Kibana dashboard and ILM-aged index query, and getting the rounding right is the difference between a cached, fast filter and a query that re-runs every millisecond.

## How it works

Bounds are inclusive (`gte`/`lte`) or exclusive (`gt`/`lt`); date fields support **date math** and `format`.

| Param | Meaning |
|---|---|
| `gte` / `gt` | lower bound, inclusive / exclusive |
| `lte` / `lt` | upper bound, inclusive / exclusive |
| `format` | parse pattern for the bound strings |
| `time_zone` | offset applied before comparison |
| `relation` | `intersects`/`contains`/`within` for `*_range` field types |

- **Date math** — `now-1d/d` means "one day ago, rounded down to the day"; `||` appends math to a literal, e.g. `2024-05-01||+1M/M`.
- **Filter context** — range almost always belongs under [[query-vs-filter-context|filter]]; it's a yes/no test and cacheable.
- **Indexed for range** — numeric/`date` fields use a BKD tree (block k-d tree), giving log-time range scans, not a full term walk.
- **`time_zone`** shifts the *query* bounds, not stored UTC values.

## Example

```
{ "bool": { "filter": [
    { "range": { "@timestamp": { "gte": "now-1h/h", "lte": "now/h" } } },
    { "range": { "price":      { "gte": 50, "lt": 100 } } } ] } }
```

`now-1h/h` rounds to the top of the hour, so the bound stays stable for 60 minutes and the [[caching-query-request-cache|query cache]] hits repeatedly.

## Pitfalls

- **Unrounded `now`** — `gte: now-1h` (no `/h`) changes every millisecond, defeating caching; round to `/h` or `/m`.
- **`range` on `keyword`/`text`** — does lexicographic, not numeric, comparison: `"100" < "20"`; store numbers as numeric types.
- **Off-by-one bounds** — mixing `gte` and `lt` for buckets avoids double-counting boundary values; be deliberate.
- **time_zone with epoch** — only works on `date` fields with a format; epoch-millis bounds ignore `time_zone`.

## See also

- [[term-level-queries]]
- [[sorting]]
