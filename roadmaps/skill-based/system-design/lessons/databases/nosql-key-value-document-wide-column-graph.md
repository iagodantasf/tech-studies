---
title: NoSQL — key-value, document, wide-column, graph
track: system-design
group: Databases
tags: [system-design, nosql]
prerequisites: [databases]
see-also: [sql-vs-nosql-when-to-use-which, sharding]
---

# NoSQL — key-value, document, wide-column, graph

NoSQL is an umbrella for non-relational stores that drop joins and rigid schemas to get horizontal scale and flexible data models.

## Why it matters

Relational engines are excellent until your access pattern is "look up one key at massive scale" or "store wildly varying shapes." NoSQL stores are built to [[sharding|shard]] from day one and often favor **availability and partition tolerance** over strong consistency (the AP corner of [[availability-vs-consistency-cap-theorem]]). Picking the right family is mostly about matching the store's data model to how you read the data.

## How it works

Four broad families, each tuned to a query shape:

| Family | Model | Reads by | Examples |
|---|---|---|---|
| Key-value | opaque blob per key | the key only | Redis, DynamoDB |
| Document | nested JSON docs | key or fields/indexes | MongoDB, Couchbase |
| Wide-column | rows of sparse column families | partition + cluster key | Cassandra, HBase |
| Graph | nodes + edges | traversals | Neo4j, JanusGraph |

- **Key-value** — fastest possible get/set; perfect for sessions, caches, feature flags.
- **Document** — store an aggregate (order + line items) as one document; no joins, schema-on-read.
- **Wide-column** — design the table *per query*; writes are cheap and append-friendly at huge scale.
- **Graph** — when the relationships *are* the data: social graphs, recommendations, fraud rings.

Most are **schema-flexible** and reach scale by partitioning on a key, so the modeling rule flips: design around your queries, not around normal forms.

## Example

Wide-column model for a chat app, designed for "fetch a room's recent messages":

```
TABLE messages
  PARTITION KEY room_id        -- all of a room's messages co-located
  CLUSTERING  ts DESC          -- newest first, range-scannable

SELECT * FROM messages
WHERE room_id = 'general' LIMIT 50;   -- one partition, sequential read
```

The same query in a normalized SQL schema would join and sort across a huge table; here it is a single localized scan.

## Pitfalls

- **Modeling relationally.** Forcing joins onto a document or wide-column store fights its grain — duplicate/embed instead.
- **Eventual consistency surprises.** A read right after a write may return stale data; design for it or request stronger reads where offered.
- **Unbounded partitions.** A wide-column partition that grows forever (one room, millions of messages) becomes a hotspot — bucket by time.
- **"Schema-less" still has a schema.** It just moved into your application code, untyped.

## See also

- [[sql-vs-nosql-when-to-use-which]]
- [[sharding]]
