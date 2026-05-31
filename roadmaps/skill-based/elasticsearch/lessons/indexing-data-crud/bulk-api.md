---
title: Bulk API
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, bulk-indexing]
prerequisites: [index-api]
see-also: [bulk-indexing-tuning, get-update-delete-apis, reindex-api]
---

# Bulk API

The Bulk API batches many index/create/update/delete operations into one HTTP request using a newline-delimited (NDJSON) body, amortizing per-request overhead.

## Why it matters

Single-document writes pay a full round-trip and coordination cost each; bulk collapses thousands into one request and is the only sane way to ingest at scale. Throughput can jump 10–100×. But bulk is *partial-success* and *unordered across docs*, so robust ingestion lives or dies on parsing per-item results and retrying correctly.

## How it works

The body is paired lines — an action line, then (for index/create/update) a source line:

```
POST /_bulk
{ "index": { "_index": "logs", "_id": "1" } }
{ "msg": "boot", "level": "info" }
{ "delete": { "_index": "logs", "_id": "9" } }
{ "update": { "_index": "logs", "_id": "2" } }
{ "doc": { "level": "warn" } }
```

| Action | Source line? | Semantics |
|---|---|---|
| `index` | yes | create or overwrite |
| `create` | yes | fail with 409 if id exists |
| `update` | yes (`doc`/`script`) | partial merge |
| `delete` | no | tombstone by id |

- **Partial success** — HTTP is `200` even if some items fail; the top-level `errors:true` flag and each item's `status` tell you which. Never assume all-or-nothing.
- **No cross-item atomicity** — items succeed/fail independently and in no guaranteed order.
- **Right-size batches** — tune by payload, not count: aim for **5–15 MB** per request; too large stresses heap and the coordinating node.

## Example

A 50k-doc load split into ~5 MB chunks. Pseudo-flow:

```
for chunk in chunks(docs, ~5MB):
  resp = POST /_bulk  chunk
  if resp.errors:
    retry only items where status==429 (backoff) or 503
    log/quarantine items with 400 (mapping errors) — retrying won't help
```

## Pitfalls

- **Ignoring `errors`** — a `200` with `errors:true` and unread items means silent data loss; always inspect `items[].status`.
- **Blind full-batch retry** — re-sending already-succeeded `index` ops is fine (idempotent by id) but re-sends `create` as 409s and duplicates auto-id docs. Retry per-item.
- **`429 TOO_MANY_REQUESTS`** = write queue full; back off, don't hammer. See [[bulk-indexing-tuning]].
- **Newlines matter** — every line, including the last, must end in `\n`; a missing trailing newline corrupts parsing.

## See also

- [[bulk-indexing-tuning]]
- [[reindex-api]]
