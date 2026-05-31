---
title: Nodes & cluster
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, cluster]
prerequisites: [shards-replicas]
see-also: [node-roles-master-data-ingest-coordinating, discovery-cluster-formation, cluster-health-green-yellow-red]
---

# Nodes & cluster

A node is a single running Elasticsearch process; a cluster is a set of nodes that share a cluster name, elect a master, and cooperatively host one shared set of [[indices|indices]] and [[shards-replicas|shards]].

## Why it matters

The cluster is the distributed-systems boundary: it owns the *cluster state* (mappings, routing table, settings) and coordinates allocation, failover, and rebalancing. Understanding which node does what — and how a master is elected — is what separates "we lost quorum and the cluster froze" from a clean, surviving outage. This is the [[concurrency-and-deadlocks|coordination]] layer of the whole system.

## How it works

Every node advertises one or more [[node-roles-master-data-ingest-coordinating|roles]]; the cluster state is the source of truth, replicated to all nodes.

| Role | Responsibility |
|---|---|
| `master` (eligible) | Holds/updates cluster state; one is elected active |
| `data` | Stores shards, executes search/index on them |
| `ingest` | Runs ingest pipelines (enrich/transform) before indexing |
| `coordinating` | Routes requests, fans out, merges results |

- **Master election** — master-eligible nodes use a quorum (Raft-like) protocol; you need `(N/2)+1` of them to elect a master and accept state changes.
- **Discovery** — new nodes find seeds via `discovery.seed_hosts`, then join the elected master (see [[discovery-cluster-formation]]); `ingest` nodes run [[ingest-pipelines|ingest pipelines]] before docs are indexed.
- **Failover** — if a data node dies, the master reallocates its replicas to surviving nodes and rebalances.

## Example

A resilient 3-master / N-data layout:

```
nodes: m1,m2,m3 (master-eligible) + d1..d6 (data)
quorum = (3/2)+1 = 2 master-eligible nodes must agree
lose m1 → m2,m3 still form quorum → cluster keeps writing
lose m1 AND m2 → no quorum → reads may continue, no state changes
```

Dedicated masters keep cluster-state work off heavy data nodes.

## Pitfalls

- **Even number of master-eligible nodes** — 2 masters give a quorum of 2, so losing either halts the cluster; always use an odd count (3, 5).
- **Split brain** historically came from mis-set minimum-master quorum; modern ES (7+) computes it, but mixing versions or hand-editing voting config can still break it.
- **One node doing everything** at scale — a coordinating-heavy search load on a master node can stall elections; separate roles as you grow.

## See also

- [[node-roles-master-data-ingest-coordinating]]
- [[cluster-health-green-yellow-red]]
