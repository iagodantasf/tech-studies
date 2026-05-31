---
title: Where to cache (client, CDN, web server, database, application)
track: system-design
group: Caching
tags: [system-design, caching]
prerequisites: [latency-vs-throughput]
see-also: [caching-strategies-cache-aside-write-through-write-behind-refresh-ahead, content-delivery-network-cdn-push-vs-pull]
---

# Where to cache (client, CDN, web server, database, application)

A cache is any layer that serves a saved copy so work isn't repeated — and you can place one at every hop from the user's device down to the database.

## Why it matters

Each layer you add shortens the path: the closer the cache sits to the client, the lower the [[latency-vs-throughput|latency]] and the more origin load it absorbs. A request answered by the browser or [[content-delivery-network-cdn-push-vs-pull|CDN]] never touches your servers, so caching is the cheapest scalability lever you own — but every copy is a chance to serve something stale, so placement is a deliberate trade-off, not a free win.

## How it works

Think of caches as a layered hierarchy; a hit at any tier stops the request from going deeper:

| Layer | Stores | Scope | TTL feel | Invalidation |
|---|---|---|---|---|
| Client | full responses, assets | one user | mins–days | hard (can't reach it) |
| CDN | static + cacheable HTML | per-PoP | mins–hours | purge API |
| Web server | rendered pages, fragments | one node | secs–mins | local, easy |
| Application | objects, query results | shared (Redis) | secs–mins | you control it |
| Database | buffer pool, query cache | one DB | engine-managed | automatic |

- **Client / HTTP caching** is driven by `Cache-Control`, `ETag`, and `Last-Modified`; the browser revalidates with a conditional `GET` and gets a cheap `304`.
- **Application cache** (e.g. Redis/Memcached) is the workhorse — a shared key→value store you populate via [[caching-strategies-cache-aside-write-through-write-behind-refresh-ahead|cache-aside]].
- **Database cache** is the buffer pool keeping hot pages in RAM; you tune it, you don't query it directly.

## Example

A product page request, hot path first:

```
browser cache?  hit → 0 network    (Cache-Control: max-age=300)
CDN PoP?        hit → ~10 ms edge   (static assets, cached HTML)
web/app cache?  hit → ~1 ms Redis   (product JSON, key=product:42)
miss everywhere → DB read ~20 ms → backfill Redis + return
```

One DB read can now serve thousands of users for the next 5 minutes.

## Pitfalls

- **Caching user-specific data at a shared layer.** A CDN or proxy caching a logged-in page can leak one user's data to another — gate with `Cache-Control: private`.
- **No `Vary` header.** Caching one variant (gzip, language) and serving it to clients that needed another.
- **Stacking TTLs blindly.** A 1h browser TTL on top of a 1h CDN TTL means a fix can take ~2h to reach everyone.
- **Caching errors.** A cached `500` or `404` outlives the bug that caused it; never cache failures with a long TTL.

## See also

- [[caching-strategies-cache-aside-write-through-write-behind-refresh-ahead]]
- [[content-delivery-network-cdn-push-vs-pull]]
