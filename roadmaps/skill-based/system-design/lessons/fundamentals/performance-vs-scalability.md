---
title: Performance vs scalability
track: system-design
group: Fundamentals
tags: [system-design, scalability]
prerequisites: [what-is-system-design-how-to-approach-it]
see-also: [latency-vs-throughput, horizontal-vs-vertical-scaling]
---

# Performance vs scalability

**Performance** is how fast the system is for one unit of work; **scalability** is whether it stays fast as load grows — two distinct axes that are often conflated.

## Why it matters

A common rule of thumb: if the service is **slow for a single user**, you have a *performance* problem; if it's **fast for one but slow under load**, you have a *scalability* problem. They demand opposite fixes — profiling and algorithmic work versus adding capacity and removing contention. Confusing them wastes effort: throwing servers at an O(n²) hot loop, or micro-optimizing code when the real wall is a single shared database.

## How it works

Performance is tuned **down** (lower per-request cost): better algorithms (see [[time-and-space-complexity]]), indexes, [[where-to-cache-client-cdn-web-server-database-application|caching]], fewer round trips. Scalability is grown **out or up**:

- **Vertical** ([[horizontal-vs-vertical-scaling|scale up]]) — bigger box; simple, but a hard ceiling and a single point of failure.
- **Horizontal** (scale out) — more boxes behind a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]]; needs **stateless** services so any node can serve any request.

A system **scales linearly** when 2× the resources yields ~2× the [[latency-vs-throughput|throughput]]. **Amdahl's law** caps speedup by the serial fraction, and **Universal Scalability Law** adds a *coherence* penalty — beyond some node count, cross-node coordination (locks, [[consistency-patterns-weak-eventual-strong|consistency]] chatter) makes throughput *drop*.

| Symptom | Axis | Typical fix |
|---|---|---|
| Slow with one user | Performance | Profile, index, algorithm |
| Fine at 1, dies at 1000 | Scalability | Stateless + scale out |
| 2× nodes ≠ 2× work | Scalability ceiling | Cut shared contention |

## Example

A report endpoint returns in 200 ms solo but 8 s at 500 concurrent users. CPU is idle; the DB connection pool (size 20) is saturated — a **scalability** limit from a shared resource, not slow code. Fix: cache hot reports and add read replicas, not a faster sort.

## Pitfalls

- **"Just add servers"** when a shared DB/lock is the bottleneck — the new nodes queue on it.
- **Hidden shared state** (sticky sessions, local cache) that blocks horizontal scaling.
- **Optimizing the 1% path** while the dominant cost sits elsewhere — measure first.

## See also

- [[latency-vs-throughput]]
- [[horizontal-vs-vertical-scaling]]
