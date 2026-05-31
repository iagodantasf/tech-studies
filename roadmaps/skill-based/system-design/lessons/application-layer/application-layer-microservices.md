---
title: Application layer & microservices
track: system-design
group: Application layer
tags: [system-design, microservices]
prerequisites: [horizontal-vs-vertical-scaling]
see-also: [service-discovery, api-gateway-routing-aggregation-offloading]
---

# Application layer & microservices

The application (service) layer is the tier that holds business logic, sitting between clients and data stores, and microservices is the pattern of splitting it into small, independently deployable services.

## Why it matters

Separating the application layer from the web tier lets you scale logic independently of request fan-in, and swap or restart services without touching the front end. Microservices push this further: teams ship on their own cadence, a memory leak in one service can't crash the others, and you scale only the hot paths. The cost is operational — you trade in-process calls for a distributed system, with all the partial-failure and latency that implies.

## How it works

Decompose by **business capability**, not by technical layer — each service owns one bounded context end to end, including its own data store (no shared database):

| Concern | Monolith | Microservices |
|---|---|---|
| Deploy unit | One artifact | Per service |
| Communication | In-process call | Network ([[rpc-grpc]], [[rest-graphql]]) |
| Data | Shared schema | Per-service store |
| Failure blast radius | Whole app | One service (ideally) |

Services find each other through [[service-discovery]] and are usually fronted by an [[api-gateway-routing-aggregation-offloading]]. Because every call is now a network call, you need resilience patterns — [[circuit-breaker-retry-throttling-bulkhead]] and [[idempotent-operations]] — and async links via [[message-queues]] to decouple slow or unreliable downstreams.

A **stateless** application layer is what makes [[horizontal-vs-vertical-scaling|horizontal scaling]] cheap: any instance can serve any request, so you put them behind a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]] and add nodes. Session state lives in a cache or token, never in process memory.

## Example

An e-commerce checkout split into services:

```
Client → API gateway → Order service   (owns orders DB)
                     → Payment service (owns payments DB, calls Stripe)
                     → Inventory service (owns stock DB)
Order → publishes "OrderPlaced" → queue → Shipping service (async)
```

If Payment is slow, the gateway's circuit breaker trips and returns a clean error instead of cascading; Shipping consumes the event whenever it's ready, so a Shipping outage never blocks checkout.

## Pitfalls

- **Distributed monolith** — services that must deploy together or share a database; you got the network cost without the independence.
- **Too-fine granularity** — a service per table turns one logical operation into a chatty fan-out of network calls, multiplying latency and failure modes.
- **No idempotency** — retries across the network duplicate orders or charges unless writes are idempotent.
- **Shared mutable database** — kills independent deploys and hides coupling; each service must own its data.

## See also

- [[service-discovery]]
- [[api-gateway-routing-aggregation-offloading]]
