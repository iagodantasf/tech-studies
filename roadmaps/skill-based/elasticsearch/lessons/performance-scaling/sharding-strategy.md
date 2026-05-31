---
title: Sharding strategy
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, sharding]
prerequisites: [shards-replicas]
see-also: [data-streams, index-lifecycle-management-ilm, bulk-indexing-tuning]
---

# Sharding strategy

Sharding strategy is the deliberate sizing and counting of primary [[shards-replicas|shards]] so a cluster stays balanced, queryable, and cheap to recover — the single biggest knob on cluster stability.

## Why it matters

Primary count is fixed at index creation and only changeable by [[reindex-api|reindex]] or [[update-by-query-delete-by-query|split/shrink]], so a bad guess haunts you for the index's life. Too many small shards bloat cluster state and waste heap; too few giant shards can't rebalance and slow recovery. Time-series setups multiply this across thousands of indices, so the per-index choice compounds.

## How it works

The targets below are Elastic's field-tested rules of thumb, not hard limits.

| Lever | Healthy target | Failure mode if ignored |
|---|---|---|
| Shard size | 10–50 GB (search), up to 50 GB (logs) | <1 GB → overhead; >50 GB → slow recovery |
| Shards per GB heap | ≤ 20 shards per GB | Heap pressure, slow cluster-state updates |
| Primaries per index | size ÷ target shard size | Hotspotting or unrebalanceable giants |

- **Capacity formula** — `primaries ≈ ceil(expected_index_size / 30GB)`; round to spread evenly across data nodes.
- **Routing** — docs land via `hash(_routing) % primaries`; a custom [[shard-allocation-routing|routing]] key can co-locate a tenant's docs on one shard for faster queries, at the risk of skew.
- **Split/shrink** — `_split` multiplies primaries (target must be a multiple), `_shrink` divides them; both need a read-only source and produce a new index.
- **Replicas** are orthogonal — they add HA and read capacity but never change the routing math.

## Example

A log platform ingests ~150 GB/day. Targeting 30 GB shards: `ceil(150/30) = 5` primaries per daily index. With `1` replica that's 10 shards/day; over 30 days of retention = 300 shards — comfortably under a 3-node × 30 GB-heap budget (≈1800 shard ceiling). Switching to weekly indices would cut index count 7× but push each shard past 200 GB — too big.

## Pitfalls

- **One-shard-fits-all** — leaving the old default of 5 (or blindly using 1) ignores actual data volume; size from a real estimate.
- **Empty-shard sprawl** — daily indices for low-volume streams create thousands of near-empty shards; use [[data-streams|rollover]] by size, not just date.
- **Forgetting replicas in the budget** — replica shards count fully against the per-node shard limit and disk.
- **Resharding live** — you cannot change primaries in place; design for growth or plan [[index-lifecycle-management-ilm|ILM]] rollover up front.

## See also

- [[shards-replicas]]
- [[data-streams]]
