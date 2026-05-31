---
title: Elasticsearch vs relational databases
track: elasticsearch
group: Introduction
tags: [elasticsearch, data-modeling]
prerequisites: []
see-also: [what-is-elasticsearch, documents, mappings]
---

# Elasticsearch vs relational databases

How a search engine differs from an RDBMS — the data model, query model, and consistency guarantees — and why the two are usually deployed *together*, not as substitutes.

## Why it matters

Engineers reach for Elasticsearch expecting Postgres with a search box, then hit missing joins, no transactions, and stale reads. Knowing the boundaries up front decides what stays in your [[databases|relational]] source of truth and what you denormalize into an index for fast search and [[bucket-aggregations|aggregation]].

## How it works

A [[databases|relational database]] normalizes data into tables and joins at query time; Elasticsearch denormalizes into self-contained [[documents]] and resolves everything at index time. This shifts the cost from read to write and powers fast [[metric-aggregations|analytics]] over flat data.

- **No joins** — model relations by denormalizing, [[object-nested-fields|nested]] documents, or `join` field (parent/child, expensive). Prefer flattening.
- **No multi-document transactions** — only single-doc atomicity, with [[optimistic-concurrency-control-versioning|optimistic concurrency]] via `_seq_no`/`_primary_term`.
- **Schema** — a [[mappings|mapping]] is similar to a schema, but `text` fields are analyzed into an [[inverted-index]]; there is no `ALTER` to change a field's type.
- **Reads** — [[near-real-time-search|near real-time]] and eventually consistent across replicas, not read-after-write.

| | Relational DB | Elasticsearch |
|---|---|---|
| Unit | Row in a table | JSON document in an index |
| Joins | Native | None (denormalize) |
| Transactions | ACID, multi-row | Single-doc only |
| Strength | Integrity, updates | Full-text + ranking, analytics |
| Consistency | Immediate | Eventual, NRT |

## Example

A `SELECT * FROM orders JOIN users` becomes a denormalized doc:

```
RDBMS (normalized):   orders(user_id FK) ── users(id, name)
Elasticsearch (flat): { "order_id": 5, "user": { "id": 7, "name": "Ada" } }
```

You accept duplication of `user.name` across orders to get a join-free, instantly searchable document.

## Pitfalls

- **Using it as the system of record** — no backups-by-transaction, no constraints; keep the authoritative copy in a DB and [[reindex-api|reindex]] from it.
- **Frequent partial updates** — every update rewrites and re-indexes the whole document; heavy mutable data fits an RDBMS better.
- **Modeling many-to-many with `join`** — it forces parent/child on one shard and scales poorly; denormalize instead.

## See also

- [[what-is-elasticsearch]]
- [[mappings]]
