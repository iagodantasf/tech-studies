---
title: Documents
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, documents]
prerequisites: []
see-also: [indices, mappings, index-api]
---

# Documents

A document is the unit of indexing and retrieval in Elasticsearch: a single JSON object stored in an [[indices|index]], identified by an `_id` and wrapped in system metadata.

## Why it matters

The document is what you `PUT`, `GET`, score, and return — the equivalent of a "row", but self-describing and nested rather than flat. Getting the document boundary right (one product? one log line? one order with its line items?) decides your [[mappings|mapping]], your query shape, and whether you can update a field without reindexing the world. Pick the wrong grain and you fight the engine forever.

## How it works

Your fields live under `_source`; Elasticsearch adds metadata fields around them.

| Field | Meaning |
|---|---|
| `_index` | Index the doc belongs to |
| `_id` | Unique ID within the index (you supply it or ES generates one) |
| `_source` | The original JSON you sent, stored verbatim |
| `_version` | Increments on every write; drives concurrency control |
| `_seq_no` / `_primary_term` | Per-shard sequence used for concurrency and recovery |

- **Immutable on disk** — an "update" reads `_source`, applies the change, and re-indexes a new document; the old one is marked deleted in its [[segments|segment]].
- **`_source` is the truth** — disable it and you lose update-by-query, reindex, and highlighting on stored values. Almost always keep it on.
- **Routing** — `_id` (or a custom `routing` value) hashes to a [[shards-replicas|shard]], so the same key always lands on the same shard.
- **Concurrency** — `_seq_no` + `_primary_term` back [[optimistic-concurrency-control-versioning|optimistic concurrency control]], letting a conditional write reject a stale update.

## Example

```
PUT /orders/_doc/A-1001
{ "customer": "acme", "total": 249.0,
  "items": [ { "sku": "M-22", "qty": 2 } ] }

GET /orders/_doc/A-1001
→ { "_id":"A-1001", "_version":1, "_source": { ... } }
```

The whole nested object is one document — items are not separate rows unless mapped as [[object-nested-fields|nested]].

## Pitfalls

- **Giant documents** — a 10 MB doc with huge arrays bloats `_source` and slows fetch; cap array sizes and split where sensible.
- **Object arrays flatten** — `[{a:1,b:2},{a:3,b:4}]` cross-matches `a=1 AND b=4` unless declared `nested`.
- **Reusing an `_id`** silently overwrites the prior doc (a full re-index, not a merge) — use `op_type=create` to fail instead.

## See also

- [[indices]]
- [[get-update-delete-apis]]
