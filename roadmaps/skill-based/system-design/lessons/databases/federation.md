---
title: Federation
track: system-design
group: Databases
tags: [system-design, scaling]
prerequisites: [databases]
see-also: [sharding, rdbms-replication-master-slave-master-master]
---

# Federation

Federation (functional partitioning) splits one database into several, each owning a distinct *function* of the domain.

## Why it matters

Before reaching for [[sharding]], you can often relieve a hot database simply by separating concerns: put users, products, and forum posts in their own databases. Each gets its own buffer cache, write throughput, and replication topology, so traffic to one no longer starves the others. It maps cleanly onto an [[application-layer-microservices]] design where each service owns its data.

## How it works

Partition **by table group / bounded context**, not by rows:

- `users_db` — accounts, auth, profiles.
- `products_db` — catalog, inventory, pricing.
- `forum_db` — threads, posts, votes.

Each database scales and is tuned independently; a slow full-text search on the forum no longer competes for the same I/O as a checkout.

| Approach | Splits by | Cross-set join |
|---|---|---|
| Federation | function / table group | hard — app-side |
| Sharding | rows of one table | hard — across shards |
| Replication | nothing (full copies) | trivial — single DB |

The cost: queries that used to be a single SQL join now span databases, so you join in the application layer or **denormalize** (see [[denormalization]]).

## Example

A monolith DB at 90% CPU is dominated by two workloads: catalog browsing and forum activity. Split:

```
            ┌──────────────┐
app ───────►│  users_db    │  (small, low write)
       ────►│  products_db │  (read-heavy → add replicas)
       ────►│  forum_db    │  (write-heavy → own primary)
            └──────────────┘
```

Each can now have a tailored replication and caching strategy; the products DB gets read replicas, the forum DB gets a beefier write primary.

## Pitfalls

- **Cross-database joins disappear.** A report joining users to orders to products now needs app-side stitching or a separate analytics store.
- **No cross-database transactions.** You lose ACID across the split; reach for sagas or [[idempotent-operations]] flows.
- **Uneven split.** If one function still dominates, federation only delays the need to [[sharding]] that piece.
- **Referential integrity is now your job.** Foreign keys can't span databases.

## See also

- [[sharding]]
- [[rdbms-replication-master-slave-master-master]]
