---
title: Availability patterns (failover, replication)
track: system-design
group: Fundamentals
tags: [system-design, availability]
prerequisites: [availability-vs-consistency-cap-theorem]
see-also: [availability-in-numbers-the-nines, rdbms-replication-master-slave-master-master]
---

# Availability patterns (failover, replication)

Availability patterns keep a service answering despite component failure, mainly through **replication** (more copies) and **failover** (promote a healthy copy when one dies).

## Why it matters

Every component fails eventually, so availability comes from *redundancy plus a plan to switch over*, not from hoping nothing breaks. The two big patterns trade cost against recovery speed and complexity. Getting failover wrong is worse than no failover: a botched promotion causes **split-brain** (two primaries accepting writes) and silent data loss — the exact corruption replication was meant to prevent.

## How it works

**Failover** topologies:

- **Active-passive** (master-standby) — one node serves; a hot/warm standby takes over on failure, detected by missed heartbeats. Brief downtime during promotion.
- **Active-active** — all nodes serve traffic behind a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]]; a death just removes capacity, no promotion gap. Needs the data layer to handle concurrent writes.

**Replication** modes (see [[rdbms-replication-master-slave-master-master|RDBMS replication]]):

- **Synchronous** — primary waits for replica ack before confirming. No data loss on failover (**RPO ≈ 0**) but higher write latency.
- **Asynchronous** — primary confirms immediately, ships changes after. Fast, but a crash loses the unshipped tail (**RPO > 0**).

| Pattern | Failover gap | Write cost | Risk |
|---|---|---|---|
| Active-passive | seconds (promote) | low | standby idle |
| Active-active | ~0 | coordination | conflicts |
| Sync replication | RPO ≈ 0 | high latency | stalls if replica slow |
| Async replication | RPO > 0 | low | lost tail on crash |

Guarding against **split-brain** requires a tiebreaker: a **quorum/witness** node or a **fencing** mechanism (STONITH) so a demoted-but-alive primary cannot keep writing.

## Example

A primary Postgres with a sync standby in another AZ. Heartbeats stop; an orchestrator (Patroni) confirms via a quorum that the primary is truly gone, fences it, and promotes the standby — clients reconnect through a virtual IP. RPO ≈ 0 (sync), RTO ≈ 30 s (detect + promote). The witness node prevents both AZs from each promoting a primary during a network split.

## Pitfalls

- **No fencing/quorum** → split-brain and divergent writes after the partition heals.
- **Untested failover** — the standby silently fell out of replication and is hours stale when you need it.
- **Counting replicas as backups** — replication faithfully copies a `DROP TABLE` too; keep real backups.

## See also

- [[availability-in-numbers-the-nines]]
- [[rdbms-replication-master-slave-master-master]]
