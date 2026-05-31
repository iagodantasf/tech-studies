---
title: Full-text search
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, full-text]
prerequisites: [analyzers-standard-language-custom, inverted-index]
see-also: [match-match-phrase-queries, relevance-scoring-bm25, term-level-queries]
---

# Full-text search

Full-text search matches `text` fields by analyzing the query the same way the field was indexed, then ranking hits by [[relevance-scoring-bm25|relevance]] rather than returning a flat yes/no set.

## Why it matters

It is the reason to reach for Elasticsearch over a SQL `LIKE`. Tokenization, stemming, stopwords, and BM25 scoring turn "noise cancelling headphones" into a ranked list where the best documents float to the top — handling word order, partial matches, and typos that exact comparison cannot.

## How it works

The query string passes through the field [[analyzers-standard-language-custom|analyzer]], producing terms scored against the [[inverted-index]].

| Query | Spans fields? | Best for |
|---|---|---|
| `match` | one | single-field search bars |
| `multi_match` | many | search across title+body+tags |
| `query_string` | many | power-user syntax (`AND`, `"..."`, `field:`) |
| `simple_query_string` | many | safe user input (never throws on bad syntax) |

- **`multi_match` types** — `best_fields` (default, takes the single best field score), `most_fields` (sums all), `cross_fields` (treats fields as one big field, good for names).
- **Recall knobs** — `operator`, `minimum_should_match`, and `fuzziness` trade precision for coverage.
- **Per-field boost** — `"fields": ["title^3", "body"]` weights title matches 3×.
- **Scoring** — each term contributes [[relevance-scoring-bm25|BM25]]; the analyzer must match index and query side or hits vanish.

## Example

```
{ "multi_match": {
    "query": "wireless headphones",
    "type": "best_fields",
    "fields": ["title^3", "description"],
    "operator": "and",
    "fuzziness": "AUTO" } }
```

A doc with both words in `title` outscores one matching only `description`; `fuzziness:AUTO` still catches "headphnes".

## Pitfalls

- **`query_string` on raw user input** — a stray `]` or `AND` throws a 400; expose `simple_query_string` to end users instead.
- **`cross_fields` requires shared analyzers** — mixed analyzers per field silently fall back to per-field scoring.
- **Over-boosting** — extreme boosts (`title^100`) make every result title-driven, hiding body relevance.
- **Stopwords drop signal** — searching "to be or not to be" against an `english` analyzer leaves almost no terms.

## See also

- [[match-match-phrase-queries]]
- [[relevance-scoring-bm25]]
