---
title: Compound queries
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, compound-queries]
prerequisites: [bool-query-must-should-must-not-filter, relevance-scoring-bm25]
see-also: [bool-query-must-should-must-not-filter, full-text-search, query-dsl-overview]
---

# Compound queries

Compound queries wrap or combine other queries to change their logic or score — `bool`, `dis_max`, `function_score`, `boosting`, and `constant_score`.

## Why it matters

Real relevance tuning lives here. Beyond AND/OR, you often need to take the single best field instead of summing ([[full-text-search|cross-field]] search), boost by recency or popularity, demote (not exclude) certain docs, or strip scoring entirely. Each compound query is a precise tool for one of those shapes.

## How it works

Each compound type composes child queries with different score arithmetic.

| Query | Combines via | Use case |
|---|---|---|
| `bool` | AND/OR/NOT, additive | general logic |
| `dis_max` | max of child scores + `tie_breaker` | best single field wins |
| `function_score` | query × functions | boost by field value/decay/script |
| `boosting` | positive − `negative_boost` | demote without removing |
| `constant_score` | fixed score | turn a query into a filter |

- **`dis_max`** — takes the highest child score so a strong title match isn't diluted by weak body matches; `tie_breaker` (e.g. 0.3) adds a fraction of the others.
- **`function_score`** — multiply `_score` by `field_value_factor`, `gauss`/`linear`/`exp` decay (recency, geo distance), or a [[painless-scripting|Painless]] `script_score`; combine with `boost_mode`/`score_mode`.
- **`boosting`** — `positive` matches normally, `negative` matches get multiplied by `negative_boost` (0–1) to sink them.
- **`constant_score`** wraps a filter, yielding [[query-vs-filter-context|filter context]] with a flat score.

## Example

```
{ "function_score": {
    "query": { "match": { "title": "smartphone" } },
    "functions": [
      { "gauss": { "released": { "origin": "now", "scale": "30d", "decay": 0.5 } } },
      { "field_value_factor": { "field": "rating", "modifier": "log1p" } } ],
    "score_mode": "sum", "boost_mode": "multiply" } }
```

Newer, higher-rated phones rise: text relevance is multiplied by a recency decay and a dampened rating factor.

## Pitfalls

- **`function_score` order** — `boost_mode` (query vs functions) vs `score_mode` (between functions) are distinct; confusing them flattens or explodes scores.
- **`script_score` cost** — runs per matching doc per shard; cache-unfriendly and slow on large result sets.
- **`dis_max` without `tie_breaker`** ignores secondary matches entirely — sometimes intended, often not.
- **Decay `scale` units** — `scale:"30d"` means score halves (at `decay`) 30 days out; mis-sizing it makes recency dominate or vanish.

## See also

- [[bool-query-must-should-must-not-filter]]
- [[full-text-search]]
