---
title: SQL vs NoSQL — when to use which
track: system-design
group: Databases
tags: [system-design, data-modeling]
prerequisites: [databases]
see-also: [nosql-key-value-document-wide-column-graph, sharding]
---

# SQL vs NoSQL — when to use which

The choice is not "old vs new" — it is whether your workload needs relational integrity and ad-hoc queries, or single-key scale and a flexible shape.

## Why it matters

This decision is hard to reverse: it shapes your schema, your queries, and your scaling story. Pick SQL for a key-value-at-scale workload and you fight [[sharding]] and locks; pick NoSQL for a richly-related, transactional domain and you reimplement joins and integrity in application code. Getting it right early saves a painful migration later.

## How it works

Match the store to what the workload actually demands:

| Need | Favors | Why |
|---|---|---|
| Multi-row ACID transactions | SQL | atomic commit, integrity |
| Ad-hoc queries, reporting, joins | SQL | flexible declarative joins |
| Strong schema / constraints | SQL | enforced at the DB |
| Massive single-key throughput | NoSQL | partitions horizontally |
| Flexible / evolving shape | NoSQL | schema-on-read |
| Huge write volume, simple reads | NoSQL | append-friendly, sharded |

**Reach for SQL by default** for transactional business data — orders, payments, inventory — where correctness and relationships dominate and a single tuned instance ([[sql-tuning]]) handles most loads. **Reach for NoSQL** ([[nosql-key-value-document-wide-column-graph]]) when one access pattern must scale beyond a single node, the data is naturally an aggregate, or you need very high write throughput. **Polyglot persistence** is normal: SQL for orders, key-value for sessions, a search engine for full-text.

## Example

An e-commerce platform, picking per workload:

```
orders, payments      → PostgreSQL   (ACID, joins, reporting)
user sessions / cart  → Redis        (key-value, TTL, sub-ms)
product catalog search→ Elasticsearch(full-text, facets)
activity event stream → Cassandra    (huge write volume, time-series)
```

No single engine wins all four; the design uses each where its grain fits.

## Pitfalls

- **"NoSQL = web scale" cargo-culting.** A correctly indexed SQL database serves enormous load; most apps never outgrow it.
- **Losing transactions you needed.** Spreading an order across NoSQL documents can break atomicity — keep transactional cores in SQL.
- **Ignoring access patterns.** NoSQL modeling is query-first; choosing it before you know your queries traps you in scatter-gather.
- **Too many stores.** Each engine adds ops, backups, and failure modes — adopt polyglot persistence deliberately, not reflexively.

## See also

- [[nosql-key-value-document-wide-column-graph]]
- [[sharding]]
