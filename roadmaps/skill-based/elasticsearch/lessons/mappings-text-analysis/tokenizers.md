---
title: Tokenizers
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, tokenization]
prerequisites: [analyzers-standard-language-custom]
see-also: [token-filters-character-filters, suggesters-autocomplete]
---

# Tokenizers

The component inside an [[analyzers-standard-language-custom|analyzer]] that splits a character stream into individual tokens (terms) — and emits their offsets and positions for highlighting and phrase queries.

## Why it matters

The tokenizer decides what counts as a "word". Choose `standard` and `"wi-fi"` becomes `[wi, fi]`; choose `whitespace` and it stays `"wi-fi"`. Tokenization drives partial-match behavior: `edge_ngram` is the standard way to build search-as-you-type [[suggesters-autocomplete|autocomplete]], while the wrong tokenizer makes hyphenated codes or URLs unsearchable.

## How it works

Exactly one tokenizer runs per analyzer, after char filters and before token filters. Each token carries a position and start/end offset.

- **`standard`** — Unicode segmentation (UAX #29); drops most punctuation. Default, good for prose.
- **`whitespace`** — splits only on whitespace; keeps punctuation and case.
- **`keyword`** — emits the entire input as a single token (combine with filters to lowercase a whole string).
- **`pattern`** — splits on a regex (default `\W+`).
- **`ngram`** — every N-length window; matches substrings anywhere (heavy index growth).
- **`edge_ngram`** — prefixes only (`"quick"`→`q, qu, qui, quic, quick`); ideal for autocomplete, far smaller than `ngram`.
- **`path_hierarchy`** — `"/a/b/c"`→`[/a, /a/b, /a/b/c]`; for filesystem-style facets.

| Tokenizer | `"Quick-Fox 2"` → | Use |
|---|---|---|
| `standard` | `[quick, fox, 2]` | General text |
| `whitespace` | `[Quick-Fox, 2]` | Pre-tokenized input |
| `keyword` | `[Quick-Fox 2]` | Whole-value tokens |
| `edge_ngram` (min2,max5) | `[Qu, Qui, Quic, Quick, ...]` | Autocomplete |

## Example

```
PUT /ac
{ "settings": { "analysis": {
    "tokenizer": { "edge": { "type": "edge_ngram", "min_gram": 2, "max_gram": 10,
                             "token_chars": ["letter", "digit"] } },
    "analyzer":  { "ac": { "tokenizer": "edge", "filter": ["lowercase"] } } } },
  "mappings": { "properties": {
    "title": { "type": "text", "analyzer": "ac", "search_analyzer": "standard" } } } }
```

Indexing `"Laptop"` stores `[la, lap, lapt, lapto, laptop]`; a search for `"lap"` (analyzed by `standard`) hits the `lap` term — instant prefix match.

## Pitfalls

- **`ngram` index bloat** — full n-grams multiply term count; prefer `edge_ngram` unless you truly need infix matching.
- **No `search_analyzer`** — analyzing the *query* with `edge_ngram` too means `"lap"` becomes `[la, lap]` and over-matches; search with `standard`.
- **Unbounded `max_gram`** — large windows explode the index and slow indexing; cap it (often ≤10–15).
- **Losing offsets** — custom regex tokenizers can break highlighting if offsets aren't preserved.

## See also

- [[token-filters-character-filters]]
- [[suggesters-autocomplete]]
