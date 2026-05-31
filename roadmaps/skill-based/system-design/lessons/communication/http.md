---
title: HTTP
track: system-design
group: Communication
tags: [system-design, http]
prerequisites: [tcp-vs-udp]
see-also: [rest-graphql, reverse-proxy-vs-load-balancer]
---

# HTTP

HTTP is the stateless, request-response application protocol of the web: a client sends a method + URL + headers, a server returns a status code + headers + body.

## Why it matters

Nearly all client-facing traffic and most service APIs ([[rest-graphql|REST]], [[rpc-grpc|gRPC]]) are HTTP, so its semantics shape how you cache, scale, and observe systems. Its **statelessness** is what lets any [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]] send a request to any server, the foundation of [[horizontal-vs-vertical-scaling|horizontal scaling]]. Its method and status-code semantics drive caching, retries, and [[idempotent-operations|idempotency]] — get them right and the whole stack cooperates.

## How it works

Each request carries a **method** (verb), a URL, headers, and an optional body; the response carries a status code, headers, and a body. Methods have semantics caches and clients rely on:

| Method | Safe | Idempotent | Use |
|---|---|---|---|
| GET | yes | yes | read (cacheable) |
| POST | no | no | create / action |
| PUT | no | yes | replace |
| DELETE | no | yes | remove |

Status codes group by class: `2xx` success, `3xx` redirect, `4xx` client error, `5xx` server error. The protocol is **stateless** — each request stands alone — so session state lives in cookies, tokens, or a shared store, never in the server's memory. Caching is built in via `Cache-Control`, `ETag`, and conditional `If-None-Match` (a 304 saves a body).

Versions changed the *transport*, not the semantics:

- **HTTP/1.1** — one request at a time per connection (with keep-alive); parallel requests need multiple connections.
- **HTTP/2** — multiplexes many streams over one [[tcp-vs-udp|TCP]] connection + header compression, but TCP head-of-line blocking remains.
- **HTTP/3** — runs over QUIC ([[tcp-vs-udp|UDP]]), removing transport-level head-of-line blocking and cutting handshake RTTs.

## Example

A conditional GET that revalidates a cache cheaply:

```
GET /products/42 HTTP/1.1
Host: api.shop.com
If-None-Match: "v7"

HTTP/1.1 304 Not Modified      # body omitted — client reuses cached copy
ETag: "v7"
Cache-Control: max-age=60
```

If the product had changed, the server would instead return `200` with the new body and a new `ETag` (`"v8"`).

## Pitfalls

- **Stuffing state into the server.** In-memory sessions break the moment a load balancer routes the next request elsewhere; externalize session state.
- **Wrong status codes.** Returning `200` for failures (or `500` for bad input) defeats client retries, alerting, and [[content-delivery-network-cdn-push-vs-pull|CDN]] caching logic.
- **Non-idempotent retries.** Retrying a `POST` can double-charge; use [[idempotent-operations|idempotency keys]] or idempotent verbs for anything retryable.
- **Ignoring connection cost.** New TLS connections per request burn RTTs; reuse keep-alive/HTTP-2 connections and pool them.

## See also

- [[rest-graphql]]
- [[reverse-proxy-vs-load-balancer]]
