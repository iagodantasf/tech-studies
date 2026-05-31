---
title: Force merge & refresh interval
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, segments]
prerequisites: [segments]
see-also: [bulk-indexing-tuning, hot-warm-cold-architecture, near-real-time-search]
---

# Force merge & refresh interval

Two [[segments|segment]] controls: `refresh_interval` governs how often new docs become searchable, and `force_merge` manually collapses a shard's segments into fewer, larger ones.

## Why it matters

[[near-real-time-search|Near real-time]] search creates a new segment on every refresh, so a busy index accumulates hundreds of segments that every query must search. Tuning refresh trades freshness for write throughput; force-merge reclaims deleted-doc space and shrinks segment count on read-only data. Both directly move write throughput, search latency, and disk usage.

## How it works

New docs sit in an in-memory buffer until a **refresh** seals them into a searchable segment (this is not durability — that's the translog flush).

```
PUT logs/_settings { "index.refresh_interval": "30s" }   # fewer, bigger segments
POST warm-2026.04/_forcemerge?max_num_segments=1         # read-only index only
```

| Setting | Default | Raise it to | Cost |
|---|---|---|---|
| `refresh_interval` | 1s | 30s / `-1` (bulk) | Docs visible later |
| `force_merge` segments | — | 1 (on read-only) | Heavy one-time I/O |

- **`refresh_interval: -1`** during a [[bulk-indexing-tuning|bulk load]] stops per-second segment creation; a single refresh at the end seals everything at once.
- **`?wait_for_completion=false`** — force-merge is a long blocking task; run it async and poll, never inline on a request path.
- **Merge only read-only indices** — on a write-active index, new docs immediately produce fresh segments, so merging to 1 wastes I/O and the gain evaporates. Force-merge belongs in the [[hot-warm-cold-architecture|warm]] phase.
- **Refresh on demand** — `?refresh=wait_for` on a write lets a single doc become searchable without forcing a global refresh, useful for read-your-writes.

## Example

Hot logging index runs at `refresh_interval: 5s` (search rarely needs sub-5s freshness; this cuts segment churn ~5×, lifting indexing throughput). At rollover the index goes read-only and [[index-lifecycle-management-ilm|ILM]] runs `force_merge max_num_segments=1`, collapsing ~80 segments into 1 — purging tombstoned docs and shrinking the shard ~20% so warm queries scan a single segment.

## Pitfalls

- **Force-merging hot/active indices** — burns CPU and I/O for nothing as new segments keep arriving; the recommended `max_num_segments=1` is for indices that will never be written again.
- **Leaving `refresh_interval: -1`** after a load — the index never becomes searchable until a manual refresh; restore it.
- **Synchronous force-merge** — blocks until done (minutes to hours) and can saturate disk; run async and stagger across indices.
- **Tiny `refresh_interval` on heavy writes** — 1s on a high-ingest index causes [[segments|segment]] sprawl and merge pressure; raise it if freshness allows.

## See also

- [[segments]]
- [[bulk-indexing-tuning]]
