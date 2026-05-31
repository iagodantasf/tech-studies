---
title: Leader election
track: system-design
group: Resiliency & patterns
tags: [system-design, coordination]
prerequisites: [availability-vs-consistency-cap-theorem]
see-also: [availability-patterns-failover-replication, rdbms-replication-master-slave-master-master]
---

# Leader election

Leader election is the process by which a cluster of equal nodes agrees on a single one to coordinate work, and re-elects automatically when it dies.

## Why it matters

Some jobs must be done by exactly one node — advancing a replication log, running a scheduler, assigning shards — or you get split-brain double-writes and corruption. Hard-coding the leader creates a single point of failure; leader election gives you a *designated* coordinator plus automatic [[availability-patterns-failover-replication|failover]], so the cluster keeps a single source of truth while surviving the loss of any node.

## How it works

Election rests on a consensus protocol (Raft, Paxos) or a coordination service (ZooKeeper, etcd). The core safety rule is a **quorum**: a leader is valid only with votes from a majority (`N/2 + 1`), which mathematically prevents two leaders in disjoint partitions.

- **Term / epoch** — a monotonically increasing number; each election bumps it so stale leaders are fenced off.
- **Lease + heartbeat** — the leader holds a time-bound lease and renews it; missed renewals trigger a new election.
- **Fencing token** — the epoch is attached to every write so downstream systems reject a deposed leader's late writes.

```
Raft (5 nodes): leader heartbeats every 150ms
  follower misses heartbeat past random timeout
    → becomes candidate, term++ , requests votes
    → gets 3/5 votes → becomes leader for new term
  old leader returns with lower term → steps down
```

This is the machinery behind a single-writer [[rdbms-replication-master-slave-master-master|primary]]. It is a strict [[availability-vs-consistency-cap-theorem|CP]] choice: during a partition the minority side has no leader and rejects writes to stay consistent.

## Example

A 3-node Postgres cluster with Patroni stores leader state in etcd.

```
node-A holds the leader lease (epoch 7), serves writes
node-A's host freezes → lease expires after 30s
etcd election → node-B wins, epoch 8, promotes to primary
node-A thaws, tries to write → fenced: its epoch 7 < 8 → demoted to replica
```

No window with two primaries, so no conflicting writes.

## Pitfalls

- **No fencing token** — a paused old leader can wake and corrupt data; every write must carry and check the epoch.
- **Even node counts** — 2 or 4 nodes can't form a clean majority in a 50/50 split; use odd counts (3, 5).
- **Lease shorter than failover work** — flapping leaders re-elect constantly; size the lease above realistic detection time.
- **Co-locating the coordination store** — running etcd on the same hosts couples its failure to the workload it protects.

## See also

- [[availability-patterns-failover-replication]]
- [[rdbms-replication-master-slave-master-master]]
