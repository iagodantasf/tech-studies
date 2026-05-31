---
title: Hot-warm-cold architecture
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, data-tiers]
prerequisites: [index-lifecycle-management-ilm]
see-also: [data-streams, force-merge-refresh-interval, sharding-strategy]
---

# Hot-warm-cold architecture

A tiered topology that routes indices to progressively cheaper hardware as they age — hot for active writes, warm/cold for read-only history, frozen for searchable archives.

## Why it matters

Time-series data is written once but kept for weeks or years; serving year-old logs from the same NVMe SSDs as today's writes is hugely wasteful. Data tiers let [[index-lifecycle-management-ilm|ILM]] migrate aging [[data-streams|backing indices]] to dense HDD or even object storage, cutting cost 5–20× while keeping old data searchable at acceptable latency.

## How it works

Nodes advertise a tier via `node.roles`; ILM moves shards by editing each index's `index.routing.allocation` to match.

| Tier | Role | Hardware | Workload |
|---|---|---|---|
| Hot | `data_hot` | NVMe SSD, high CPU/RAM | Active writes + recent reads |
| Warm | `data_warm` | SSD/HDD, less RAM | Read-only, occasional queries |
| Cold | `data_cold` | Dense HDD | Rare queries, searchable snapshots |
| Frozen | `data_frozen` | Local cache + object store | Archive, partial download on demand |

- **Hot** holds the write index; this is where [[force-merge-refresh-interval|refresh interval]] and indexing throughput matter most.
- **Warm/cold** indices are read-only, so ILM can [[force-merge-refresh-interval|force-merge]] them to 1 segment, drop replicas, and shrink primaries to save heap and disk.
- **Frozen** mounts a [[snapshots-restore|searchable snapshot]] from S3/GCS — data lives in object storage and is fetched into a local cache per query, trading latency for near-zero storage cost.
- **Allocation awareness** — without tier roles configured, ILM "move to warm" silently no-ops or can't allocate; tiers must exist before the policy references them.

## Example

A 90-day log ILM policy: **hot** 0–2 days (writes, 3 primaries + 1 replica) → **warm** at 2 days (force-merge, 0 replicas, allocate to `data_warm`) → **cold** at 14 days (searchable snapshot on HDD) → **delete** at 90 days. A cluster of 3 hot + 2 warm + 1 cold node serves yesterday's logs in milliseconds and 60-day-old logs in seconds, at a fraction of all-SSD cost.

## Pitfalls

- **No warm/cold nodes** — a policy that says "move to warm" with no `data_warm` node leaves shards `unassigned` and the index stuck; provision tiers first.
- **Force-merging on hot** — only force-merge after the index is read-only in warm; doing it on a write-active index wastes I/O ([[segments|segments]]).
- **Frozen latency surprise** — frozen queries can take seconds and saturate the cache; size the local cache for your query patterns.
- **Replicas in cold/frozen** — keeping replicas on cheap tiers doubles cold storage; rely on the underlying snapshot for durability instead.

## See also

- [[index-lifecycle-management-ilm]]
- [[data-streams]]
