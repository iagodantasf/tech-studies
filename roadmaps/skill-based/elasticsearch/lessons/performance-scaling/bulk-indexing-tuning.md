---
title: Bulk indexing tuning
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, bulk-indexing]
prerequisites: [bulk-api]
see-also: [force-merge-refresh-interval, sharding-strategy, segments]
---

# Bulk indexing tuning

The set of settings and client behaviors that maximize sustained write throughput when loading large volumes via the [[bulk-api|Bulk API]] — concurrency, batch size, refresh, and replicas.

## Why it matters

Default indexing is tuned for [[near-real-time-search|near real-time]] search, not bulk loads; a naive reindex of billions of docs can take days or trip `429`s. The right knobs routinely yield 5–20× throughput. The catch: most of them trade search freshness or durability for speed, so they belong on initial loads and reindexes, not steady-state ingest.

## How it works

Throughput is bounded by the slowest of: client concurrency, [[segments|segment]] refresh churn, replication, and merge I/O.

| Knob | Default | Bulk-load value | Effect |
|---|---|---|---|
| Batch size | — | 5–15 MB per request | Amortize round-trips |
| Concurrent requests | 1 | ≈ number of data nodes | Saturate write threads |
| `refresh_interval` | 1s | `-1` during load | Stop per-second segment churn |
| `number_of_replicas` | 1 | `0` during load | Skip replicating every write |

- **Size batches by bytes, not docs** — 5–15 MB is the sweet spot; bigger batches stress the coordinating node's heap and risk `429`.
- **Find concurrency empirically** — ramp parallel bulk requests until throughput plateaus or rejections appear; the write [[bulk-api|thread pool]] queue is finite.
- **Disable refresh and replicas during the load**, then restore them and let one refresh + replication catch up — far cheaper than doing both per batch.
- **Use auto-generated IDs** when possible — providing an `_id` forces a "does this id already exist?" lookup across segments; auto IDs skip it.

## Example

Load 1 B docs. Set `refresh_interval:-1`, `number_of_replicas:0`. Run 4 client threads (matching 4 data nodes), ~10 MB batches, auto IDs. On `429`, exponential backoff (not faster). After the load: `number_of_replicas:1`, `refresh_interval:1s`, one [[force-merge-refresh-interval|force_merge]] to few segments. Net: a load that took ~10 h at defaults finishes in ~1 h.

## Pitfalls

- **Leaving `replicas:0` permanently** — great for loading, but a node loss now means data loss; always restore replicas before going live.
- **Hammering through `429`** — rejections mean the write queue is full; retrying *faster* makes it worse, back off per-item.
- **Over-large batches** — multi-hundred-MB bulks cause heap pressure and GC pauses, *lowering* throughput.
- **Client bottleneck** — a single-threaded loader on a multi-node cluster leaves most write capacity idle; parallelize the client too.

## See also

- [[bulk-api]]
- [[force-merge-refresh-interval]]
