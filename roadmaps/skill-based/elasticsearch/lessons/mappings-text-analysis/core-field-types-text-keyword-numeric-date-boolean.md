---
title: Core field types (text, keyword, numeric, date, boolean)
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, field-types]
prerequisites: [mappings, fields-data-types]
see-also: [multi-fields, term-level-queries]
---

# Core field types (text, keyword, numeric, date, boolean)

The handful of [[fields-data-types|field types]] that cover the vast majority of mappings, and the rule that decides between them: do you need to *search inside* the value or *match it exactly*?

## Why it matters

Picking `text` vs `keyword` is the single most consequential mapping decision. `text` is [[analyzers-standard-language-custom|analyzed]] into terms for full-text matching but cannot be sorted or aggregated efficiently; `keyword` is a single exact token, perfect for filters, sorts, and [[bucket-aggregations|aggregations]] — but `match` on it won't do partial matching. Getting this wrong forces a [[reindex-api|reindex]].

## How it works

Each type controls how a value is indexed and which queries/aggregations it supports.

- **`text`** — runs through an analyzer → multiple terms in the [[inverted-index]]; for full-text [[match-match-phrase-queries|match]]. Not aggregatable unless `fielddata: true` (memory-heavy; avoid).
- **`keyword`** — stored verbatim as one term; for [[term-level-queries|term]] filters, sorting, aggregations. `ignore_above` (default 2147483647; commonly set 256) drops over-long values from the index.
- **Numeric** — `long`/`integer`/`short`/`byte`, `double`/`float`/`half_float`, `scaled_float`. Indexed as BKD trees for fast [[range-queries|range]] queries. Pick the *smallest* type that fits.
- **`date`** — stored internally as `long` epoch-millis (UTC); `format` controls parsing of input strings.
- **`boolean`** — accepts `true`/`false` and the strings `"true"`/`"false"`.

| Type | Sort/Agg | Full-text match | Typical use |
|---|---|---|---|
| `text` | No | Yes | Body, titles, descriptions |
| `keyword` | Yes | Exact only | Status, tags, IDs, enums |
| `long`/`double` | Yes | n/a (range) | Counts, prices |
| `date` | Yes | n/a (range) | Timestamps |
| `boolean` | Yes | n/a | Flags |

## Example

```
PUT /orders
{ "mappings": { "properties": {
  "status":     { "type": "keyword" },
  "note":       { "type": "text" },
  "total":      { "type": "scaled_float", "scaling_factor": 100 },
  "created_at": { "type": "date", "format": "strict_date_optional_time||epoch_millis" }
} } }
```

`scaled_float` stores `19.99` as the integer `1999` — cheaper and exact, dodging float rounding (see [[floating-point-representation]]).

## Pitfalls

- **Aggregating on `text`** — fails or silently triggers `fielddata`; aggregate on the `.keyword` [[multi-fields|sub-field]] instead.
- **`keyword` for free text** — exact-only; `match` for a substring returns nothing.
- **Oversized numeric types** — `long` for a value that fits `integer` wastes disk and memory across billions of docs.
- **Locale-dependent date parsing** — non-ISO formats break across nodes; prefer `strict_date_optional_time`.

## See also

- [[multi-fields]]
- [[mappings]]
