---
title: Dynamic vs explicit mapping
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, mappings]
prerequisites: [mappings, fields-data-types]
see-also: [core-field-types-text-keyword-numeric-date-boolean, index-templates]
---

# Dynamic vs explicit mapping

The choice between letting Elasticsearch infer field types from the first document it sees (dynamic) versus declaring them up front in the [[mappings]] (explicit).

## Why it matters

Dynamic mapping is great for getting started and for unpredictable log payloads, but the *first* value of a field locks its type for the life of the index — you cannot change a field's type without a [[reindex-api|reindex]]. Unbounded dynamic fields also cause **mapping explosion**, where thousands of distinct keys blow past `index.mapping.total_fields.limit` (default 1000) and destabilize the [[nodes-cluster|cluster]].

## How it works

When a doc contains an unmapped field, Elasticsearch infers a type and adds it to the mapping; subsequent docs must conform.

- **Inference rules** — JSON `true`→`boolean`, `42`→`long`, `3.14`→`float`, a date-looking string→`date` (if `date_detection` on), other strings→`text` + a `.keyword` [[multi-fields|sub-field]].
- **`dynamic` setting** (per object): `true` (add new fields), `runtime` (add as [[runtime-fields|runtime fields]], not indexed), `false` (ignore but store in `_source`), `strict` (reject the whole doc).
- **Explicit** — you `PUT` the mapping before indexing, or pin it via an [[index-templates|index template]] so every new index is born correctly typed.
- **Dynamic templates** — match by name/path/type to control inference (e.g. map all `*_id` strings as `keyword`).

| `dynamic` | New field behavior | Use when |
|---|---|---|
| `true` | Auto-added & indexed | Prototyping, known-bounded data |
| `runtime` | Added as runtime field | Logs you query rarely |
| `false` | Stored, not indexed | Pass-through blobs |
| `strict` | Doc rejected (400) | Tightly governed schemas |

## Example

```
PUT /events
{ "mappings": {
  "dynamic": "strict",
  "properties": {
    "msg":  { "type": "text" },
    "code": { "type": "integer" }
} } }

POST /events/_doc
{ "msg": "boom", "code": 500, "extra": "x" }   // 400: mapping set to strict
```

Without `strict`, `extra` would silently become a `text`+`keyword` field and count against the field limit forever.

## Pitfalls

- **First-write wins** — index `"007"` and the field becomes `text`, not `long`; later numeric range queries fail.
- **Mapping explosion** — high-cardinality keys (user IDs as field names) exhaust `total_fields.limit`; use `flattened` or `runtime` instead.
- **`date_detection` surprises** — a string like `"2024-1"` may or may not be parsed as a date; disable detection for free-text fields.
- **Numeric widening** — first value `1` gives `long`; a later `1.5` is rejected, not promoted.

## See also

- [[mappings]]
- [[index-templates]]
