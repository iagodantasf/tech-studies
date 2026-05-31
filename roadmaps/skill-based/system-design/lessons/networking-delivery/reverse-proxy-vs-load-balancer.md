---
title: Reverse proxy (vs load balancer)
track: system-design
group: Networking & delivery
tags: [system-design, reverse-proxy]
prerequisites: [load-balancers-l4-vs-l7-algorithms-active-passive-active-active]
see-also: [api-gateway-routing-aggregation-offloading, content-delivery-network-cdn-push-vs-pull]
---

# Reverse proxy (vs load balancer)

A reverse proxy is a server that sits in front of your backends, accepting client requests on their behalf and forwarding them — a single front door that can also cache, terminate TLS, and hide topology.

## Why it matters

It gives you one place to do cross-cutting work that you'd otherwise duplicate in every service: TLS termination, compression, caching, request buffering, rate limiting, and a stable public endpoint while backends churn behind it. It also improves security and operability — clients never see internal hostnames, ports, or how many instances exist. Nginx, Envoy, HAProxy, and Caddy are the usual tools.

## How it works

A **forward** proxy fronts *clients* (an outbound corporate proxy); a **reverse** proxy fronts *servers*. Where a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]]'s job is *distributing across many backends*, a reverse proxy's job is *being the front door* — and the two overlap heavily because most L7 load balancers are reverse proxies, and most reverse proxies can balance load. Think of it by intent, not product:

| Capability | Reverse proxy | Load balancer |
|---|---|---|
| Single entry point | core purpose | side effect |
| Spread across backends | optional | core purpose |
| Caching / compression | common | rare |
| TLS termination | yes | L7 yes |

A useful framing: **load balancing is one feature a reverse proxy may offer.** You'd still want a reverse proxy in front of a *single* backend — for TLS, caching, and buffering — where a load balancer alone makes no sense. Layer more behavior on top and it becomes an [[api-gateway-routing-aggregation-offloading|API gateway]]; pin a cache to it and it overlaps a [[content-delivery-network-cdn-push-vs-pull|CDN]] edge.

## Example

Nginx as a reverse proxy in front of one app server:

```
client ──TLS──▶ nginx :443
                 ├─ terminate TLS, gzip response
                 ├─ serve /static/* from local cache (HIT)
                 └─ proxy_pass /api/* ──HTTP──▶ app:8080
```

Internal `app:8080` is never exposed; swap or scale it without clients noticing.

## Pitfalls

- **Forgetting `X-Forwarded-For`/`-Proto`.** The backend sees the proxy's IP and thinks every request is plaintext; pass and trust these headers correctly.
- **Buffering large uploads/streams.** Default request buffering can stall big uploads or SSE; tune or disable per route.
- **Treating it as the LB's redundancy story.** A lone reverse proxy is still a SPOF — it needs its own active-passive/active-active setup.
- **Mismatched timeouts.** Proxy and backend timeouts that disagree produce confusing 502/504s under load.

## See also

- [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active]]
- [[api-gateway-routing-aggregation-offloading]]
