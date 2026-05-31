---
title: Match & match_phrase queries
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, full-text]
prerequisites: [analyzers-standard-language-custom, inverted-index]
see-also: [full-text-search, term-level-queries, relevance-scoring-bm25]
---

# Match & match_phrase queries

`match` is the workhorse full-text query: it analyzes your input the same way the field was indexed, then OR-combines the resulting terms; `match_phrase` additionally requires those terms adjacent and in order.

## Why it matters

These two cover the bulk of real search-bar traffic. `match` maximizes recall ("any of these words"), while `match_phrase` enforces exactness ("this exact wording"). Understanding `operator`, `minimum_should_match`, and `slop` lets you dial precision vs recall without resorting to brittle [[term-level-queries|term]] queries on the wrong field.

## How it works

Both run the field's [[analyzers-standard-language-custom|analyzer]] on the query string, producing terms looked up in the [[inverted-index]].

| Query | Default combine | Position-aware? | Key knob |
|---|---|---|---|
| `match` | OR (`should`) | no | `operator`, `minimum_should_match` |
| `match_phrase` | all, in order | yes | `slop` |
| `match_phrase_prefix` | phrase + last term prefix | yes | `max_expansions` |

- **`operator: "and"`** — flips `match` to require every term, raising precision.
- **`minimum_should_match: "75%"`** — keeps OR behavior but demands a fraction of terms match.
- **`slop: 2`** — allows up to 2 position moves, so `match_phrase "quick fox"` (slop 1) matches "quick brown fox".
- **Scoring** — `match` sums per-term [[relevance-scoring-bm25|BM25]]; `match_phrase` requires positions stored in the index (`index_options` must keep them).

## Example

```
{ "match": { "title": { "query": "wireless noise cancelling",
                          "operator": "and" } } }
// indexed terms must include all of [wireless, noise, cancelling]

{ "match_phrase": { "title": { "query": "noise cancelling", "slop": 1 } } }
// matches "noise cancelling" and "noise (active) cancelling"
```

With the default OR `match`, a doc containing only "wireless" still matches but scores lowest; `operator:"and"` drops it entirely.

## Pitfalls

- **`match` on `keyword`** — no analysis happens, so it behaves like `term`; mixed-case input then misses.
- **`match_phrase_prefix` is expensive** — the last term expands to up to `max_expansions` (default 50) terms per shard; avoid for true autocomplete, use a completion suggester or edge n-grams.
- **Stopword surprises** — `english` analyzer drops "the"/"of", so `match_phrase "war of the worlds"` matches "war worlds" unless you account for position gaps.
- **slop is not edit distance** — it measures token moves, not character typos; use `fuzziness` on `match` for typos.

## See also

- [[full-text-search]]
- [[term-level-queries]]
