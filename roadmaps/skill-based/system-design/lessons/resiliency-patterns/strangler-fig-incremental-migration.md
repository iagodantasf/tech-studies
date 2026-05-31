---
title: Strangler fig (incremental migration)
track: system-design
group: Resiliency & patterns
tags: [system-design, migration]
prerequisites: [reverse-proxy-vs-load-balancer]
see-also: [api-gateway-routing-aggregation-offloading, application-layer-microservices]
---

# Strangler fig (incremental migration)

The strangler fig pattern replaces a legacy system gradually by routing slices of traffic to new services until the old one can be removed.

## Why it matters

A "big bang" rewrite — build the replacement for a year, then cut over in one night — is the highest-risk move in software: it ships untested, can't be partially rolled back, and stalls feature work for months. The strangler fig de-risks this by migrating one capability at a time behind a routing layer, so every step is small, independently verifiable, and reversible. The legacy system keeps running until the new one has fully grown around it.

## How it works

Named after a vine that grows around a tree until the tree dies and only the vine remains. A routing facade ([[reverse-proxy-vs-load-balancer|reverse proxy]] or [[api-gateway-routing-aggregation-offloading|API gateway]]) sits in front and decides, per route, old vs new.

| Step | Action |
|---|---|
| 1. Intercept | Put a facade in front of the legacy system |
| 2. Carve | Reimplement one capability as a new service |
| 3. Reroute | Point that route's traffic at the new service |
| 4. Repeat | Migrate capability by capability |
| 5. Retire | Delete the legacy code once nothing routes to it |

```
            ┌──────────────────────────┐
client ───► │  facade / API gateway    │
            └──┬──────────────────┬─────┘
   /orders ───►│ NEW order-svc    │      ← migrated
   /users  ───►│ LEGACY monolith  │      ← not yet
            └──────────────────────────┘
```

Migrate low-risk, high-value routes first to build confidence. Each carved service is a step toward [[application-layer-microservices|microservices]], and because routing is per-request you can canary or instantly roll a route back.

## Example

A monolithic e-commerce app, strangled over quarters:

```
Q1: facade in front, 100% → monolith (no behavior change, just routing)
Q2: rebuild search → route /search to search-svc, rest stays
Q3: rebuild checkout → /checkout to checkout-svc; bug found → flip route back same day
Q4: last route /admin migrated → monolith receives zero traffic → delete it
```

At no point is there a risky overnight cutover; the app ships features throughout.

## Pitfalls

- **Shared database** — if old and new both write the same tables, you've split the code but not the system; plan data migration too.
- **Facade becomes the bottleneck** — the routing layer is now critical path and must be HA and low-latency.
- **Migration never finishes** — without a deadline, teams leave the last 20% on the monolith forever, paying for both.
- **Behavior drift** — the new service must match legacy quirks exactly during overlap; shadow traffic to compare outputs.

## See also

- [[api-gateway-routing-aggregation-offloading]]
- [[application-layer-microservices]]
