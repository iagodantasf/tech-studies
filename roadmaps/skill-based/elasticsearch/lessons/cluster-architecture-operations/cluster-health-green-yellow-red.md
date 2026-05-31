---
title: Cluster health (green / yellow / red)
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, cluster-health]
prerequisites: [shards-replicas, shard-allocation-routing]
see-also: [snapshots-restore, rolling-upgrades, node-roles-master-data-ingest-coordinating]
---

# Cluster health (green / yellow / red)

Cluster health is a single traffic-light status — green, yellow, or red — computed from whether every primary and replica [[shards-replicas|shard]] is assigned to a node.

## Why it matters

It is the first signal you check during an incident and the gate every safe operation waits on. The color tells you, in one word, whether you have lost *redundancy* (yellow) or *data availability* (red) — and it drives automation: deploy scripts and [[rolling-upgrades|rolling upgrades]] block until green.

## How it works

Health is the *worst* status across indices; an index's status is the worst across its shards:

| Status | Meaning | Searchable? | Writable? |
|---|---|---|---|
| green | All primaries + all replicas assigned | Yes | Yes |
| yellow | All primaries assigned, ≥1 replica not | Yes | Yes |
| red | ≥1 *primary* unassigned | Partial (missing shard's docs gone) | Partial |

- **Red ≠ whole cluster down** — only the indices with a missing primary are impaired; other indices serve normally. Queries touching the missing shard return partial results (`_shards.failed > 0`).
- **Yellow is normal transiently** — right after creating an index or losing a node, replicas are `unassigned` until they recover/relocate.
- **Diagnose, don't guess** — `_cluster/allocation/explain` tells you *why* a specific shard won't allocate (disk watermark, awareness, no copy on disk).

## Example

```
GET _cluster/health
{ "status":"yellow", "active_primary_shards":50,
  "active_shards":95, "unassigned_shards":5, ... }

# Why is one stuck?
GET _cluster/allocation/explain
{ "index":"logs-2026.05", "shard":3, "primary":false }
→ "decision":"NO", reason: disk watermark high exceeded
```

Wait-for in scripts: `GET _cluster/health?wait_for_status=green&timeout=60s` blocks (long-polls) up to 60 s.

## Pitfalls

- **Treating yellow as an outage** — a single-node dev cluster with replicas is *always* yellow (no second node for the replica); that is expected, not broken.
- **Restoring health by deleting data** — red from a lost primary with no replica means that data is gone; only a [[snapshots-restore|snapshot restore]] (or reindex from source) brings it back.
- **Ignoring `unassigned_shards` count** — green with high pending tasks can still mean an overloaded master; check `_cluster/health` *and* `pending_tasks`.
- **flood_stage read-only** — disk at 95% blocks writes and can leave indices read-only even after cleanup; health may read green while writes silently fail.

## See also

- [[shard-allocation-routing]]
- [[snapshots-restore]]
