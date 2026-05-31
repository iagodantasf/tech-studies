---
title: What is system design & how to approach it
track: system-design
group: Fundamentals
tags: [system-design, methodology]
prerequisites: []
see-also: [performance-vs-scalability, availability-vs-consistency-cap-theorem]
---

# What is system design & how to approach it

System design is the discipline of turning fuzzy product requirements into a concrete architecture of components, data, and protocols that meets explicit goals for **scale, latency, availability, and cost**.

## Why it matters

Most real failures are not algorithmic — they are integration, capacity, and failure-mode problems that only surface under load or partial outage. Interviews use system design as a proxy for "can you own a service in production?" because it forces you to reason about trade-offs (no single right answer) rather than recite facts. The skill compounds: the same framework sizes a URL shortener and a payments ledger.

## How it works

A repeatable interview/whiteboard flow keeps you from designing in a vacuum:

1. **Clarify requirements** — split **functional** (what it does) from **non-functional** (the *-ilities*: latency, availability, durability, consistency). Pin numbers: DAU, read:write ratio, payload size, retention.
2. **Back-of-envelope estimation** — derive QPS, storage/yr, and bandwidth *before* drawing boxes; the numbers decide the architecture.
3. **API + data model** — define the contract and the entities; the schema constrains everything downstream.
4. **High-level design** — clients → [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|LB]] → services → stores; name each box's job.
5. **Deep-dive & bottlenecks** — scale the hot path with [[sharding]], [[where-to-cache-client-cdn-web-server-database-application|caching]], and replication; then attack the weakest link.

| Estimate | Rule of thumb |
|---|---|
| Peak QPS | average QPS × 2–3 |
| Writes/yr | write QPS × ~31.5M s/yr |
| 1 KB row × 1B rows | ~1 TB |

State assumptions out loud — a defensible guess beats silence.

## Example

"Design a URL shortener." 100M new links/day → ~1,160 writes/s, peak ~3,000/s. Reads at 100:1 → ~116K reads/s, peak ~350K/s — **read-heavy**, so a redirect cache and read replicas dominate the design. 100M/day × 500 B × 5 yr ≈ **90 TB**, which justifies [[sharding]] the key→URL store rather than one box.

## Pitfalls

- **Jumping to boxes** before requirements and math — you optimize the wrong axis.
- **Ignoring the read:write ratio** — it dictates caching vs durability emphasis.
- **One-size scaling** — bolting on a cache/queue everywhere instead of the proven bottleneck.
- **No failure story** — a design with no answer for "what if this node dies?" is incomplete.

## See also

- [[performance-vs-scalability]]
- [[latency-vs-throughput]]
