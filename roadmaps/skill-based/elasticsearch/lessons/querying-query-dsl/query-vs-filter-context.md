---
title: Query vs filter context
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, query-dsl]
prerequisites: [query-dsl-overview]
see-also: [bool-query-must-should-must-not-filter, relevance-scoring-bm25, caching-query-request-cache]
---

# Query vs filter context

Every clause runs in one of two contexts: **query context** asks "how well does this match?" and computes a `_score`; **filter context** asks the yes/no question "does this match?" and skips scoring.

## Why it matters

Picking the wrong context is the most common performance and relevance bug in Elasticsearch. Filter context is cacheable and cheaper, so structured constraints (status flags, date windows, tenant IDs) belong there; scoring them wastes CPU and pollutes [[relevance-scoring-bm25|relevance]]. Putting a true full-text clause in filter context, conversely, throws away the ranking you actually want.

## How it works

Context is determined by *where* a clause sits in the [[bool-query-must-should-must-not-filter|bool]] query, not by the clause type.

| Occurs in | Context | Affects `_score`? | Cacheable? |
|---|---|---|---|
| `must`, `should` | query | yes | no |
| `filter`, `must_not` | filter | no | yes |
| top-level `query` | query | yes | no |

- **Filter cache** — results are stored as a bitset in the node [[caching-query-request-cache|query cache]], keyed by clause + [[segments|segment]]; reused across requests until the segment changes.
- **`constant_score`** wraps any query into filter context, giving every hit a flat `_score` (default 1.0).
- **`must_not` is filter context** — exclusions never need a score, so they're cached too.
- **Heuristic** — anything a human would phrase as "where X" is a filter; "best matching X" is a query.

## Example

```
{ "bool": {
    "must":   [ { "match": { "title": "climate policy" } } ],   ← scored
    "filter": [ { "term":  { "status": "published" } },          ← cached, 0 score
                { "range": { "date": { "gte": "2024-01-01" } } } ] } }
```

Moving the two `filter` clauses into `must` would score them, drop the bitset cache, and let an old-but-published doc outrank a better title match.

## Pitfalls

- **Scoring booleans/dates** — `term:{active:true}` in `must` adds noise to `_score` for no benefit; use `filter`.
- **Cache thrash on volatile fields** — filtering `range` on `now` (e.g. `gte: now-1h`) rounds to the millisecond and never cache-hits; round to `now-1h/h`.
- **`should` in pure-filter queries** — with no `must`, `should` becomes a *minimum_should_match* gate, surprising people expecting an optional boost.

## See also

- [[bool-query-must-should-must-not-filter]]
- [[caching-query-request-cache]]
