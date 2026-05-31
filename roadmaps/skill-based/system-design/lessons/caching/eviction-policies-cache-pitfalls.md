---
title: Eviction policies & cache pitfalls
track: system-design
group: Caching
tags: [system-design, caching]
prerequisites: [caching-strategies-cache-aside-write-through-write-behind-refresh-ahead]
see-also: [where-to-cache-client-cdn-web-server-database-application, availability-patterns-failover-replication]
---

# Eviction policies & cache pitfalls

An eviction policy is the rule a cache uses to decide which entry to discard when memory fills — and the wrong choice, plus a few classic failure modes, can turn a cache into an outage.

## Why it matters

A cache is finite memory, so it is *always* evicting under load; the policy directly sets your hit rate, and hit rate is what protects the origin. Worse, caches change the system's failure modes: a cold or thundering cache can hammer the database far harder than no cache at all, so the pitfalls below are real [[availability-patterns-failover-replication|availability]] risks, not theory.

## How it works

Eviction policies trade recency against frequency:

| Policy | Evicts | Good when | Weakness |
|---|---|---|---|
| LRU | least-recently used | temporal locality | one big scan flushes hot keys |
| LFU | least-frequently used | stable hot set | new items starve; old ones linger |
| FIFO | oldest inserted | simple, fair-ish | ignores actual usage |
| TTL | whatever expired | freshness matters | mass expiry = sync stampede |
| Random | a random entry | cheap, surprisingly OK | no signal used |

- **LRU** is the common default (approximated, since true LRU needs bookkeeping on every access).
- **LFU** holds a stable hot set but needs aging so yesterday's spike doesn't pin a key forever.
- Real systems mix these — e.g. Redis offers `allkeys-lru`, `volatile-lru`, `allkeys-lfu`, and `noeviction` (reject writes when full).

The named cache failures every senior should recognize:

- **Stampede / dogpile** — a hot key expires and N concurrent misses all hit the DB at once. Fix: a per-key lock so one request rebuilds while others wait or serve stale.
- **Penetration** — requests for keys that *don't exist* skip the cache every time. Fix: cache the negative result (short TTL) or a Bloom filter.
- **Avalanche** — many keys share one expiry instant and all miss together. Fix: jitter the TTL (`base ± random`).

## Example

Stampede vs. its fix on a hot product key:

```
# without protection — key expires at t=0
1000 reqs/s × cache miss → 1000 DB reads/s spike → DB tips over

# with single-flight lock
req A: miss → acquire lock(product:42) → rebuild → SET, release
req B..N: miss → lock held → wait or serve stale value
result: 1 DB read instead of 1000
```

## Pitfalls

- **TTL with no jitter.** Bulk-loading 10k keys at startup with the same TTL guarantees a synchronized avalanche later — always add randomness.
- **Treating the cache as a database.** Code that assumes data is present will break on eviction or a cache outage; the store must remain the source of truth.
- **Unbounded cache.** No eviction policy plus no `maxmemory` leads to OOM and a hard crash, not graceful degradation.
- **Caching huge values.** A few oversized entries evict thousands of small hot keys and tank the hit rate.

## See also

- [[caching-strategies-cache-aside-write-through-write-behind-refresh-ahead]]
- [[where-to-cache-client-cdn-web-server-database-application]]
