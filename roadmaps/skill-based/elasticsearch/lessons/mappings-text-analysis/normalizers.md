---
title: Normalizers
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, analysis]
prerequisites: [core-field-types-text-keyword-numeric-date-boolean, token-filters-character-filters]
see-also: [analyzers-standard-language-custom, term-level-queries]
---

# Normalizers

A normalizer is a stripped-down [[analyzers-standard-language-custom|analyzer]] for `keyword` fields: it applies character and token filters but produces exactly **one** token, so the value stays exact while gaining case- and accent-insensitive matching.

## Why it matters

`keyword` fields are matched verbatim, so `"ACTIVE"` won't equal `"active"` and aggregation buckets split by case. You can't attach a regular analyzer to a `keyword` (it would tokenize). A normalizer solves this: `"Café"` and `"cafe"` collapse to one bucket and match the same [[term-level-queries|term]] query — without turning the field into searchable `text`.

## How it works

A normalizer runs `char_filter`s and a restricted set of single-token `filter`s; **no tokenizer** is allowed, guaranteeing one token out.

- **Allowed filters** — only those that don't split tokens: `lowercase`, `uppercase`, `asciifolding`, `trim`, `mapping`, `pattern_replace`, and similar.
- **Not allowed** — `stemmer`, `synonym`, `ngram`, or any tokenizer (would emit multiple tokens).
- **Applied at both** index and query time, so a query term is normalized to match the stored term.
- **Built-ins** — only the `lowercase` normalizer ships predefined; anything else is a `custom` normalizer in index settings.
- **Aggregations** — buckets key off the normalized token, so case variants merge.

| Field setup | Stored term for "Café" | `term: "cafe"` matches? |
|---|---|---|
| `keyword`, no normalizer | `Café` | No |
| `keyword` + `lowercase` norm | `café` | No (accent) |
| `keyword` + `lowercase`,`asciifolding` | `cafe` | Yes |

## Example

```
PUT /users
{ "settings": { "analysis": { "normalizer": {
    "lc_fold": { "type": "custom", "filter": ["lowercase", "asciifolding"] } } } },
  "mappings": { "properties": {
    "country": { "type": "keyword", "normalizer": "lc_fold" } } } }

POST /users/_doc { "country": "Perú" }
GET  /users/_search { "query": { "term": { "country": "peru" } } }   // matches
```

The stored term is `peru`; a `terms` aggregation now reports one `peru` bucket instead of splitting `Perú`/`peru`/`PERU`.

## Pitfalls

- **Using a tokenizer** — settings are rejected; normalizers forbid tokenizers and multi-token filters.
- **Changing it later** — like analyzers, a new normalizer only affects new docs; existing values need a [[reindex-api|reindex]].
- **`match` vs `term`** — even normalized, query with `term` (or `match` which also normalizes); a raw mismatch still fails.
- **Highlighting** — `keyword` + normalizer highlights the whole field, not sub-spans.

## See also

- [[token-filters-character-filters]]
- [[core-field-types-text-keyword-numeric-date-boolean]]
