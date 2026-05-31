---
title: Caching strategies — cache-aside, write-through, write-behind, refresh-ahead
track: system-design
group: Caching
tags: [system-design, caching]
prerequisites: [where-to-cache-client-cdn-web-server-database-application]
see-also: [eviction-policies-cache-pitfalls, consistency-patterns-weak-eventual-strong]
---

# Caching strategies — cache-aside, write-through, write-behind, refresh-ahead

A caching strategy is the protocol that decides who reads and writes the cache versus the store, and it sets your staleness and durability guarantees.

## Why it matters

The strategy is what determines whether a crash loses writes, whether readers ever see stale data, and where the latency lands. Picking one is a [[consistency-patterns-weak-eventual-strong|consistency]] decision in disguise — "fast but eventually consistent" versus "durable but slower" — so it belongs in the design, not left to a library default.

## How it works

The four canonical patterns, split by who owns the read/write path:

| Strategy | Read | Write | Best for |
|---|---|---|---|
| Cache-aside | app checks cache, on miss loads DB + populates | app writes DB, invalidates cache | general, read-heavy |
| Write-through | from cache (always warm) | app writes cache → cache writes DB synchronously | read-after-write correctness |
| Write-behind | from cache | write cache now, flush to DB async | write-heavy, bursty |
| Refresh-ahead | from cache | (any) | predictable hot keys |

- **Cache-aside** (lazy loading): the default. Only requested data is cached, and the cache can outlive a DB schema change. Cost: every miss is 3 hops, and a naive "update DB then delete key" has a classic race.
- **Write-through** keeps the cache and DB in lockstep, so reads are always fresh — at the price of write latency and caching data that may never be read.
- **Write-behind** acks the write from cache and flushes later in batches; great throughput, but a crash before flush loses data.
- **Refresh-ahead** proactively reloads a key *before* its TTL expires, hiding miss latency for predictably hot data — if your prediction is wrong, you refresh garbage.

## Example

Cache-aside read on a miss, then the write that invalidates:

```
GET user:42
  cache miss → SELECT * FROM users WHERE id=42
  SET user:42 = {...}, EX 300        # backfill, 5-min TTL
  return row

POST /user/42  (update email)
  UPDATE users SET email=... WHERE id=42
  DEL user:42                        # invalidate, not overwrite
```

Deleting (not rewriting) avoids caching a value from a write that later rolls back.

## Pitfalls

- **Update DB then update cache.** Two concurrent writers can interleave and leave the cache holding the older value — prefer **delete-on-write** so the next read repopulates.
- **Write-behind without durability.** An unflushed buffer means a node crash silently drops acknowledged writes; use it only where some loss is acceptable.
- **No TTL with cache-aside.** Invalidation bugs become permanent stale reads; a TTL is your safety net even when you also delete keys.
- **Refresh-ahead on cold keys.** Refreshing rarely-read data wastes the store and the DB; reserve it for measured hot keys.

## See also

- [[eviction-policies-cache-pitfalls]]
- [[where-to-cache-client-cdn-web-server-database-application]]
