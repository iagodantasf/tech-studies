---
title: Segments
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, segments]
prerequisites: [shards-replicas]
see-also: [near-real-time-search, force-merge-refresh-interval, inverted-index]
---

# Segments

A segment is an immutable mini-index inside a [[shards-replicas|shard]]: a self-contained [[inverted-index|inverted index]] (plus doc values and stored fields) that Lucene writes once and never modifies.

## Why it matters

Segments are why Elasticsearch is fast to write and [[near-real-time-search|near real-time]] to read. Because they're immutable, writes are append-only (no in-place updates, no write locks on existing data), but the cost is that a shard accumulates *many* segments that every query must search, and deletes/updates only mark old docs as tombstones. Managing segment count is core to read latency and disk usage.

## How it works

New docs land in an in-memory buffer; a **refresh** turns the buffer into a new searchable segment.

- **Refresh ≠ commit** — refresh (default every [[force-merge-refresh-interval|1s]]) makes docs searchable; a **flush** fsyncs segments and clears the translog for durability.
- **Translog** — a write-ahead log makes a doc durable *before* it's in a committed segment, so a crash between refreshes loses nothing.
- **Updates and deletes are tombstones** — the old doc stays on disk marked deleted until a merge removes it; `_version`/`_seq_no` track the live copy.
- **Merging** — a background process combines small segments into fewer larger ones and physically drops deleted docs.

| Action | Frequency (default) | Effect |
|---|---|---|
| Refresh | 1s | New searchable segment in memory |
| Flush | ~translog size/age | fsync segments, truncate translog |
| Merge | Continuous, tiered | Fewer, bigger segments; purges deletes |

## Example

```
index 30k docs over 30s with refresh_interval=1s
→ ~30 small segments created (1 per refresh)
query → must consult all ~30 segments, union results
background merge → collapses to ~3–4 larger segments → faster queries
```

A bulk reload runs much faster with `refresh_interval: -1` (no per-second segments), then a single refresh at the end.

## Pitfalls

- **Too many segments** — heavy small-batch indexing creates segment sprawl, slowing search; let merges catch up or raise `refresh_interval`.
- **Manual `force_merge` on hot indices** — merging a write-active index to 1 segment wastes I/O and can hurt; only force-merge read-only (e.g. [[hot-warm-cold-architecture|cold]]) indices.
- **Disk for merges** — a merge can temporarily need extra free space equal to the segments being merged; a full disk stalls merging and indexing.

## See also

- [[near-real-time-search]]
- [[force-merge-refresh-interval]]
