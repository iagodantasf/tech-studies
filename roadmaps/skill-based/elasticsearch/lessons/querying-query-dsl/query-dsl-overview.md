---
title: Query DSL overview
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, query-dsl]
prerequisites: [inverted-index, mappings]
see-also: [query-vs-filter-context, bool-query-must-should-must-not-filter, full-text-search]
---

# Query DSL overview

The Query DSL is Elasticsearch's JSON tree language for describing searches, sent in the `query` field of the `_search` request body.

## Why it matters

Every read path — search bars, log filters, dashboards, alerting rules — compiles down to a Query DSL tree. Knowing the two families (leaf vs compound) and the two execution contexts (scoring vs filter) is what separates a query that returns the right hits fast from one that scans, mis-scores, or silently returns nothing because a [[term-level-queries|term]] query hit an analyzed field.

## How it works

A query is a single root JSON object whose one key names a query type; values nest recursively.

| Family | Examples | Role |
|---|---|---|
| Leaf | `match`, `term`, `range` | match a value in one field |
| Compound | `bool`, `dis_max`, `function_score` | combine/alter other queries |

- **Two clause types** — [[full-text-search|full-text]] (`match`, runs the field [[analyzers-standard-language-custom|analyzer]] on your input) vs [[term-level-queries|term-level]] (`term`, exact, no analysis).
- **Context decides cost** — query context computes a `_score`; [[query-vs-filter-context|filter context]] (under `filter`/`must_not`) skips scoring and is cacheable.
- **`GET /idx/_search`** with a body, or the compact `?q=` query-string param for ad-hoc use.
- **Mapping-driven** — the field's [[mappings|mapping]] type determines which query is valid; `match` on a `keyword` field still works but does no tokenization.

## Example

```
GET /products/_search
{ "query": {
    "bool": {
      "must":   { "match": { "name": "wool socks" } },
      "filter": [ { "term":  { "in_stock": true } },
                  { "range": { "price": { "lte": 30 } } } ] } } }
```

The `match` clause scores relevance; the two `filter` clauses only include/exclude and are cached for reuse.

## Pitfalls

- **`match` vs `term` confusion** — `term` on a `text` field compares against analyzed tokens, so `term:"Wool Socks"` finds nothing (indexed as `[wool, socks]`).
- **Empty `must` ≠ match-all** — a `bool` with only `filter` clauses returns hits with `_score: 0`; use `match_all` if you need a positive baseline score.
- **Deeply nested trees** hit `indices.query.bool.max_clause_count` (default 1024 since 8.x is dynamic) and blow up parse/heap.

## See also

- [[query-vs-filter-context]]
- [[bool-query-must-should-must-not-filter]]
