---
title: Rolling upgrades
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, upgrades]
prerequisites: [nodes-cluster, cluster-health-green-yellow-red]
see-also: [snapshots-restore, shard-allocation-routing, discovery-cluster-formation]
---

# Rolling upgrades

A rolling upgrade moves a cluster to a new Elasticsearch version one node at a time, with no downtime, by upgrading each node while the rest keep serving.

## Why it matters

Search clusters back live products; you cannot take them fully offline to upgrade. Rolling upgrades keep the index searchable throughout, but they only work *within* supported version steps and demand discipline — skip a step and nodes refuse to rejoin.

## How it works

The cluster tolerates mixed versions *temporarily*, so you cycle nodes one by one. Per-node loop:

1. **Disable shard allocation** so the cluster doesn't pointlessly rebuild replicas while a node is briefly down.
2. **Stop indexing & flush** — a synced/normal flush speeds recovery of the restarted node.
3. **Stop, upgrade the binary/package, restart** the node; it rejoins.
4. **Re-enable allocation** and **wait for green** before touching the next node.

```
PUT _cluster/settings { "persistent": { "cluster.routing.allocation.enable": "primaries" } }
# upgrade node, restart...
PUT _cluster/settings { "persistent": { "cluster.routing.allocation.enable": null } }
GET _cluster/health?wait_for_status=green
```

| Rule | Why |
|---|---|
| Upgrade *data* nodes only after masters | Newer masters understand older data nodes, not vice-versa |
| One minor-major step at a time | e.g. 7.17 → 8.x; can't jump 6.x → 8.x directly |
| Same-major upgrades are rolling | Cross-major may need a bridge version + full-cluster restart |

- **Order** — upgrade master-eligible nodes last is *not* the rule; upgrade them such that the cluster always has a compatible master. Follow the version's docs; ingest/coordinating-only nodes upgrade first, then data, then masters per Elastic's guidance.
- **Mixed-version is transient** — never run a mixed cluster as a steady state; shard recovery between unlike versions is restricted.

## Example

Upgrading a 7-node cluster from 8.11 → 8.13: snapshot first, then disable allocation, restart node 1, wait green, repeat for nodes 2–7. Throughout, [[cluster-health-green-yellow-red|health]] dips to yellow per node (a replica goes missing) but never red — full searchability the whole time.

## Pitfalls

- **Not snapshotting first** — a botched upgrade with no [[snapshots-restore|snapshot]] can mean unrecoverable data; always back up before starting.
- **Skipping a major** — jumping 6.x → 8.x is unsupported; you must pass through 7.17, which also requires resolving deprecated mappings.
- **Forgetting to re-enable allocation** — leaving `allocation.enable: primaries` set means replicas never rebuild and health is stuck yellow indefinitely.
- **Upgrading data before master** — an older master can't manage newer data nodes; they may fail to join until the master is upgraded.

## See also

- [[snapshots-restore]]
- [[cluster-health-green-yellow-red]]
