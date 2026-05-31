---
title: Pagination (from/size, search_after, scroll)
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, pagination]
prerequisites: [sorting, shards-replicas]
see-also: [sorting, query-dsl-overview, bulk-indexing-tuning]
---

# Pagination (from/size, search_after, scroll)

Elasticsearch offers three ways to page through results — shallow `from`/`size`, cursor-based `search_after`, and the legacy `scroll` — each with very different cost and consistency trade-offs.

## Why it matters

The naive "page N" pattern (`from`/`size`) silently degrades: fetching page 1000 forces every [[shards-replicas|shard]] to build and sort a list of `from+size` hits, exhausting memory. Deep pagination, exports, and reindex jobs each need the right tool, or you hit the 10,000-result wall or OOM a coordinating node.

## How it works

| Method | Best depth | State | Consistent snapshot? |
|---|---|---|---|
| `from`/`size` | shallow (< 10k) | none | no |
| `search_after` | unlimited, sequential | none (cursor in request) | with a PIT |
| `scroll` | bulk export | server-side context | yes (frozen) |

- **`from`/`size`** — each shard returns `from+size` sorted hits to the coordinator, which re-sorts and discards `from`; bounded by `index.max_result_window` (default 10,000).
- **`search_after`** — pass the last hit's [[sorting|sort]] values as the cursor; requires a deterministic, unique tiebreaker sort (e.g. `_shard_doc` or `_id`). Pair with a **Point In Time** (PIT) for a stable view.
- **`scroll`** — opens a snapshot consuming heap/file handles for `scroll=1m`; superseded by `search_after`+PIT for most jobs, but still used by some clients.

## Example

```
// page 1
{ "size": 20, "sort": [ {"date":"desc"}, {"_shard_doc":"asc"} ] }
// next page: feed the last hit's sort array
{ "size": 20, "search_after": [1717000000000, 42],
  "sort": [ {"date":"desc"}, {"_shard_doc":"asc"} ] }
```

`search_after` re-queries from the cursor — O(size) per page regardless of depth, versus `from:10000` which sorts 10,020 hits per shard.

## Pitfalls

- **Deep `from`** — `from:50000` multiplies memory across shards and trips `max_result_window`; never expose unbounded page numbers.
- **`search_after` without a unique tiebreaker** — ties at the cursor boundary skip or duplicate rows; always append `_shard_doc`/`_id`.
- **No PIT** — between pages, refreshes can shift results; open a PIT for export consistency.
- **Leaked scrolls/PITs** — un-cleared contexts pin [[segments|segments]] and leak heap; always `DELETE` them (`keep_alive` only bounds the leak).

## See also

- [[sorting]]
- [[query-dsl-overview]]
