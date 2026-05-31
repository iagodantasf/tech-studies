---
title: Object & nested fields
track: elasticsearch
group: Mappings & Text Analysis
tags: [elasticsearch, nested]
prerequisites: [mappings, documents]
see-also: [nested-aggregations, core-field-types-text-keyword-numeric-date-boolean]
---

# Object & nested fields

How Elasticsearch indexes JSON sub-objects: the default `object` type flattens them, while the `nested` type preserves each array element as a hidden sub-document so cross-field conditions stay correct.

## Why it matters

Elasticsearch is flat under the hood (Lucene has no concept of inner objects). With the default `object` mapping, an array of objects is collapsed field-by-field, so a query like "an item with name=shirt **and** size=L" can match a doc where *different* items satisfy each clause. `nested` fixes this correctness bug — at the cost of one Lucene doc per array element.

## How it works

A sub-object is mapped as `object` (default) or `nested`.

- **`object`** — `user.first` and `user.last` become flat keys `user.first`, `user.last`. For an *array* of objects, values are merged into parallel lists, losing the association between fields of the same element.
- **`nested`** — each array element is indexed as a separate hidden document; you query them with a `nested` query (and aggregate via [[nested-aggregations]]) that scopes clauses to one element.
- **Cost** — a doc with N nested items indexes as N+1 Lucene docs. Inserting/updating one item re-indexes the whole parent.
- **Limits** — `index.mapping.nested_fields.limit` (default 50) and `nested_objects.limit` (default 10000 per doc) guard against blow-up.

| Aspect | `object` | `nested` |
|---|---|---|
| Lucene docs | 1 | 1 + N elements |
| Cross-field correctness | No (flattened) | Yes (per element) |
| Query syntax | Plain field path | `nested` query |
| Aggregation | Direct | `nested` agg |

## Example

```
"items": [ { "name": "shirt", "size": "L" },
           { "name": "hat",   "size": "S" } ]
```

With `object`, the index holds `name:[shirt,hat]`, `size:[L,S]` — so `name=shirt AND size=S` **wrongly matches**. With `nested`:

```
GET /orders/_search
{ "query": { "nested": { "path": "items",
  "query": { "bool": { "must": [
    { "match": { "items.name": "shirt" } },
    { "term":  { "items.size": "S" } } ] } } } } }   // no match — correct
```

## Pitfalls

- **Forgetting `nested`** — flattened arrays silently return false positives; the bug is invisible until someone audits results.
- **High-cardinality nested arrays** — thousands of elements per doc explode the Lucene doc count and slow indexing/refresh.
- **Partial updates** — there is no in-place update of a single nested element; the entire parent is rewritten.
- **Sorting/aggregating across the boundary** — nested fields need `nested` scope; plain aggs see the inner docs as separate.

## See also

- [[nested-aggregations]]
- [[mappings]]
