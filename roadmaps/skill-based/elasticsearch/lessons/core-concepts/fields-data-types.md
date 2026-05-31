---
title: Fields & data types
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, field-types]
prerequisites: [documents]
see-also: [mappings, core-field-types-text-keyword-numeric-date-boolean, multi-fields]
---

# Fields & data types

Every field in a [[documents|document]] has a declared data type that decides how it is indexed, what queries work on it, and how it is stored for sorting and aggregating.

## Why it matters

The type is not cosmetic — it changes the on-disk structures. A `text` field builds an [[inverted-index|inverted index]] for full-text but **cannot** be sorted or aggregated; a `keyword` field is exact-match and aggregatable but never tokenized. Choosing `text` where you meant `keyword` (or vice versa) is the single most common reason a query "returns nothing" or an aggregation errors out.

## How it works

Types map to different Lucene structures; many fields need *both*, via [[multi-fields|multi-fields]].

| Type | Indexed for | Sort/agg? | Typical use |
|---|---|---|---|
| `text` | Full-text (analyzed) | No (needs `fielddata`) | Titles, body, descriptions |
| `keyword` | Exact term | Yes (doc values) | IDs, tags, status, emails |
| `long`/`double` | Range + exact | Yes | Prices, counts |
| `date` | Range (epoch millis) | Yes | Timestamps |
| `boolean` | Exact | Yes | Flags |
| `geo_point` | Geo queries | Yes | Coordinates |

- **Doc values** — a columnar, on-disk store built for every aggregatable type; this is what powers [[sorting]] and aggregations without loading the field into heap.
- **`fielddata`** — the in-heap alternative for sorting on `text`; off by default because it can OOM the node.
- **A field can be two types at once** — index `city` as `text` for search and `city.raw` as `keyword` for faceting.

## Example

```
"properties": {
  "title":  { "type": "text",
              "fields": { "raw": { "type": "keyword" } } },
  "price":  { "type": "scaled_float", "scaling_factor": 100 },
  "tags":   { "type": "keyword" }
}
```

`title` searches full-text; `title.raw` sorts/aggregates. `scaled_float` stores `24.99` as the integer `2499` — smaller and exact for money.

## Pitfalls

- **Aggregating on `text`** errors unless you enable `fielddata` (a heap trap) — aggregate on the `keyword` multi-field instead.
- **Numbers-as-keyword** — storing IDs that are never range-queried as `keyword` is faster than numeric; pick by access pattern, not by JSON type.
- **`scaled_float` overflow** — `scaling_factor: 100` on a huge value can exceed `long`; size the factor to the real range.

## See also

- [[mappings]]
- [[core-field-types-text-keyword-numeric-date-boolean]]
