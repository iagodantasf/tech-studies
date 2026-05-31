---
title: Multi-fields
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, mappings]
prerequisites: [core-field-types-text-keyword-numeric-date-boolean, analyzers-standard-language-custom]
see-also: [sorting, bucket-aggregations]
---

# Multi-fields

Indexing the *same* source value several ways under one field via the `fields` parameter — typically a `text` field for full-text search plus a `.keyword` sub-field for exact match, sorting, and [[bucket-aggregations|aggregations]].

## Why it matters

A single field can't be both analyzed (for [[match-match-phrase-queries|match]]) and exact (for [[sorting]]/aggregations). Multi-fields let you have both without duplicating the value in `_source` or in your application. This is why dynamically mapped strings get an automatic `.keyword` sub-field — so you can search the `text` and aggregate the `keyword`.

## How it works

`fields` declares extra "views" of the parent value, each indexed independently from the same `_source`.

- **Reference with dot notation** — parent `city` for full-text, `city.raw` (or `.keyword`) for exact ops.
- **Different analyzers per sub-field** — e.g. parent `standard`, a `.en` sub-field with `english` stemming, a `.ac` sub-field with `edge_ngram` for autocomplete.
- **Source of truth is `_source`** — sub-fields are pure index structures; adding one only re-indexes *new* docs (existing need a [[reindex-api|reindex]] or `update_by_query`).
- **No extra `_source` cost** — the JSON is stored once; each sub-field adds inverted-index/doc-values overhead only.
- **`ignore_above`** on the `.keyword` skips indexing over-long strings (commonly 256).

| Sub-field | Type/analyzer | Used for |
|---|---|---|
| `title` | `text` standard | Full-text match |
| `title.keyword` | `keyword` | Sort, aggregate, exact term |
| `title.en` | `text` english | Stemmed recall |
| `title.ac` | `text` edge_ngram | Autocomplete |

## Example

```
PUT /products
{ "mappings": { "properties": {
  "name": {
    "type": "text",
    "fields": {
      "keyword": { "type": "keyword", "ignore_above": 256 },
      "en":      { "type": "text", "analyzer": "english" }
} } } } }

GET /products/_search
{ "query":  { "match": { "name": "running" } },          // hits name (analyzed)
  "aggs":   { "by_name": { "terms": { "field": "name.keyword" } } },  // exact buckets
  "sort":   [ { "name.keyword": "asc" } ] }               // sort needs keyword
```

## Pitfalls

- **Sorting/aggregating the parent `text`** — fails or forces `fielddata`; always target `.keyword`.
- **Forgetting `ignore_above`** — long values (URLs, blobs) bloat the keyword index; cap them.
- **Assuming retroactive application** — a newly added sub-field is empty for old docs until reindexed.
- **Over-creating sub-fields** — each adds index size; only add the views you actually query.

## See also

- [[core-field-types-text-keyword-numeric-date-boolean]]
- [[sorting]]
