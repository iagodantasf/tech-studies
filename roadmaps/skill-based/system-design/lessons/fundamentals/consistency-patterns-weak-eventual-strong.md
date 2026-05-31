---
title: Consistency patterns (weak, eventual, strong)
track: system-design
group: Fundamentals
tags: [system-design, consistency]
prerequisites: [availability-vs-consistency-cap-theorem]
see-also: [rdbms-replication-master-slave-master-master, availability-patterns-failover-replication]
---

# Consistency patterns (weak, eventual, strong)

Consistency models define **what a read may return after a write** — a spectrum from "no guarantee" (weak) through "converges later" (eventual) to "always the latest" (strong).

## Why it matters

This is the knob behind the [[availability-vs-consistency-cap-theorem|CAP]] trade-off, expressed as concrete guarantees you give clients. Stronger consistency simplifies application logic (you never read stale data) but costs latency and availability, since reads/writes must coordinate across replicas. Choosing the weakest model that's still *correct for the use case* is how systems hit both their SLOs and their scale targets.

## How it works

The three broad classes, weakest to strongest:

- **Weak** — after a write, reads *may or may not* see it; no convergence promise. Fits real-time media (VoIP, live video) where a stale frame is better than a stall.
- **Eventual** — if writes stop, all replicas *converge* to the same value, given time. Reads can be stale in between. Powers DNS, [[rdbms-replication-master-slave-master-master|async replicas]], and most AP stores.
- **Strong** — every read reflects the latest acknowledged write (linearizable). Needs synchronous replication or a quorum/consensus round.

Between eventual and strong sit pragmatic middles:

- **Read-your-writes** — a client always sees *its own* updates (e.g. via session stickiness or read-from-primary).
- **Monotonic reads** — once you've seen a value, you never see an older one.
- **Causal** — reads respect cause→effect ordering (a reply never appears before its post).

| Model | Read after write | Cost |
|---|---|---|
| Weak | maybe never | cheapest |
| Eventual | eventually | low, can be stale |
| Strong | always latest | latency + coordination |

Quorum tuning makes this concrete: with N replicas, **R + W > N** guarantees a read overlaps the latest write (strong-ish); `W=1, R=1` is fast and eventual.

## Example

A social profile uses **eventual** consistency for the global timeline (a friend may see your new bio a few seconds late — fine), but **read-your-writes** for *your own* edit so you never reload and see the old value. Implementation: route the editor's own reads to the primary for a few seconds, everyone else to async replicas.

## Pitfalls

- **Defaulting to strong** everywhere — pays latency for data that tolerates staleness.
- **Eventual without idempotency** — replayed/duplicated writes corrupt state; pair with [[idempotent-operations]].
- **Forgetting read-your-writes** — users edit, refresh, see stale data, and "lose" their change.

## See also

- [[availability-vs-consistency-cap-theorem]]
- [[rdbms-replication-master-slave-master-master]]
