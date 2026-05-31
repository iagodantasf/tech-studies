---
title: Update by query / Delete by query
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, bulk-mutation]
prerequisites: [get-update-delete-apis, query-dsl-overview]
see-also: [reindex-api, optimistic-concurrency-control-versioning, painless-scripting]
---

# Update by query / Delete by query

These APIs apply an update script or a delete to every [[documents|document]] matching a query, instead of addressing each by `_id` — bulk mutation driven by a [[query-dsl-overview|Query DSL]] filter.

## Why it matters

When you need "set `status=archived` where `last_seen < 2024`" or "delete all docs for tenant X", iterating ids client-side is hopeless. These APIs run server-side over [[pagination-from-size-search-after-scroll|scroll]] + [[bulk-api|bulk]], touching millions of docs in one call. The cost is that they are *not* atomic and run against a moving target.

## How it works

```
POST /logs/_update_by_query?conflicts=proceed
{ "query": { "range": { "ts": { "lt": "2024-01-01" } } },
  "script": { "source": "ctx._source.archived = true" } }

POST /logs/_delete_by_query
{ "query": { "term": { "tenant": "x" } } }
```

- **Snapshot semantics** — it grabs a scroll snapshot at start; each matched doc is re-checked by [[optimistic-concurrency-control-versioning|`_seq_no`]] at write time, so a doc changed meanwhile triggers a version conflict.
- **`conflicts=proceed`** logs and skips conflicts instead of aborting the whole job — usually what you want.
- **Async + throttle** — `wait_for_completion=false` returns a task; `requests_per_second` and `slices=auto` (parallel sub-tasks per shard) tune load vs. speed.
- **Delete is still a tombstone** — disk frees only at [[force-merge-refresh-interval|merge]]; deleting "everything" does not shrink the index instantly.

## Example

Throttled re-tag of a live index without a downstream stampede:

```
POST /products/_update_by_query?slices=auto&requests_per_second=2000
{ "query": { "term": { "discontinued": true } },
  "script": "ctx._source.visible = false" }
→ { "task": "node:12345" }   # poll GET /_tasks/node:12345
```

## Pitfalls

- **No isolation** — concurrent writes can be over- or under-counted; for exact, ordered rewrites of a whole index, [[reindex-api|Reindex]] into a new index instead.
- **Deleting a whole tenant ≠ reclaiming space** — millions of tombstones bloat the index until merged; dropping a per-tenant/time [[indices|index]] outright is far cheaper.
- **Long jobs and conflicts** — without `conflicts=proceed`, one stale doc aborts the run after partial application, leaving the index half-mutated and not rolled back.
- **Heavy scripts scale linearly** — a slow [[painless-scripting|Painless]] script × 50M docs is a multi-hour job; test on a slice first.

## See also

- [[reindex-api]]
- [[get-update-delete-apis]]
