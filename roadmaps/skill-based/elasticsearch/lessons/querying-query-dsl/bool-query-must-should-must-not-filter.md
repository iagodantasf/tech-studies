---
title: Bool query (must / should / must_not / filter)
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, compound-queries]
prerequisites: [query-vs-filter-context, term-level-queries]
see-also: [compound-queries, query-dsl-overview, relevance-scoring-bm25]
---

# Bool query (must / should / must_not / filter)

`bool` is the primary compound query: it combines leaf clauses with boolean logic across four occurrence types, each with distinct scoring and caching behavior.

## Why it matters

Almost every non-trivial search is a `bool` tree — a scored full-text part AND a set of structured filters. Mastering which bucket a clause belongs in directly controls relevance, performance, and cache reuse; it is the single most important query in the [[query-dsl-overview|DSL]].

## How it works

Four arrays, combined with AND/OR semantics.

| Occurrence | Logic | [[query-vs-filter-context|Context]] | Scores |
|---|---|---|---|
| `must` | AND, required | query | yes |
| `filter` | AND, required | filter | no (cached) |
| `should` | OR, optional | query | yes |
| `must_not` | AND NOT | filter | no (cached) |

- **`should` boosts, doesn't gate** — when at least one `must`/`filter` exists, `should` clauses only add to `_score`; default `minimum_should_match` is then 0.
- **No `must`/`filter`, only `should`** — `minimum_should_match` defaults to 1, so `should` becomes the required OR set.
- **Scores combine additively** — total `_score` = sum of matching `must` + `should` clause scores.
- **`filter`/`must_not` are cached** as bitsets per [[segments|segment]] and cost no scoring.

## Example

```
{ "bool": {
    "must":     { "match": { "desc": "running shoes" } },
    "filter":   [ { "term": { "brand": "acme" } },
                  { "range": { "price": { "lte": 120 } } } ],
    "should":   [ { "match": { "color": "red" } } ],   ← boost only
    "must_not": [ { "term": { "discontinued": true } } ],
    "minimum_should_match": 0 } }
```

Red shoes rank higher, but non-red still match because `should` is optional here.

## Pitfalls

- **Expecting `should` to filter** — when a `must` is present, an unmatched `should` does *not* exclude the doc; set `minimum_should_match: 1` to force OR-gating.
- **Scoring structured constraints** — putting `term`/`range` in `must` instead of `filter` drops caching and skews [[relevance-scoring-bm25|BM25]].
- **Clause explosion** — large `should` lists can exceed `max_clause_count`; collapse with `terms` where possible.
- **Nested `bool` for negation** — `must_not` of a `should` group can double-negate unexpectedly; test with `_explain`.

## See also

- [[compound-queries]]
- [[query-vs-filter-context]]
