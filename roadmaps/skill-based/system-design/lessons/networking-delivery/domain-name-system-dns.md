---
title: Domain Name System (DNS)
track: system-design
group: Networking & delivery
tags: [system-design, dns]
prerequisites: []
see-also: [content-delivery-network-cdn-push-vs-pull, load-balancers-l4-vs-l7-algorithms-active-passive-active-active]
---

# Domain Name System (DNS)

DNS is the distributed, hierarchical directory that translates human names like `api.example.com` into the IP addresses machines route to.

## Why it matters

Every request a browser or service makes starts with a name, not an address, so DNS sits on the critical path of essentially all traffic. It is also a quiet but powerful traffic-steering lever: by handing out different answers you do **geo-routing**, **failover**, and crude **load distribution** before a packet ever reaches your servers — for free, at the edge.

## How it works

Resolution walks a hierarchy, usually via a **recursive resolver** (your ISP's or `8.8.8.8`) that does the legwork and caches results:

- **Root** servers → point to the TLD servers for `.com`.
- **TLD** servers → point to the **authoritative** nameserver for `example.com`.
- **Authoritative** server → returns the final record.

Common record types:

| Type | Maps to | Typical use |
|---|---|---|
| A / AAAA | IPv4 / IPv6 address | host → IP |
| CNAME | another name | alias one host to another |
| NS | nameserver | delegate a zone |
| MX | mail server | email routing |

Every record carries a **TTL** (seconds) that controls how long resolvers cache it. Low TTL = fast failover but more lookups; high TTL = fewer lookups but stale answers linger. Returning multiple A records (**round-robin DNS**) spreads clients across IPs, and managed DNS can do **latency-** or **geo-based** answers, often pointing at a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active]] or [[content-delivery-network-cdn-push-vs-pull]] edge.

## Example

Cold lookup of `shop.example.com` (nothing cached):

```
client → resolver: shop.example.com A?
resolver → root:   .com NS?            → a.gtld-servers.net
resolver → TLD:    example.com NS?     → ns1.example.com
resolver → auth:   shop.example.com A? → 93.184.216.34  (TTL 300)
resolver → client: 93.184.216.34   [cached 5 min]
```

The next client in those 5 minutes gets the answer from cache in ~1ms.

## Pitfalls

- **DNS is not a load balancer.** Round-robin ignores server health and load; a dead IP keeps being handed out until its TTL expires. Pair it with health-checked [[availability-patterns-failover-replication]].
- **TTL set too high before a migration.** You cut over the IP and old clients keep hitting the dead host for hours. Lower TTL *days* in advance.
- **Negative caching.** A typo or missing record (NXDOMAIN) is cached too; the fix may not appear instantly.
- **Clients ignore TTL.** Browsers and JVMs pin DNS for their own intervals, so failover is never as crisp as the TTL implies.

## See also

- [[content-delivery-network-cdn-push-vs-pull]]
- [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active]]
