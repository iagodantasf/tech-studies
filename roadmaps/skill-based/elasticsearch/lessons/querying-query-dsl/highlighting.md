---
title: Highlighting
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, highlighting]
prerequisites: [full-text-search, inverted-index]
see-also: [full-text-search, match-match-phrase-queries, relevance-scoring-bm25]
---

# Highlighting

Highlighting returns snippets of matching fields with the query terms wrapped in tags, so a UI can show *why* a document matched.

## Why it matters

Search results without highlighted context force users to guess relevance. Highlighting extracts the best-matching fragments and emphasizes the hit terms — standard in any search UI — but it re-analyzes or re-reads field content per hit, so the choice of highlighter directly affects latency and storage.

## How it works

Three highlighter implementations trade speed for accuracy and storage.

| Highlighter | Needs | Speed | Accuracy on phrases |
|---|---|---|---|
| `unified` (default) | nothing extra | good | good (BM25-ranked fragments) |
| `plain` | re-analyzes `_source` | slow on big fields | exact, small docs only |
| `fvh` (fast vector) | `term_vector: with_positions_offsets` | fast on big fields | excellent |

- **`unified`** uses the Lucene `Highlighter` with a BM25-like fragment scorer; works from postings or term vectors when available.
- **Tags** — default `<em>…</em>`; override with `pre_tags`/`post_tags`.
- **Fragmentation** — `fragment_size` (chars, default 100) and `number_of_fragments` (default 5) bound the snippets; `number_of_fragments:0` returns the whole field highlighted.
- **`require_field_match:false`** highlights fields other than the one queried (useful with [[match-match-phrase-queries|multi_match]]).

## Example

```
{ "query": { "match": { "body": "climate change" } },
  "highlight": {
    "fields": { "body": { "fragment_size": 120, "number_of_fragments": 3 } },
    "pre_tags": ["<mark>"], "post_tags": ["</mark>"] } }
// → "...the science of <mark>climate</mark> <mark>change</mark> shows..."
```

The `unified` highlighter ranks the 3 best fragments by relevance, not document order.

## Pitfalls

- **`fvh` needs term vectors** — enabling `term_vector: with_positions_offsets` roughly doubles that field's index size; only worth it for large highlighted fields.
- **`plain` on big fields** — re-analyzes the whole `_source` per hit; can dominate query latency on multi-KB documents.
- **Mapping mismatch** — highlighting a field whose analyzer changed since indexing produces wrong offsets/missing marks.
- **`number_of_fragments:0` cost** — returning the entire field highlighted defeats fragment limits and inflates response size.

## See also

- [[full-text-search]]
- [[match-match-phrase-queries]]
