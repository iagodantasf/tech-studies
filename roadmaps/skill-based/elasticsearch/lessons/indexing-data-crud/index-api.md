---
title: Index API
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, indexing]
prerequisites: [documents, indices]
see-also: [get-update-delete-apis, bulk-api, optimistic-concurrency-control-versioning]
---

# Index API

The Index API writes a single JSON [[documents|document]] into an [[indices|index]], creating it or fully replacing an existing one with the same `_id`.

## Why it matters

"Indexing" is the write path: it parses the doc against the [[mappings|mapping]], runs [[analyzers-standard-language-custom|analysis]] to build [[inverted-index|inverted-index]] postings, and appends to a [[segments|segment]]. Understanding its three knobs — id assignment, create-vs-overwrite, and routing — is the difference between idempotent ingestion and silently clobbering data or scattering a tenant across every shard.

## How it works

Two HTTP verbs map to two intents:

| Call | id source | If id exists | Use when |
|---|---|---|---|
| `POST /idx/_doc` | ES auto-generates | n/a (always new) | append-only logs/events |
| `PUT /idx/_doc/{id}` | you supply | overwrites (full re-index) | upsert by natural key |
| `PUT /idx/_create/{id}` | you supply | 409 conflict | insert-once semantics |

- **No partial writes** — a `PUT` with an `_id` replaces the whole `_source`; missing fields are dropped, not kept. Merging is the [[get-update-delete-apis|Update API]]'s job.
- **Routing** — `_id` hashes to `shard = hash(routing) % number_of_primaries`; pass `?routing=acme` to colocate a tenant on one [[shards-replicas|shard]].
- **Durability** — the write hits the in-memory buffer + translog; it is searchable only after the next refresh ([[near-real-time-search|NRT]], default 1s), and crash-safe once `fsync`'d (default per request, `index.translog.durability`).

## Example

```
POST /events/_doc                 → auto id, 201 Created
{ "user": "u-7", "action": "login" }

PUT  /products/_doc/SKU-22?routing=acme
{ "name": "bolt", "price": 4.5 }  → _version:1, then 2, 3… on re-PUT
```

Re-`PUT`ting `SKU-22` returns `result:"updated"` and bumps `_version`; the old doc is tombstoned in its segment, reclaimed at [[force-merge-refresh-interval|merge]].

## Pitfalls

- **Auto-id forces `create`** internally — fine, but you lose idempotency: a retried `POST` makes a duplicate. Use `PUT {id}` for retry-safe pipelines.
- **First write auto-creates the index** with dynamic mapping unless `action.auto_create_index` is restricted — a typo'd index name births a junk index.
- **Single-doc indexing at volume is slow** — one network round-trip + refresh pressure per doc; batch with the [[bulk-api|Bulk API]] instead.

## See also

- [[bulk-api]]
- [[get-update-delete-apis]]
