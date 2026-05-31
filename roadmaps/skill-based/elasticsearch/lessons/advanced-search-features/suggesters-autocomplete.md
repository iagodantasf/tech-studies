---
title: Suggesters & autocomplete
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, autocomplete]
prerequisites: [mappings, analyzers-standard-language-custom]
see-also: [fuzzy-wildcard-search, term-level-queries, multi-fields]
---

# Suggesters & autocomplete

Suggesters return word- or phrase-level suggestions for a query string — "did you mean?" corrections and type-ahead completion — served from purpose-built data structures rather than the main [[inverted-index]].

## Why it matters

Autocomplete and spell-correction must respond in single-digit milliseconds as the user types each keystroke, far faster than a `match`/[[fuzzy-wildcard-search|wildcard]] query against the full index can deliver. Doing type-ahead with leading-wildcard or `prefix` queries scans the whole term dictionary per shard and collapses under load; suggesters move that cost to index time.

## How it works

Elasticsearch ships four suggesters, each backed by a different structure.

| Suggester | Purpose | Backing structure |
|---|---|---|
| `term` | per-token spell correction | edit-distance over terms |
| `phrase` | whole-phrase "did you mean" | n-gram language model |
| `completion` | prefix type-ahead | in-memory FST |
| `context` | filtered/boosted completion | FST + category/geo context |

- **`completion` type** — declare a field as `"type": "completion"`; it builds a Finite State Transducer ([[tries]]-like) held in heap, giving prefix lookups in roughly the length of the prefix.
- **Weights & dedup** — each input carries a `weight`; suggestions return ranked by weight, not [[relevance-scoring-bm25|BM25]].
- **`context` suggester** — attach `category` or `geo` contexts so "piz" suggests only menu items at *this* restaurant.
- **`fuzzy` on completion** — typo-tolerant prefixes via `fuzziness`, with `prefix_length` to anchor the start.

## Example

```
PUT /place { "mappings": { "properties": {
  "name": { "type": "completion" } } } }
PUT /place/_doc/1 { "name": { "input": ["Pizza Hut","Pizza"], "weight": 30 } }

POST /place/_search { "suggest": { "s": {
  "prefix": "piz", "completion": { "field": "name", "fuzzy": { "fuzziness": 1 } } } } }
```

Typing `piz` returns "Pizza"/"Pizza Hut" from the FST; `pza` still hits via fuzziness 1.

## Pitfalls

- **Heap cost** — the completion FST is loaded entirely into memory; millions of distinct inputs inflate heap and can pressure the [[nodes-cluster|node]].
- **No mid-word match** — completion only matches from the start; for infix ("auto" in "kit*auto*ware") use an `edge_ngram` [[analyzers-standard-language-custom|analyzer]] on a normal `text` field instead.
- **Reindex to update** — changing the completion field or its inputs needs a [[reindex-api|reindex]]; you can't patch the FST in place.
- **`term`/`phrase` need a real corpus** — they suggest from indexed terms, so a sparse index yields poor corrections.

## See also

- [[fuzzy-wildcard-search]]
- [[tries]]
