---
title: Shards & replicas
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, shards]
prerequisites: [indices]
see-also: [nodes-cluster, sharding-strategy, cluster-health-green-yellow-red]
---

# Shards & replicas

A shard is a self-contained Lucene index holding a slice of an [[indices|index]]'s [[documents]]; a replica is a full copy of a primary shard kept on a different [[nodes-cluster|node]] for high availability and read throughput.

## Why it matters

Shards are how Elasticsearch scales horizontally and survives node loss. A primary defines a unit of parallelism (queries fan out across shards and merge); replicas define your fault tolerance and read capacity. Getting shard *count* and *size* right is the single biggest lever on cluster stability — too many small shards waste heap, too few huge ones can't be rebalanced.

## How it works

Documents route to a primary by hashing the `_id` (or custom routing): `shard = hash(routing) % number_of_primaries`.

- **Primaries are fixed at create time** — `number_of_shards` can't change in place because the routing formula depends on it; changing it needs a [[reindex-api|reindex]].
- **Replicas are dynamic** — `number_of_replicas` can go up/down live; a replica can be promoted to primary if a node dies.
- **A primary and its replicas never share a node** — that would defeat HA, so total shards must fit across distinct nodes.
- **Writes** hit the primary, then replicate to replicas before acking (configurable via `wait_for_active_shards`); **reads** can be served by any copy.

| Term | Role | Mutable? |
|---|---|---|
| Primary | Owns a slice; accepts writes | Count fixed at creation |
| Replica | Copy for HA + read scaling | Count changeable anytime |

## Example

```
PUT /logs { "settings": { "number_of_shards": 5, "number_of_replicas": 1 } }
```

5 primaries + 5 replicas = 10 shards. On a 5-node cluster, each node holds ~2 shards. Lose one node: its primaries' replicas elsewhere promote to primary; [[cluster-health-green-yellow-red|health]] goes yellow (under-replicated) but stays fully searchable.

## Pitfalls

- **Over-sharding** — every shard costs file handles, memory, and cluster-state weight; target ~10–50 GB per shard, not hundreds of tiny ones.
- **`number_of_replicas` higher than `nodes-1`** leaves replicas permanently `unassigned` → stuck yellow, since no second node exists to host them.
- **Hotspotting** — a bad custom `routing` key can pile most docs onto one shard, wrecking parallelism.

## See also

- [[nodes-cluster]]
- [[sharding-strategy]]
