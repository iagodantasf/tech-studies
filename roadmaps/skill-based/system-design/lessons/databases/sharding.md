---
title: Sharding
track: system-design
group: Databases
tags: [system-design, scaling]
prerequisites: [databases]
see-also: [federation, denormalization]
---

# Sharding

Sharding splits the rows of a single logical table across many databases so that writes — not just reads — scale horizontally.

## Why it matters

Replication and [[federation]] still cap you at what one machine can write for a given table. When one table is too big or too write-hot for any single node, sharding is the answer: each **shard** holds a disjoint slice of the rows and serves its own reads and writes. The price is that the database can no longer enforce global joins, uniqueness, or transactions for you.

## How it works

A **shard key** decides which shard a row lives on. The keying strategy is the whole game:

| Strategy | Placement | Strength | Weakness |
|---|---|---|---|
| Range | key falls in `[a,b)` | range scans local | hot ranges, skew |
| Hash | `hash(key) % N` | even spread | resharding moves most rows |
| Consistent hash | key on a ring | adds nodes cheaply | range scans fan out |
| Directory | lookup table | flexible | lookup is a bottleneck |

Choose a **high-cardinality, evenly-accessed** key (e.g. `user_id`), so load spreads and one customer can't create a hot shard. Queries that include the shard key hit one shard; queries that don't must **scatter-gather** across all of them.

## Example

100M users hashed across 8 shards on `user_id`:

```
shard = hash(user_id) % 8
GET user 12345  → shard 3        (single node, fast)
"all users in Brazil"            → scatter to 8 shards, gather (slow)
```

Generating globally unique IDs needs care: a per-shard auto-increment collides, so use UUIDs or a **Snowflake**-style ID (timestamp + shard id + sequence) that is unique without coordination.

## Pitfalls

- **Cross-shard joins and transactions are gone.** Denormalize (see [[denormalization]]) or do app-side joins; use sagas for multi-shard writes.
- **Hotspots from a bad key.** Sharding by `country` puts a whole region on one node. Pick high-cardinality keys.
- **Resharding is painful.** `% N` reshuffles almost everything when N changes — prefer consistent hashing or over-provision virtual shards up front.
- **Operational tax.** Backups, migrations, and monitoring now run N times over.

## See also

- [[federation]]
- [[denormalization]]
