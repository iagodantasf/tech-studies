---
title: Shard allocation & routing
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, allocation]
prerequisites: [shards-replicas, nodes-cluster]
see-also: [cluster-health-green-yellow-red, hot-warm-cold-architecture, node-roles-master-data-ingest-coordinating]
---

# Shard allocation & routing

Allocation is the master's decision of *which node* hosts each shard copy; routing is the deterministic mapping of a [[documents|document]] to its primary [[shards-replicas|shard]].

## Why it matters

Good allocation keeps data evenly spread, survives a rack/zone loss, and avoids hotspots; bad allocation leaves shards `unassigned` (yellow/red [[cluster-health-green-yellow-red|health]]) or piles writes on one node. Routing controls parallelism: route everything to one shard and you serialize a "distributed" cluster.

## How it works

**Routing** picks the primary: `shard = hash(_routing) % number_of_primaries`, where `_routing` defaults to `_id`. A custom `routing` value sends related docs to the same shard so a query can target a single shard.

**Allocation** runs through *deciders* — each can say yes/no/throttle:

| Decider | Prevents |
|---|---|
| Same-shard | Primary + its replica on one node |
| Disk threshold | Filling a disk past watermarks |
| Awareness | All copies in one zone/rack |
| Filtering | Shards on excluded nodes |

- **Disk watermarks** — `low` (85%, default) stops *new* shards landing; `high` (90%) relocates shards *off*; `flood_stage` (95%) flips affected indices to read-only.
- **Allocation awareness** — `cluster.routing.allocation.awareness.attributes: zone` spreads primary+replica across `zone` values so a zone outage loses no data.
- **Filtering** — `index.routing.allocation.{include,exclude,require}.<attr>` pins or evicts an index (the mechanism behind [[hot-warm-cold-architecture|hot-warm]] tiers).
- **Rebalancing** — concurrency is throttled (`cluster_concurrent_rebalance`, default 2) so moves don't saturate the network.

## Example

Force a search-routing key so all of one tenant's docs co-locate:

```
PUT /events/_doc/42?routing=tenant-7  { ... }
GET /events/_search?routing=tenant-7  { "query": {...} }   # hits 1 shard, not all
```

Drain a node before maintenance (shards relocate elsewhere, no data loss):

```
PUT _cluster/settings
{ "transient": { "cluster.routing.allocation.exclude._name": "es-data-03" } }
```

## Pitfalls

- **Custom routing skew** — one fat tenant on a shared `routing` key creates a giant hot shard; parallelism and balance both suffer.
- **Hitting flood_stage** — at 95% disk, indices go read-only and *stay* read-only after you free space until you clear `index.blocks.read_only_allow_delete` manually.
- **`number_of_replicas` > nodes−1** — surplus replicas are permanently `unassigned`, parking health at yellow.
- **No awareness in multi-AZ** — without awareness, primary and replica can land in the *same* AZ; one AZ outage then loses both copies.

## See also

- [[cluster-health-green-yellow-red]]
- [[hot-warm-cold-architecture]]
