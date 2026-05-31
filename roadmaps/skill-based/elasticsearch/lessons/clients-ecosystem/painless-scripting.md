---
title: Painless scripting
track: elasticsearch
group: Clients & Ecosystem
tags: [elasticsearch, painless]
prerequisites: [fields-data-types, query-dsl-overview]
see-also: [runtime-fields, update-by-query-delete-by-query, ingest-pipelines]
---

# Painless scripting

Painless is Elasticsearch's purpose-built, sandboxed scripting language — a Java-like syntax compiled to JVM bytecode — used wherever inline logic is needed: scripted updates, [[runtime-fields|runtime fields]], custom scoring, and pipeline conditions.

## Why it matters

Many tasks have no declarative equivalent: incrementing a counter atomically, deriving a field from two others, or boosting score by recency. Painless fills that gap safely — it is sandboxed (no file/network/reflection access) and statically typed, so it is far harder to crash a node with than the old Groovy/MVEL scripts it replaced. It runs in updates, queries, aggregations, [[ingest-pipelines|ingest pipelines]], and watcher conditions.

## How it works

Each context exposes a different set of variables; the same language, different bindings.

| Context | Read via | Write via |
|---|---|---|
| Update | `ctx._source.field` | mutate `ctx._source` |
| Search / runtime | `doc['field'].value` | `emit(...)` |
| Score (`script_score`) | `doc[...]`, `_score` | `return` a double |
| Ingest | `ctx.field` | mutate `ctx` |

- **`doc[]` vs `_source`** — `doc['f'].value` reads columnar `doc_values` (fast, for search/scoring/aggs); `ctx._source.f` reads the raw JSON (for updates/ingest). They are not interchangeable.
- **Compiled & cached** — a script is compiled once and cached by its exact text; vary only the inputs.
- **`params`** — pass variable data via `params` instead of baking it into the source, so the cached compilation is reused across calls.
- **Stored scripts** — register reusable logic under an id with `_scripts/<id>` and call it by name.

## Example

```
POST /inventory/_update/sku-1
{ "script": { "source": "ctx._source.stock -= params.qty; if (ctx._source.stock < 0) { ctx.op = 'noop' }",
              "lang": "painless", "params": { "qty": 3 } } }
```

This decrements stock atomically on the shard and aborts (`noop`) if it would go negative — a read-modify-write that needs no [[optimistic-concurrency-control-versioning|version]] round-trip from the client.

## Pitfalls

- **`doc['f']` on missing field throws** — guard with `if (doc['f'].size() != 0)`; an unguarded access aborts the whole request, not just one doc.
- **Compilation rate limit** — distinct script *sources* hit `script.max_compilations_rate` (default 150/5min) and start failing; the fix is almost always moving literals into `params`.
- **`text` fields have no `doc_values`** — `doc['title'].value` on an analyzed field errors; read its `keyword` [[multi-fields|sub-field]] instead.
- **Per-doc cost** — a `script_score` or [[runtime-fields|runtime field]] runs the script for every matching doc; cheap inline math is fine, heavy logic over millions of docs is not.

## See also

- [[runtime-fields]]
- [[ingest-pipelines]]
