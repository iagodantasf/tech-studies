---
title: Content Delivery Network (CDN) — push vs pull
track: system-design
group: Networking & delivery
tags: [system-design, cdn]
prerequisites: [domain-name-system-dns]
see-also: [where-to-cache-client-cdn-web-server-database-application, caching-strategies-cache-aside-write-through-write-behind-refresh-ahead]
---

# Content Delivery Network (CDN) — push vs pull

A CDN is a globally distributed cache of edge servers that serves content from a location near the user, cutting latency and offloading your origin.

## Why it matters

Physics sets a floor: a round trip from Sydney to Virginia is ~200ms no matter how fast your servers are. A CDN ends that round trip at a nearby **edge** (a **PoP**, point of presence), so static assets, video, and increasingly API responses load in tens of milliseconds. It also absorbs traffic spikes and DDoS, shielding the origin so you provision for *cache-miss* load, not peak load.

## How it works

DNS resolves your CDN hostname to the nearest edge (see [[domain-name-system-dns]]). The edge either has the object cached (**hit**) or fetches it from origin (**miss**) and stores it. Two models govern how content gets there:

| | Pull (origin-pull) | Push |
|---|---|---|
| Trigger | first user request (lazy) | you upload ahead of time |
| Freshness | TTL / cache headers | you control, must re-push on change |
| Origin load | first-miss per edge | one upload, ~zero read load |
| Best for | large, changing catalogs | small set of big, stable files |

**Pull** is the default for most sites: set `Cache-Control`/`Expires`, point the CDN at your origin, and let it populate on demand — the first user in each region eats the miss. **Push** suits a video release or a few huge installers where you don't want N edges hammering origin and you want it warm before launch. **Cache-busting** via versioned URLs (`app.4f3a.js`) lets you set long TTLs yet still ship new content instantly — a name change is a new object. This is the **CDN** tier of [[where-to-cache-client-cdn-web-server-database-application]].

## Example

```
GET https://cdn.shop.com/img/hero.4f3a.jpg
edge (Frankfurt): MISS → origin → store (Cache-Control: max-age=31536000)
                  return to user (~30ms)
next EU users:    HIT, served from Frankfurt, origin untouched
```

Deploy a new hero: write `hero.9b1c.jpg`, change the `<img>` src — old TTL irrelevant.

## Pitfalls

- **Caching dynamic/per-user responses.** Serving one user's account page to another is a classic CDN bug — mark private/no-store and vary on auth.
- **No invalidation plan.** With long TTLs and no versioning, a bad asset is stuck at the edge; purges are slow and rate-limited.
- **Forgetting `Vary`.** Caching a gzip body and serving it to a client that didn't send `Accept-Encoding: gzip` breaks the page.
- **Origin still a SPOF.** A CDN reduces but never eliminates origin hits (misses, revalidation); keep the origin highly available.

## See also

- [[where-to-cache-client-cdn-web-server-database-application]]
- [[domain-name-system-dns]]
