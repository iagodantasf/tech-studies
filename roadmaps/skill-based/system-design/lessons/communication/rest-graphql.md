---
title: REST & GraphQL
track: system-design
group: Communication
tags: [system-design, api-styles]
prerequisites: [http]
see-also: [rpc-grpc, api-gateway-routing-aggregation-offloading]
---

# REST & GraphQL

REST and GraphQL are two API styles over [[http]]: REST exposes many resource URLs with fixed shapes; GraphQL exposes one endpoint and lets the client query exactly the fields it wants.

## Why it matters

These are the dominant choices for **public and client-facing** APIs, where ergonomics, caching, and over/under-fetching matter more than raw east-west speed (that's [[rpc-grpc|RPC's]] turf). REST's resource model is simple, cacheable, and universally understood; GraphQL solves the "mobile screen needs 5 entities in 1 round trip, but each REST call returns 30 fields it ignores" problem. Choosing well shapes client complexity, bandwidth, and how your caching and monitoring work.

## How it works

REST models the world as **resources** addressed by URLs and manipulated with [[http]] verbs; GraphQL exposes a typed **schema** and resolves one query against many fields:

| Aspect | REST | GraphQL |
|---|---|---|
| Endpoints | Many (per resource) | One (`/graphql`) |
| Fetching | Server decides shape | Client picks fields |
| Round trips | Often several | Usually one |
| HTTP caching | Native (GET + URL) | Hard (POST, one URL) |
| Typical verb | GET/POST/PUT/DELETE | POST |

- **REST** leans on HTTP itself: `GET` is safe and cacheable, status codes carry meaning, and a URL is a natural cache key. Its weaknesses are **over-fetching** (fixed payloads) and **under-fetching** (N+1 client round trips across linked resources).
- **GraphQL** lets the client send one query naming exactly the fields and nested relations it needs; **resolvers** on the server fetch each piece. This kills over/under-fetching but moves caching and the **N+1 query** risk server-side, and a single malicious deep query can be expensive.

## Example

Fetch a user's name plus their last 2 order totals.

```
REST  (over-fetch + extra trip):
  GET /users/42                 -> {id,name,email,address,...}
  GET /users/42/orders?limit=2  -> [{id,total,items,...}, ...]

GraphQL (one trip, exact fields):
  POST /graphql
  query { user(id:42){ name orders(last:2){ total } } }
  -> { "user": { "name":"Ada", "orders":[{"total":12},{"total":7}] } }
```

REST is trivially cacheable at a CDN; the GraphQL POST needs application-level or persisted-query caching instead.

## Pitfalls

- **GraphQL loses free HTTP caching.** One POST endpoint means [[content-delivery-network-cdn-push-vs-pull|CDN/proxy]] GET caching no longer applies; you need persisted queries or app caching.
- **Unbounded GraphQL queries.** Deeply nested or wildcard queries can hammer your DB; enforce depth/complexity limits and timeouts.
- **The N+1 problem just moves.** GraphQL resolvers naively fetch per-field/per-item; use batching (DataLoader) or you trade client round trips for DB ones.
- **REST verb/status misuse.** Returning 200 with an error body, or non-idempotent PUT, breaks clients, caches, and retries; honor [[idempotent-operations|idempotency]] semantics.

## See also

- [[rpc-grpc]]
- [[api-gateway-routing-aggregation-offloading]]
