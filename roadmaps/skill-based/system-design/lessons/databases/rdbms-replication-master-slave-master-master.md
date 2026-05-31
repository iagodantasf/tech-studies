---
title: RDBMS & replication (master-slave, master-master)
track: system-design
group: Databases
tags: [system-design, replication]
prerequisites: [databases]
see-also: [federation, sharding]
---

# RDBMS & replication (master-slave, master-master)

Replication keeps copies of a relational database on multiple nodes so you can survive failures and serve more reads than one machine could.

## Why it matters

A single database is both a bottleneck and a single point of failure: lose it and the app is down, saturate it and every query slows. Replication is the cheapest first lever — it buys read scale and a hot standby without changing your schema or query patterns. It is also where you first meet the [[availability-vs-consistency-cap-theorem]] trade in production.

## How it works

A **master** (primary) takes writes and ships its change log to one or more **replicas**.

- **Master-slave** — one writer, N read-only replicas. Reads scale horizontally; writes do not. On master failure you **promote** a replica (manual or automatic [[leader-election]]).
- **Master-master** — two or more nodes each accept writes and replicate to each other. Survives a single writer loss, but concurrent writes to the same row create **conflicts**.

Propagation mode sets the consistency/latency trade:

| Mode | Commit waits for | On primary crash |
|---|---|---|
| Asynchronous | local write only | recent writes can be lost |
| Synchronous | replica ack | no loss, higher latency |
| Semi-sync | one replica ack | bounded loss |

Async is the common default, so replicas lag — see [[consistency-patterns-weak-eventual-strong]].

## Example

Read-heavy web app, async master-slave:

```
writes ─────────────► [ master ]
                       /   |   \   (binlog stream, ~10-200ms lag)
                 [replica][replica][replica]
reads ◄────────────────────┘  (load-balanced across replicas)
```

A user posts a comment (write to master) then refreshes (read from a lagging replica) and the comment is missing — classic **read-your-writes** failure. Fix: route that user's reads to the master briefly, or read from the primary after a write.

## Pitfalls

- **Replication lag breaks read-your-writes.** Pin a user to the primary right after they write.
- **Promotion is not instant.** Detecting a dead master and promoting takes seconds; you need fencing to avoid two primaries (**split-brain**).
- **Master-master conflict resolution is hard.** Last-write-wins silently drops data; prefer a single logical writer per key when you can.
- **Replicas drift schema or version.** A replica on a different engine version can replicate subtly wrong.

## See also

- [[federation]]
- [[sharding]]
