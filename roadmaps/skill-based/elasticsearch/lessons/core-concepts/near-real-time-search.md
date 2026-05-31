---
title: Near real-time search
track: elasticsearch
group: Core Concepts
tags: [elasticsearch, refresh]
prerequisites: [segments]
see-also: [force-merge-refresh-interval, optimistic-concurrency-control-versioning, bulk-indexing-tuning]
---

# Near real-time search

Near real-time (NRT) means an indexed [[documents|document]] becomes searchable a short, bounded time after it is written — by default about one second — rather than instantly.

## Why it matters

This is the trade that makes Elasticsearch fast: by buffering writes and only periodically exposing them, the engine avoids per-document index commits and amortizes work into [[segments|segment]] creation. The catch is no read-after-write guarantee — a doc you just `PUT` may not appear in the next search. Knowing the refresh model prevents a whole class of "my data isn't there… oh, it just showed up" bugs.

## How it works

A document is *durable* immediately but *visible* only after a refresh.

- **Indexed** — doc is written to the in-memory buffer and the translog (durable on disk).
- **Refresh** — every [[force-merge-refresh-interval|`refresh_interval`]] (default `1s`), the buffer is turned into a new searchable segment; only now can a query find the doc.
- **Force visibility** — `?refresh=true` (do the refresh now) or `?refresh=wait_for` (block until the next scheduled one) make a single write searchable on return.

| Mechanism | Latency | Cost |
|---|---|---|
| Default (`1s`) | ≤ ~1s to visible | Cheap; batches writes |
| `?refresh=wait_for` | Until next refresh | No extra segment; request blocks |
| `?refresh=true` | Immediate | Forces a segment now — expensive at volume |

## Example

```
PUT /orders/_doc/1 { "total": 50 }
GET /orders/_search { "query": { "match_all": {} } }   # may return 0 hits!

PUT /orders/_doc/2?refresh=wait_for { "total": 75 }     # returns after refresh
GET /orders/_search → now sees doc 2 (and doc 1)
```

A `GET /orders/_doc/1` by ID *does* return immediately — direct ID gets read the translog, so they aren't subject to refresh delay; only *search* is.

## Pitfalls

- **`?refresh=true` in a hot write path** — forcing a refresh per request creates tiny segments and tanks throughput; prefer `wait_for` or just tolerate ~1s.
- **Tests asserting immediately after index** — flakey unless you refresh; in tests use `?refresh=true`, never in bulk production loads.
- **Confusing durability with visibility** — a crash won't lose an un-refreshed doc (translog covers it), but a search still won't see it until refresh; the two guarantees are separate.

## See also

- [[segments]]
- [[force-merge-refresh-interval]]
