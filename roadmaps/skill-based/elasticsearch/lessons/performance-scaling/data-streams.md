---
title: Data streams
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, data-streams]
prerequisites: [index-templates]
see-also: [index-lifecycle-management-ilm, hot-warm-cold-architecture, sharding-strategy]
---

# Data streams

A data stream is a write-append abstraction over a sequence of hidden, auto-rolled backing indices — one logical name for append-only time-series data like logs, metrics, and traces.

## Why it matters

Time-series data is immutable once written and grows forever, so it must be split across many indices for [[sharding-strategy|shard sizing]] and tiered storage. Managing that rollover by hand (date-named indices + write aliases) is error-prone. A data stream packages the alias, rollover, and [[index-lifecycle-management-ilm|ILM]] integration into one object you write to by a single name.

## How it works

A data stream `logs-app-prod` is fronted by backing indices named `.ds-logs-app-prod-<date>-NNNNNN`:

```
POST logs-app-prod/_doc      # writes always go to the current write index
GET  logs-app-prod/_search   # reads fan out across ALL backing indices
POST logs-app-prod/_rollover # new write index; old one becomes read-only
```

- **Requires an index template** with a `data_stream: {}` block and a matching pattern; creating it is what enables the stream.
- **Append-only by design** — direct `index`/`update`/`delete` by id is rejected on the stream; corrections go through [[update-by-query-delete-by-query|update_by_query]] against the backing index.
- **Mandatory `@timestamp`** — every doc needs a `date`/`date_nanos` field named `@timestamp`; it defines time ordering and ILM phase transitions.
- **Rollover triggers** — ILM rolls the write index on size/age/doc-count (e.g. `max_primary_shard_size: 50gb` or `max_age: 1d`), keeping each backing index well-sized.

| Concern | Old: alias + indices | Data stream |
|---|---|---|
| Write target | Manage `is_write_index` | Implicit current write index |
| Rollover | Manual or scripted | ILM-driven, built in |
| Updates by id | Allowed | Rejected (append-only) |

## Example

Template `logs` matches `logs-*` with `data_stream:{}` and ILM `logs-ilm` (rollover at 50 GB or 1 day; delete at 30 days). First write to `logs-app-prod` auto-creates the stream and `.ds-logs-app-prod-2026.05.30-000001`. At 50 GB it rolls to `-000002`; 30 days later the oldest backing index is dropped — all without renaming a single write target.

## Pitfalls

- **Trying to update a doc by id** — fails on a data stream; if you need mutable docs, use a normal index, not a stream.
- **Mismatched `@timestamp`** — missing or non-date field breaks ingestion and ILM age calculations.
- **Reindexing into a stream** — must target the stream with `op_type: create`; a plain reindex to a backing index bypasses rollover.
- **Deleting backing indices directly** — breaks the stream's bookkeeping; delete the whole stream or let ILM expire it.

## See also

- [[index-templates]]
- [[index-lifecycle-management-ilm]]
