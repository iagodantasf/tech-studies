---
title: Node roles (master, data, ingest, coordinating)
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, node-roles]
prerequisites: [nodes-cluster]
see-also: [discovery-cluster-formation, shard-allocation-routing, hot-warm-cold-architecture]
---

# Node roles (master, data, ingest, coordinating)

Every Elasticsearch node advertises a set of *roles* in `node.roles`; the roles a node holds determine which work it is eligible to do — cluster bookkeeping, holding data, transforming documents, or fanning out queries.

## Why it matters

Mixing all duties on one node type works in dev but bites in production: a long GC pause on a data-heavy node that is also master can stall the whole cluster. Dedicating roles isolates failure domains, lets you size hardware per workload (CPU for ingest, RAM+disk for data), and is the foundation of [[hot-warm-cold-architecture|tiered]] architectures.

## How it works

A node can carry multiple roles; the common ones:

| Role (`node.roles`) | Job | Sizing pressure |
|---|---|---|
| `master` | Maintains cluster state, allocates shards | Low CPU/disk, stable network |
| `data` (+ `data_hot`/`warm`/`cold`) | Stores shards, executes shard-local query+agg phases | Disk, heap, CPU |
| `ingest` | Runs [[ingest-pipelines]] before indexing | CPU |
| coordinating (empty `[]`) | Receives request, scatters to shards, gathers+merges | RAM for merge/reduce |

- **Master eligibility vs active master** — only `master`-role nodes can be *elected*; one is the active master at a time (see [[discovery-cluster-formation]]). Quorum needs `(N/2)+1` of them.
- **Coordinating-only** node = all roles stripped; acts as a smart load balancer and offloads the gather/reduce phase from data nodes.
- **Dedicated master** node should *not* be `data` or `ingest` so heavy queries can't destabilize the cluster brain.
- Every node is implicitly coordinating; the "coordinating-only" node just does *nothing else*.

## Example

A 7-node production cluster:

```
3 × dedicated master  (8 GB RAM, role: [master])      → quorum 2
3 × data_hot          (64 GB, role: [data_hot,ingest])
1 × coordinating-only (16 GB, role: [])               → fronts Kibana
```

Losing one master node still leaves 2 of 3 (quorum met) — the cluster keeps electing and stays writable.

## Pitfalls

- **Two dedicated masters** gives quorum `(2/2)+1 = 2`, so losing *either* halts the cluster — always run 3 (or 5), never 2 or 4.
- **Master that is also a hot data node** — a heap spike or GC pause there can drop it from the cluster and trigger a needless master re-election.
- **Forgetting `ingest`** on the nodes that index — if no reachable node has the `ingest` role, pipeline-tagged writes fail.
- **Coordinating node OOM** — large `size`/deep aggregations reduce on the coordinator; an undersized one OOMs while data nodes look idle.

## See also

- [[discovery-cluster-formation]]
- [[hot-warm-cold-architecture]]
