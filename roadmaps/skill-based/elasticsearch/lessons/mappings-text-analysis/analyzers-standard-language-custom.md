---
title: Analyzers (standard, language, custom)
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, analysis]
prerequisites: [inverted-index, core-field-types-text-keyword-numeric-date-boolean]
see-also: [tokenizers, token-filters-character-filters]
---

# Analyzers (standard, language, custom)

An analyzer is the pipeline that turns a `text` value into the index terms stored in the [[inverted-index]] — character filters, then a [[tokenizers|tokenizer]], then [[token-filters-character-filters|token filters]].

## Why it matters

Index-time and query-time analysis must agree, or searches silently miss. The built-in `standard` analyzer handles most Western text; `language` analyzers add stemming and stopwords so "running" matches "ran"; `custom` analyzers let you compose exactly the pipeline a field needs (e.g. lowercased keywords, edge n-grams for autocomplete). This is the lever for tuning precision vs recall.

## How it works

Every analyzer is **char filters → tokenizer → token filters**, applied left to right.

- **`standard`** — `standard` tokenizer (Unicode word boundaries) + `lowercase` filter. No stemming. `"The Quick-Fox!"` → `[the, quick, fox]`.
- **`language`** (e.g. `english`, `french`) — adds a stemmer + language stopwords. `english`: `"running shoes"` → `[run, shoe]`.
- **`keyword` analyzer** — emits the whole input as one token (different from the `keyword` *type*).
- **`custom`** — declare `char_filter`, `tokenizer`, `filter` arrays in index settings, then reference the name from a field.
- **`search_analyzer`** — override the analyzer used at query time (common for edge-n-gram autocomplete: index with n-grams, search with `standard`).

| Analyzer | Tokenizer | Key filters | Stems? |
|---|---|---|---|
| `standard` | `standard` | `lowercase` | No |
| `english` | `standard` | `lowercase`, `stop`, `porter_stem` | Yes |
| `keyword` | `keyword` | (none) | No |
| `custom` | your choice | your chain | Optional |

## Example

```
PUT /docs
{ "settings": { "analysis": { "analyzer": {
    "folding_en": { "type": "custom", "tokenizer": "standard",
                    "filter": ["lowercase", "asciifolding", "porter_stem"] } } } },
  "mappings": { "properties": {
    "body": { "type": "text", "analyzer": "folding_en" } } } }

POST /docs/_analyze
{ "analyzer": "folding_en", "text": "Café Crémes Brewing" }
// → [cafe, creme, brew]
```

`asciifolding` strips accents so `"café"` and `"cafe"` collide; `porter_stem` reduces `"brewing"`→`"brew"`.

## Pitfalls

- **Index/search analyzer mismatch** — stemming at index but not query time (or vice versa) returns nothing; use `_analyze` to verify both.
- **Wrong `language`** — applying `english` stemming to product codes mangles tokens (`"AB-100s"`→`"ab-100"`).
- **Reanalysis needs reindex** — changing a field's analyzer only affects newly indexed docs; existing data must be reindexed.
- **Over-aggressive stemming** — `"university"` and `"universe"` can stem to the same root, hurting precision.

## See also

- [[tokenizers]]
- [[token-filters-character-filters]]
