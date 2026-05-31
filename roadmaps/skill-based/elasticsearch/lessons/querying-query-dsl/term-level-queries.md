---
title: Term-level queries
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, term-queries]
prerequisites: [core-field-types-text-keyword-numeric-date-boolean, inverted-index]
see-also: [match-match-phrase-queries, range-queries, query-vs-filter-context]
---

# Term-level queries

Term-level queries match the *exact, un-analyzed* value stored in the [[inverted-index]] — `term`, `terms`, `exists`, `prefix`, `wildcard`, `fuzzy`, `ids`, and [[range-queries|range]].

## Why it matters

They power structured filtering: status enums, IDs, tags, booleans, dates. Because they bypass [[analyzers-standard-language-custom|analysis]], they're the correct tool on `keyword`, numeric, `date`, and `boolean` fields — and the classic footgun on `text` fields, where the stored tokens are lowercased/stemmed and never equal the raw string.

## How it works

The query value is looked up verbatim against the index terms; no tokenizer runs.

| Query | Matches | Notes |
|---|---|---|
| `term` | one exact term | use on `keyword`/numeric/`boolean` |
| `terms` | any of a list | OR over values; supports terms-lookup |
| `exists` | docs where field has a value | inverse via `must_not` |
| `prefix` | terms starting with X | scans the term dictionary |
| `wildcard` | `*`/`?` glob | leading `*` is very slow |
| `fuzzy` | terms within edit distance | Levenshtein, `fuzziness:AUTO` |

- **Lives in [[query-vs-filter-context|filter context]]** naturally — exact matches rarely need scoring, so wrap in `filter` for caching.
- **`terms` lookup** — fetch the value list from another document (e.g. a user's group IDs) instead of inlining.
- **`case_insensitive: true`** (7.10+) lets `term`/`prefix`/`wildcard` ignore case on `keyword` fields.

## Example

```
{ "bool": { "filter": [
    { "terms": { "tags": ["sale", "clearance"] } },
    { "term":  { "status": "active" } },
    { "exists": { "field": "discount_pct" } } ] } }
```

If `status` were a `text` field analyzed to lowercase, `term:"active"` would match "ACTIVE" only by luck — always target the `keyword` sub-field.

## Pitfalls

- **`term` on analyzed `text`** — the #1 mistake; "New York" is indexed as `[new, york]`, so `term:"New York"` returns nothing. Use `match`, or `term` on `field.keyword`.
- **`wildcard`/`prefix` with leading wildcards** scan the entire term dictionary per shard — O(unique terms); prefer a [[search-engine-fundamentals|reverse]] field or completion suggester.
- **`fuzzy` cost** — expands to many candidate terms; cap with `max_expansions` and `prefix_length`.
- **`terms` size limit** — `index.max_terms_count` defaults to 65,536; huge IN-lists fail.

## See also

- [[match-match-phrase-queries]]
- [[range-queries]]
