---
title: Inverted index
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, inverted-index]
prerequisites: [mappings]
see-also: [analyzers-standard-language-custom, relevance-scoring-bm25, segments]
---

# Inverted index

The inverted index is the core data structure behind full-text search: a sorted dictionary mapping each **term** to the list of documents that contain it (its *postings list*).

## Why it matters

It flips the question. A database asks "for this doc, what terms?"; search asks "for this term, which docs?" — and the inverted index answers in roughly O(matches) instead of scanning every row. This is why Elasticsearch returns hits over billions of [[documents]] in milliseconds, and why analyzers (not the raw string) decide what is searchable.

## How it works

At index time, each `text` field is run through an [[analyzers-standard-language-custom|analyzer]] and the resulting terms are added to a per-field dictionary.

```
docs:  1 "the quick fox"   2 "quick brown dogs"
analyze → 1:[quick,fox]  2:[quick,brown,dog]
inverted index (per field):
  brown → [2]
  fox   → [1]
  quick → [1, 2]
```

- **Postings carry more than IDs** — term frequency (for scoring), positions (for `match_phrase`), and offsets (for [[highlighting]]).
- **Dictionary is sorted** — terms are stored as an FST (finite-state transducer), giving fast prefix/`wildcard` walks, much like a [[tries]].
- **IDF is cheap** — the postings list length *is* the document frequency, so [[relevance-scoring-bm25|BM25]] gets IDF for free.
- **Immutable per [[segments|segment]]** — each segment has its own inverted index; a query merges results across all segments of a [[shards-replicas|shard]].

## Example

Query `match: "quick fox"` analyzes to `[quick, fox]`, then:

```
postings(quick) = [1,2]
postings(fox)   = [1]
union → candidate docs {1,2}; score each by TF×IDF
```

Doc 2 (no "fox") still matches a `should`/OR query but scores lower — the engine never touches docs lacking either term.

## Pitfalls

- **Query/index analyzer mismatch** — indexing stemmed (`running→run`) but searching a `keyword` returns nothing; the terms must be produced the same way both sides.
- **High-cardinality `text`** (UUIDs, long codes) bloats the dictionary for no search value — map as `keyword` instead.
- **Phrase queries need positions** — if `index_options` strips positions to save space, `match_phrase` silently breaks.

## See also

- [[analyzers-standard-language-custom]]
- [[relevance-scoring-bm25]]
