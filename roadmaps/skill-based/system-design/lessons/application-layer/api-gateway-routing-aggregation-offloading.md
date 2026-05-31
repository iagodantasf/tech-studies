---
title: API gateway (routing, aggregation, offloading)
track: system-design
group: Application layer
tags: [system-design, api-gateway]
prerequisites: [application-layer-microservices]
see-also: [reverse-proxy-vs-load-balancer, service-discovery]
---

# API gateway (routing, aggregation, offloading)

An API gateway is a single entry point in front of a set of services that routes requests, composes responses, and handles cross-cutting concerns so the services don't have to.

## Why it matters

Without a gateway, every client must know each service's address, re-implement auth and rate limiting, and make many round-trips to assemble one screen. A gateway gives clients one stable endpoint, centralizes [[security-basics-authn-authz-encryption-rate-limiting|auth, TLS, and rate limiting]], and shrinks chatty mobile calls into one. It also decouples the public API from internal service topology, so you can split or rename services behind it without breaking clients.

## How it works

The gateway is a specialized [[reverse-proxy-vs-load-balancer|reverse proxy]] with three core jobs:

| Capability | What it does |
|---|---|
| Routing | Maps an external path to an internal service, often via [[service-discovery]] |
| Aggregation | Fans out to several services and composes one response |
| Offloading | Pulls cross-cutting work (auth, TLS, caching) out of services |

**Routing** matches on path, host, or headers and forwards (e.g. `/orders/*` → order service). **Aggregation** turns N client round-trips into one: the gateway calls several services in parallel and merges the result, ideal for mobile over high-latency links. **Offloading** centralizes concerns every service would otherwise duplicate — TLS termination, [[security-basics-authn-authz-encryption-rate-limiting|authentication and rate limiting]], response [[where-to-cache-client-cdn-web-server-database-application|caching]], request logging, and [[circuit-breaker-retry-throttling-bulkhead|throttling]].

For different consumers, the **Backend-for-Frontend (BFF)** variant runs a tailored gateway per client type (web, mobile, partner), so one client's needs don't bloat another's API. Unlike a plain [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|L4 load balancer]], a gateway works at L7 and understands the request payload.

## Example

```
GET /dashboard  (one mobile call)
        │
   API gateway ── verify JWT, check rate limit
        ├─→ user-svc      GET /users/42
        ├─→ order-svc     GET /orders?user=42   (parallel)
        └─→ notif-svc     GET /unread?user=42
        │
   merge → { user, orders, unread }  → single 200 response
```

The phone makes one request over a slow link instead of three; auth runs once at the edge.

## Pitfalls

- **God gateway** — piling business logic into the gateway recreates a monolith and a deploy bottleneck; keep it to routing and cross-cutting concerns.
- **Single point of failure** — one gateway fronts everything, so it must be replicated behind a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]].
- **Added latency** — every request gains a hop; mitigate with caching and parallel aggregation, not sequential calls.
- **Coupling clients to internal shape** — leaking service structure through the gateway defeats the decoupling it exists to provide.

## See also

- [[reverse-proxy-vs-load-balancer]]
- [[service-discovery]]
