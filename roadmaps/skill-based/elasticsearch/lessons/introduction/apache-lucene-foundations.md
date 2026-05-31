---
title: Apache Lucene foundations
track: elasticsearch
group: Introduction
tags: [elasticsearch, lucene]
prerequisites: []
see-also: [what-is-elasticsearch, inverted-index, segments]
---

# Apache Lucene foundations

Lucene is the Java full-text library Elasticsearch is built on; every shard *is* a Lucene index, so Lucene's behavior dictates Elasticsearch's.

## Why it matters

The traits engineers blame on Elasticsearch — [[near-real-time-search|near real-time]] search, immutable [[segments]], deletes that only mark tombstones, [[force-merge-refresh-interval|force merge]] — are all Lucene mechanics. Understanding the layer below explains *why* a refresh is needed before reads and *why* updates are expensive.

## How it works

A Lucene index is a set of **segments**: self-contained, immutable mini-indexes. Writes go to an in-memory buffer, then flush to a new segment.

- **[[inverted-index|Inverted index]]** — term → postings, the core lookup structure.
- **Immutable segments** — once written, never modified; new docs create new segments, which are periodically [[force-merge-refresh-interval|merged]].
- **Soft deletes** — a delete sets a bit in a `.liv` file; the doc is filtered out of results but reclaimed only on merge.
- **Specialized formats** — **doc values** (columnar, for [[sorting]]/[[metric-aggregations|aggregations]]), **stored fields** (the `_source`), term vectors (for [[highlighting]]).
- **Commit point** — fsync of segments for durability; Elasticsearch layers a translog on top for crash recovery between commits.

| Lucene concept | Elasticsearch surface |
|---|---|
| Index | A single shard |
| Segment | Immutable file set, merged over time |
| Refresh (open searcher) | Makes new docs searchable (~1s) |
| Doc values | Powers aggregations / sorting |

## Example

The lifecycle of one indexed document:

```
index doc ─▶ in-memory buffer + translog
   refresh (1s) ─▶ new segment, now searchable (not yet fsync'd)
   flush       ─▶ segments fsync'd, translog truncated (durable commit)
   merge       ─▶ small segments combined, deletes purged
```

This is why a freshly indexed doc is searchable in ~1s but only crash-safe after a flush.

## Pitfalls

- **Expecting in-place updates** — segments are immutable, so an "update" indexes a new doc and tombstones the old one; churny data fragments the index.
- **Too many small segments** — every search hits all of them; refreshing too often (or never merging) hurts query latency.
- **Forcing merges on hot indices** — [[force-merge-refresh-interval|force merge]] is heavy I/O; only run it on read-only/old indices.

## See also

- [[segments]]
- [[inverted-index]]
