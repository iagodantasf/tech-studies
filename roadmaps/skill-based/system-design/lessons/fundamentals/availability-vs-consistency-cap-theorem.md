---
title: Availability vs consistency (CAP theorem)
track: system-design
group: Fundamentals
tags: [system-design, cap-theorem]
prerequisites: [what-is-system-design-how-to-approach-it]
see-also: [consistency-patterns-weak-eventual-strong, availability-patterns-failover-replication]
---

# Availability vs consistency (CAP theorem)

CAP states that a distributed store facing a **network partition (P)** must choose between **consistency (C)** and **availability (A)** — you cannot have both while the network is split.

## Why it matters

Partitions are not hypothetical — switches reboot, links drop, GC pauses look like a dead node. So the real choice is **CP vs AP** every time a replica can't reach its peers. This single decision shapes the whole stack: whether a write blocks until acknowledged across nodes, or returns immediately and reconciles later. Picking wrong gives you either needless downtime or silent data conflicts.

## How it works

The three properties, precisely:

- **Consistency** (CAP's "C", = linearizability) — every read sees the most recent acknowledged write, as if one copy.
- **Availability** — every non-failing node returns a non-error response.
- **Partition tolerance** — the system keeps operating despite dropped/delayed messages between nodes.

When a partition hits, a node that can't coordinate must either **refuse** (stay consistent → CP) or **answer from local state** (stay available → AP).

| Choice | On partition | Examples |
|---|---|---|
| CP | reject writes on minority side | etcd, ZooKeeper, HBase |
| AP | accept, reconcile later | Dynamo, Cassandra, Riak |

Two essential refinements: CAP only bites **during** a partition — when healthy, you can have both. And **PACELC** extends it: *if Partition then A-vs-C, Else Latency-vs-Consistency* — even with no partition, strong [[consistency-patterns-weak-eventual-strong|consistency]] costs latency.

## Example

A 3-node cluster splits 2–1. A **CP** store (majority quorum) lets the 2-node side keep serving writes and the lone node return errors — no divergence, partial downtime. An **AP** store like Cassandra accepts writes on *both* sides; when the link heals, last-write-wins or CRDTs merge them — full availability, possible conflicts. A shopping cart picks AP (never block "add to cart"); a bank ledger picks CP.

## Pitfalls

- **"Pick 2 of 3"** mythology — P isn't optional on a real network; you choose C vs A.
- Treating CAP-**C** (linearizability) as the same "C" as ACID — different guarantees.
- **AP without conflict resolution** — accepting concurrent writes but having no merge rule means lost updates.

## See also

- [[consistency-patterns-weak-eventual-strong]]
- [[availability-patterns-failover-replication]]
