---
title: Indices
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, indices]
prerequisites: [documents]
see-also: [shards-replicas, index-templates, data-streams]
---

# Indices

An index is a named collection of [[documents]] with one [[mappings|mapping]] and one set of settings, physically realized as a group of [[shards-replicas|shards]] spread across the cluster.

## Why it matters

The index is your primary unit of schema, scaling, and lifecycle: shard count, replicas, analyzers, and retention all attach here. Time-series workloads (logs, metrics) roll a *new* index per day/size and drop old ones whole — a cheap `DELETE` instead of millions of row deletes — which is why index design drives storage cost and query fan-out more than any single query does.

## How it works

An index is mostly an alias-able label over shards plus metadata.

- **Settings split into two** — `static` (set at creation, e.g. `number_of_shards`) and `dynamic` (changeable live, e.g. `number_of_replicas`, [[force-merge-refresh-interval|refresh_interval]]).
- **Aliases** give a stable name over a changing set of indices — point `logs` at `logs-2026.05.30` and atomically swap on rollover; readers never change their query.
- **[[index-templates|Templates]]** apply mappings/settings to any index whose name matches a pattern, so new daily indices are born configured.

| Concept | Scope | Example |
|---|---|---|
| Index | Schema + shard topology | `products`, `logs-2026.05.30` |
| Alias | Logical pointer over 1..N indices | `logs` → today's index |
| Data stream | Managed append-only index set | `logs` backed by hidden indices |

## Example

```
PUT /products
{ "settings": { "number_of_shards": 3, "number_of_replicas": 1 },
  "mappings": { "properties": { "name": { "type": "text" } } } }
```

This creates 3 primaries × 1 replica = 6 shards. `number_of_shards` is fixed for the life of the index; to change it you [[reindex-api|reindex]] into a new one.

## Pitfalls

- **Over-sharding** — hundreds of tiny indices/shards waste heap (cluster state + per-shard overhead); aim for shards of ~10–50 GB.
- **Editing static settings** — `number_of_shards` cannot change in place; plan it up front or use [[data-streams]] + rollover.
- **Hard-coding the dated index name** in clients — always read/write through an [[indices|alias]] so rollover is invisible.

## See also

- [[shards-replicas]]
- [[index-lifecycle-management-ilm]]
