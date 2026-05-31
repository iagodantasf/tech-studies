---
title: Horizontal vs vertical scaling
track: system-design
group: Networking & delivery
tags: [system-design, scalability]
prerequisites: []
see-also: [load-balancers-l4-vs-l7-algorithms-active-passive-active-active, performance-vs-scalability, sharding]
---

# Horizontal vs vertical scaling

Two ways to add capacity: **scale up** (a bigger machine) or **scale out** (more machines). The choice shapes your whole architecture.

## Why it matters

When load outgrows one server, how you grow determines your ceiling, cost curve, and failure modes. Vertical scaling is the easy first move but hits a hard physical wall; horizontal scaling is effectively unbounded but forces you to confront statelessness, data partitioning, and coordination. Most large systems end up horizontal precisely because no single box is big enough — or safe enough as a single point of failure. This is the practical engine behind [[performance-vs-scalability|scalability]].

## How it works

| | Vertical (scale up) | Horizontal (scale out) |
|---|---|---|
| Move | bigger CPU/RAM/disk | add more nodes |
| Ceiling | hardware limits | ~unbounded |
| Failure | single point of failure | survives node loss |
| Complexity | low — same app | needs LB, stateless app |
| Cost curve | super-linear at the top | near-linear commodity |

**Vertical** keeps the architecture identical — same single process, just more resources — so there's no code change, but you pay a premium for high-end hardware, take downtime to resize, and still have one box to lose. **Horizontal** puts a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]] in front of many commodity nodes; capacity grows by adding instances and the system tolerates failures, but it demands two things:

- **Stateless app servers** — no session or data in local memory; push state to a shared cache/DB so any node can serve any request.
- **Partitioned data** — the database becomes the bottleneck, pushing you toward replication and [[sharding]].

The honest rule: **scale up until it hurts (cost or limits), then scale out.** Real systems combine both — beefy nodes, several of them.

## Example

A web tier handling 50k req/s:

```
vertical:   1 × 64-core box        → one failure = full outage, capped at the SKU
horizontal: 8 × 8-core behind LB   → lose a node, lose 1/8 capacity; add node #9 to grow
            sessions in Redis, data sharded by user_id
```

## Pitfalls

- **Hidden local state.** In-memory sessions, on-disk uploads, or a local cache silently break horizontal scaling — requests work only when they hit "their" node.
- **Forgetting the data layer.** Stateless app servers scale out trivially; the shared database doesn't, and quietly becomes the real ceiling.
- **Scaling out too early.** Distributed systems carry real complexity; one right-sized box often beats a fragile cluster.
- **Assuming linear speedup.** Coordination, locks, and shared resources mean 2× nodes rarely means 2× throughput (Amdahl/contention).

## See also

- [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active]]
- [[performance-vs-scalability]]
