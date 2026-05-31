---
title: Token filters & character filters
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, analysis]
prerequisites: [analyzers-standard-language-custom, tokenizers]
see-also: [normalizers, suggesters-autocomplete]
---

# Token filters & character filters

The two filtering stages of an [[analyzers-standard-language-custom|analyzer]]: **character filters** transform the raw text *before* the [[tokenizers|tokenizer]]; **token filters** add, remove, or rewrite tokens *after* it.

## Why it matters

These are where most analysis tuning happens. Token filters give you lowercasing, accent folding, stemming, stopwords, synonyms, and n-grams — the difference between "café" matching "cafe" and not. Character filters fix the input *before* tokenization, e.g. stripping HTML so `<b>` tags don't pollute terms. Order matters: a `synonym` filter placed before `lowercase` may never match.

## How it works

Pipeline order is fixed: **char filters → tokenizer → token filters**, each chain applied in array order.

- **Character filters** — `html_strip` removes markup; `mapping` does literal char swaps (`& → and`); `pattern_replace` rewrites via regex.
- **Token filters** — operate on the token stream:
  - `lowercase` / `asciifolding` — normalize case and strip diacritics.
  - `stop` — drop stopwords (`the`, `is`); language-specific lists.
  - stemmers — `porter_stem`, `kstem`, `snowball` reduce to roots.
  - `synonym` / `synonym_graph` — expand `"tv" ⇒ "television"`.
  - `edge_ngram` — generate prefixes at the token level for autocomplete.
- **Position-aware** — filters preserve positions so phrase/`match_phrase` queries still work; multi-word synonyms need `synonym_graph`.

| Stage | Runs | Examples |
|---|---|---|
| Char filter | Before tokenizing | `html_strip`, `mapping`, `pattern_replace` |
| Token filter | After tokenizing | `lowercase`, `stop`, `porter_stem`, `synonym` |

## Example

```
PUT /blog
{ "settings": { "analysis": {
    "char_filter": { "amp": { "type": "mapping", "mappings": ["& => and"] } },
    "filter":      { "stops": { "type": "stop", "stopwords": "_english_" } },
    "analyzer":    { "clean": { "char_filter": ["html_strip", "amp"],
                                "tokenizer": "standard",
                                "filter": ["lowercase", "stops", "porter_stem"] } } } } }

POST /blog/_analyze
{ "analyzer": "clean", "text": "<p>Cats &amp; the Running Foxes</p>" }
// → [cat, run, fox]   ("the" dropped, "&" → "and" then stopped, tags stripped)
```

## Pitfalls

- **Wrong filter order** — `synonym` before `lowercase` misses mixed-case input; `stop` before `synonym` can delete a synonym's trigger word.
- **Multi-word synonyms** — plain `synonym` mishandles them across positions; use `synonym_graph` (and place it last).
- **`asciifolding` only** — folds accents but not case; pair with `lowercase`.
- **Char filters break offsets** — `pattern_replace` that changes length can misalign [[highlighting]] offsets.

## See also

- [[normalizers]]
- [[analyzers-standard-language-custom]]
