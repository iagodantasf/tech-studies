---
title: Optimistic concurrency control (versioning)
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, concurrency]
prerequisites: [index-api, documents]
see-also: [get-update-delete-apis, bulk-api, update-by-query-delete-by-query]
---

# Optimistic concurrency control (versioning)

Elasticsearch has no row locks; it prevents lost updates *optimistically* — a write succeeds only if the document hasn't changed since you read it, detected via per-shard sequence numbers.

## Why it matters

Two clients doing read-modify-write on the same [[documents|document]] would otherwise clobber each other (last-writer-wins). OCC lets concurrent writers proceed lock-free and only the loser of a race fails, with a `409 conflict`, so it can re-read and retry. This underpins safe counters, inventory decrements, and any "compare-and-set" on a doc.

## How it works

Every doc carries two metadata values that change on each write:

| Field | Meaning |
|---|---|
| `_seq_no` | Monotonic write counter within the primary shard |
| `_primary_term` | Bumps when a shard's primary is re-elected (fencing stale primaries) |
| `_version` | Increments per write; informational / external-id use |

- **Compare-and-set** — read returns the [[shards-replicas|shard]]'s `_seq_no`/`_primary_term`; you echo them on write as `if_seq_no` + `if_primary_term`. Mismatch ⇒ someone wrote first ⇒ `409`.
- **`_version` alone is not the guard** — internal `_version` is for visibility; the *real* concurrency check is the seq_no/term pair (replaced the older `version`-based check).
- **External versioning** — `version_type=external` lets your own DB's monotonic version drive ES, so ES accepts only strictly-newer writes (great for [[reindex-api|sync]] from a source of truth).
- **Retries** — the [[get-update-delete-apis|Update API]]'s `retry_on_conflict=N` runs the read-modify-write loop server-side on conflict.

## Example

```
GET /inv/_doc/widget   → _seq_no:34, _primary_term:2, qty:10

PUT /inv/_doc/widget?if_seq_no=34&if_primary_term=2
{ "qty": 9 }
→ 200 if still at 34/2 ; 409 if another writer moved it to 35
```

On `409`, re-`GET`, recompute, retry — the standard CAS loop.

## Pitfalls

- **Omitting the guard** — a plain `PUT` with no `if_seq_no` is unconditional last-writer-wins; concurrent updates silently lose data.
- **Tight CAS on a hot doc** — many writers on one id thrash with conflicts; prefer per-event append docs + aggregate at read, not one mutable counter.
- **External version footgun** — with `version_type=external`, sending an equal-or-lower version is rejected; out-of-order replays get dropped, which is correct but surprising.
- **Bulk hides conflicts** — a [[bulk-api|bulk]] item failing its version check returns `409` in that item's `status`, not the HTTP code; you must read per-item results.

## See also

- [[get-update-delete-apis]]
- [[bulk-api]]
