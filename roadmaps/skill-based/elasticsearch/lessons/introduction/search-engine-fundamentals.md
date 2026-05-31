---
title: Search engine fundamentals
track: elasticsearch
group: Introduction
tags: [elasticsearch, search-theory]
prerequisites: []
see-also: [apache-lucene-foundations, inverted-index, relevance-scoring-bm25]
---

# Search engine fundamentals

The concepts every full-text engine is built on: analysis, the inverted index, and relevance ranking — the machinery that turns "find documents about X" into a fast, ordered result list.

## Why it matters

A database `LIKE '%term%'` scans every row and treats all matches as equal. A search engine inverts the problem at index time so lookups are O(matches), and it *ranks* results so the best ones come first. Understanding analysis → indexing → scoring is what lets you debug "why didn't this match?" and "why is the wrong doc first?".

## How it works

Two pipelines that must agree: text is **analyzed** the same way at index time and query time.

- **Analysis** — a [[character-encodings|character]] stream is split by a [[tokenizers|tokenizer]] into terms, then [[token-filters-character-filters|token filters]] lowercase, stem, and drop stopwords. `"Running Shoes"` → `[run, shoe]`.
- **Inverted index** — maps each term → a **postings list** of doc IDs (plus positions/frequencies). This is the same idea as a [[tries]]/dictionary keyed by term (see [[inverted-index]]).
- **Scoring** — for a query, intersect/union postings, then rank by [[relevance-scoring-bm25|BM25]] using term frequency (TF) and inverse document frequency (IDF).

| Step | Input | Output |
|---|---|---|
| Tokenize | "Quick Foxes!" | `[Quick, Foxes]` |
| Filter (lowercase, stem) | `[Quick, Foxes]` | `[quick, fox]` |
| Index | `[quick, fox]` | postings: `quick→{1}`, `fox→{1}` |

## Example

Querying `"fox"` against three docs:

```
term "fox" → postings [doc1, doc4, doc9]
score(doc) = TF(fox, doc) × IDF(fox)
IDF rises when "fox" is rare across the corpus → rarer terms weigh more
```

The engine never reads doc2 or doc3 — it jumps straight to the postings list, which is the entire performance win over a row scan.

## Pitfalls

- **Mismatched analyzers** — indexing with stemming but querying a `keyword` (or vice versa) silently returns nothing.
- **Treating relevance as binary** — full-text returns a *ranked* list; if you only need yes/no, use a [[query-vs-filter-context|filter]] and skip scoring.
- **Forgetting precision/recall trade-offs** — stemming and fuzzy matching boost recall but can hurt precision; tune per field.

## See also

- [[inverted-index]]
- [[relevance-scoring-bm25]]
