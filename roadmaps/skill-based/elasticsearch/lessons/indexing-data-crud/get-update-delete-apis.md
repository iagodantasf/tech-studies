---
title: Get / Update / Delete APIs
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, crud]
prerequisites: [index-api]
see-also: [optimistic-concurrency-control-versioning, update-by-query-delete-by-query, bulk-api]
---

# Get / Update / Delete APIs

The single-document read and mutate APIs: fetch by `_id`, partially modify a doc in place, or tombstone it — all addressed by primary key, not by query.

## Why it matters

These are the OLTP-style operations on top of a search engine. `GET` is the only truly real-time read in Elasticsearch (it bypasses [[near-real-time-search|refresh]]); `Update` spares you a read-modify-write round-trip; `Delete` is a logical tombstone, not an immediate disk reclaim. Knowing what each actually does on [[segments|segments]] prevents surprises about latency, disk usage, and lost updates.

## How it works

| API | Call | Notes |
|---|---|---|
| Get | `GET /idx/_doc/{id}` | real-time; reads translog if not yet refreshed |
| Update | `POST /idx/_update/{id}` | partial merge, script, or upsert |
| Delete | `DELETE /idx/_doc/{id}` | marks doc deleted in its segment |

- **Update is not in-place** — it `GET`s the [[documents|`_source`]], applies a partial doc or [[painless-scripting|Painless]] script, then re-indexes the *whole* document. So `_source` must be enabled.
- **Upsert** — `doc_as_upsert:true` or an `upsert` block inserts when the id is absent, updates when present.
- **`retry_on_conflict=N`** auto-retries the read-modify-write loop on [[optimistic-concurrency-control-versioning|version]] conflicts — essential for hot counters.
- **Delete reclaims nothing immediately** — space returns only when [[force-merge-refresh-interval|segment merges]] purge tombstones.

## Example

```
POST /products/_update/SKU-22
{ "doc": { "price": 5.0 }, "doc_as_upsert": true }

POST /counters/_update/page-7?retry_on_conflict=5
{ "script": { "source": "ctx._source.views += params.n",
              "params": { "n": 1 } } }
```

The script path avoids fetching `views` to the client, but ES still re-indexes the full doc under the hood.

## Pitfalls

- **Frequent updates = segment churn** — every update writes a new doc + a tombstone; high-churn fields belong in a counter store or are batched, not updated per event.
- **Stale `GET` after delete** — `GET` is real-time, but a `_search` may still return the doc until the next [[near-real-time-search|refresh]].
- **Update needs `_source`** — disabling `_source` to save disk silently breaks Update, [[reindex-api|Reindex]], and [[update-by-query-delete-by-query|update_by_query]].

## See also

- [[index-api]]
- [[optimistic-concurrency-control-versioning]]
