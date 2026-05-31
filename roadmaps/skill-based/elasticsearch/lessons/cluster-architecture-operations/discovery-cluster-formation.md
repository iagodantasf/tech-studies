---
title: Discovery & cluster formation
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, discovery]
prerequisites: [nodes-cluster, node-roles-master-data-ingest-coordinating]
see-also: [cluster-health-green-yellow-red, shard-allocation-routing, rolling-upgrades]
---

# Discovery & cluster formation

Discovery is how nodes find each other and elect a master that owns the authoritative cluster state; cluster formation is the one-time *bootstrap* of that initial master quorum.

## How it works

Since 7.0 the legacy `minimum_master_nodes` is gone, replaced by a built-in [Raft-like](https://raft.github.io) consensus over a *voting configuration* of master-eligible nodes.

- **Seed hosts** — `discovery.seed_hosts` lists addresses to ping; a new node contacts them to learn the cluster.
- **Bootstrapping** — on a brand-new cluster, `cluster.initial_master_nodes` names the master-eligible nodes that form the first quorum. Set it *once*, only at genesis.
- **Voting config & quorum** — the master commits a cluster-state change only with a majority of the voting config: `(V/2)+1`. With 3 master-eligible nodes, quorum is 2.
- **Auto voting-config** — Elasticsearch shrinks the voting config as nodes leave (down to a safe odd size) and grows it as they return, keeping quorum sane without manual tuning.
- **Master election** — on master loss, eligible nodes campaign; the winner publishes a new cluster-state version that the majority must acknowledge before it commits.

| Setting | When used | Danger |
|---|---|---|
| `discovery.seed_hosts` | Always (find peers) | Wrong list → node can't join |
| `cluster.initial_master_nodes` | Genesis only | Reusing it later → split clusters |

## Example

Bringing up a fresh 3-master cluster — set on the master-eligible nodes:

```
discovery.seed_hosts: ["es01","es02","es03"]
cluster.initial_master_nodes: ["es01","es02","es03"]
```

After they form the cluster and elect a master, you **remove** `initial_master_nodes` from config so a future restart never re-bootstraps a second, separate cluster.

## Pitfalls

- **Leaving `initial_master_nodes` set** after bootstrap — a partitioned subset can bootstrap its *own* cluster, splitting your data ([[shards-replicas|shards]] diverge).
- **Even number of masters** — 4 masters still need quorum 3; you tolerate only one failure, same as 3 nodes but with more election noise.
- **Hostname mismatch** — names in `initial_master_nodes` must match each node's `node.name`, or bootstrap silently never completes.
- **Cross-cluster bootstrap reuse** — copying a config with the same `initial_master_nodes` to a second environment can cause nodes to try to join the wrong cluster.

## See also

- [[node-roles-master-data-ingest-coordinating]]
- [[cluster-health-green-yellow-red]]
