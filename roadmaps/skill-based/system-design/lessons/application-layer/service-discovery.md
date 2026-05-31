---
title: Service discovery
track: system-design
group: Application layer
tags: [system-design, service-discovery]
prerequisites: [application-layer-microservices]
see-also: [api-gateway-routing-aggregation-offloading, load-balancers-l4-vs-l7-algorithms-active-passive-active-active]
---

# Service discovery

Service discovery is the mechanism by which a service finds the current network location of another service whose instances come and go.

## Why it matters

In a dynamic environment instances are ephemeral — autoscaling, deploys, and crashes constantly change IPs and ports — so hard-coding addresses breaks immediately. Discovery decouples "who I want to call" (a logical name) from "where it lives right now" (an IP:port), which is the precondition for elastic [[horizontal-vs-vertical-scaling|horizontal scaling]] and zero-downtime deploys. Get it wrong and you route traffic to dead instances or miss healthy new ones.

## How it works

A **service registry** is the source of truth mapping names to live instances. Instances register on startup and send periodic **heartbeats**; the registry evicts any that stop reporting (driven by [[health-performance-monitoring|health checks]]). Two models decide who does the lookup:

| Pattern | Who resolves | Trade-off |
|---|---|---|
| Client-side | Caller queries registry, picks instance | Smart client, no extra hop |
| Server-side | A load balancer resolves for the caller | Dumb client, one extra hop |

In **server-side** discovery the caller just hits a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]] that does the lookup. Registration is either **self-registration** (the instance writes itself in) or **third-party** (a sidecar or platform registers it). Many platforms expose discovery through [[domain-name-system-dns|DNS]] (e.g. a service name resolves to current pod IPs), so callers just dial a stable hostname.

Because the registry is critical infrastructure, it must be highly available and is itself replicated; entries carry a TTL so stale records expire even if eviction lags. Clients cache resolutions to cut latency, accepting brief staleness as the [[availability-vs-consistency-cap-theorem|CAP]] trade.

## Example

```
1. payment-svc boots → registers {name: payment, ip: 10.0.3.7:8080} → registry
2. payment-svc → heartbeat every 10s
3. order-svc needs payment → asks registry → gets [10.0.3.7, 10.0.3.9]
4. order-svc load-balances across the two, retries on failure
5. 10.0.3.7 crashes → 3 missed heartbeats → registry evicts it
6. next lookup returns only [10.0.3.9]
```

## Pitfalls

- **Stale entries** — too-long heartbeat or TTL keeps routing to dead instances; tune eviction against real failure-detection needs.
- **Registry as single point of failure** — an unreplicated registry takes the whole mesh down; it must be HA.
- **Aggressive client caching** — caching resolutions too long defeats fast failover after an instance dies.
- **Shallow health checks** — a process that answers TCP but can't serve requests stays "healthy"; check real readiness.

## See also

- [[api-gateway-routing-aggregation-offloading]]
- [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active]]
