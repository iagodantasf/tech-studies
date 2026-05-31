---
title: Fuzzy & wildcard search
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, fuzzy-search]
prerequisites: [term-level-queries, inverted-index]
see-also: [suggesters-autocomplete, match-match-phrase-queries, runtime-fields]
---

# Fuzzy & wildcard search

Approximate matching against indexed terms: `fuzzy` tolerates typos via edit distance, while `wildcard`/`regexp`/`prefix` match glob and pattern shapes over the term dictionary.

## Why it matters

Users misspell ("databse"), and product/SKU search needs partial patterns ("AB-*-2024"). These queries fill the gap exact [[term-level-queries|term]] matching leaves — but they expand a single clause into many candidate terms, so naïve use is the classic source of slow, CPU-heavy searches.

## How it works

Each query rewrites into a set of matching terms before scoring; cost scales with how many terms it touches in the dictionary.

| Query | Matches | Main cost knobs |
|---|---|---|
| `fuzzy` | terms within edit distance | `fuzziness`, `prefix_length`, `max_expansions` |
| `prefix` | terms starting with X | length of prefix |
| `wildcard` | `*`/`?` glob | leading `*` scans all terms |
| `regexp` | Lucene regex | anchored prefix vs full scan |

- **`fuzziness: AUTO`** — 0 edits for terms ≤2 chars, 1 for 3–5, 2 for longer; uses Damerau-Levenshtein (transpositions count as one).
- **`prefix_length`** — fixing the first N chars (e.g. 2) shrinks expansion dramatically and is the single best fuzzy tuning lever.
- **`max_expansions`** — default 50; caps candidate terms, trading recall for speed.
- **`wildcard` field type** — for high-cardinality patterns, the dedicated `wildcard` mapping stores an n-gram index that beats `keyword` + leading wildcard.

## Example

```
{ "match": { "title": { "query": "databse serch", "fuzziness": "AUTO",
                          "prefix_length": 1, "max_expansions": 50 } } }

{ "wildcard": { "sku.keyword": { "value": "AB-*-2024" } } }   // anchored, OK
{ "wildcard": { "sku.keyword": { "value": "*-2024" } } }       // leading *, slow
```

The fuzzy `match` finds "database search"; the anchored wildcard is cheap, the leading-`*` one walks every SKU term per shard.

## Pitfalls

- **Leading wildcard** — `*term` (and unanchored `regexp`) is O(distinct terms) per [[shards-replicas|shard]]; prefer a reversed [[multi-fields|sub-field]] or `wildcard` field.
- **Fuzzy on long, common words** — huge expansion sets; always set `prefix_length` and `max_expansions`.
- **Analyzed vs raw** — `wildcard` is a term-level query; run it on a `keyword` sub-field, not analyzed `text`, or the glob won't align with stored tokens.
- **`fuzziness` ≠ phonetic** — it's character edits, not sound; "fone"→"phone" (2 edits) may miss. Use a phonetic [[token-filters-character-filters|token filter]] for that.

## See also

- [[term-level-queries]]
- [[suggesters-autocomplete]]
