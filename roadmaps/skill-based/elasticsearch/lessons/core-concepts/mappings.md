---
title: Mappings
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, mappings]
prerequisites: [fields-data-types]
see-also: [dynamic-vs-explicit-mapping, analyzers-standard-language-custom, index-templates]
---

# Mappings

A mapping is the schema of an [[indices|index]]: the definition of each field's [[fields-data-types|type]], how it is analyzed, and how it is stored — the contract that turns JSON into searchable structures.

## Why it matters

The mapping is decided once and is mostly frozen: you can *add* fields but cannot change the type of an existing one without [[reindex-api|reindexing]]. A sloppy first mapping (dynamic everything, `text` on IDs, no analyzer choices) creates index bloat and broken queries that you only discover in production. Mappings are where search quality and storage cost are really set.

## How it works

Elasticsearch can infer a mapping ([[dynamic-vs-explicit-mapping|dynamic]]) or you declare one explicitly.

- **Dynamic mapping** — on first sight of a field, ES guesses: a JSON string becomes `text` *plus* a `keyword` sub-field; a number becomes `long`/`float`. Convenient, but guesses are often wrong (dates-as-text, every string doubly indexed).
- **`dynamic` control** — set per index/object: `true` (auto-add), `false` (store in `_source`, ignore for search), or `strict` (reject unknown fields — fail fast).
- **Add-only evolution** — `PUT /idx/_mapping` can introduce new fields; existing field types are immutable.

| Setting | Effect |
|---|---|
| `dynamic: strict` | Reject docs with unmapped fields |
| `index: false` | Store but don't index (no querying that field) |
| `doc_values: false` | Save disk, lose sort/agg on the field |
| `ignore_above: 256` | Skip indexing `keyword` values over N chars |

## Example

```
PUT /events
{ "mappings": {
    "dynamic": "strict",
    "properties": {
      "ts":      { "type": "date" },
      "level":   { "type": "keyword" },
      "message": { "type": "text", "analyzer": "english" } } } }
```

`strict` rejects a typo'd field like `mesage` at index time rather than silently swallowing it — turning a data bug into a loud `400`.

## Pitfalls

- **Mapping explosion** — dynamic mapping over user-controlled keys (e.g. arbitrary JSON metadata) can create thousands of fields and blow past the 1000-field default limit; use `flattened` or `strict`.
- **Changing a type in place** is impossible — reindex into a new index with the corrected mapping, then swap the alias.
- **Forgetting `keyword` for exact match** — a pure `text` field can't be used for sorting, faceting, or exact term lookups.

## See also

- [[dynamic-vs-explicit-mapping]]
- [[inverted-index]]
