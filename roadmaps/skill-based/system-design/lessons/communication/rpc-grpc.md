---
title: RPC & gRPC
track: system-design
group: Communication
tags: [system-design, rpc]
prerequisites: [networking]
see-also: [rest-graphql, http]
---

# RPC & gRPC

Remote Procedure Call makes a network request look like a local function call; gRPC is the modern, high-performance RPC framework built on HTTP/2 and Protocol Buffers.

## Why it matters

RPC is the default style for **internal** service-to-service traffic in a [[application-layer-microservices|microservices]] system: it is fast, strongly typed via a shared contract, and ergonomic — you call `getUser(id)` instead of hand-rolling URLs and JSON. gRPC in particular gives you code-generated clients in many languages, binary efficiency, and streaming, which is why it dominates east-west traffic where [[rest-graphql|REST]] feels too chatty and untyped.

## How it works

The contract lives in an **IDL** file (a `.proto` for gRPC). A code generator turns it into client **stubs** and server **skeletons**, so both sides share types and signatures. At call time the client serializes args, the framework ships them over the wire, the server deserializes, runs the method, and returns the result — marshaling and transport are hidden.

gRPC's stack and its four call shapes:

| Layer | gRPC choice |
|---|---|
| Contract | Protocol Buffers (`.proto`) |
| Encoding | Protobuf binary |
| Transport | [[http]]/2 (multiplexed, header-compressed) |
| Call modes | unary, server-stream, client-stream, bidi-stream |

Because it rides HTTP/2, many independent calls share one TCP connection (multiplexing), and long-lived **streams** let either side push messages — ideal for telemetry, chat, or large result sets. Protobuf's compact binary and schema-driven evolution (number your fields, add new ones, stay backward compatible) keep payloads small and contracts stable.

## Example

A `.proto` and the call it generates:

```proto
service UserService {
  rpc GetUser (UserReq) returns (User);
}
message UserReq { int32 id = 1; }
message User    { int32 id = 1; string name = 2; }
```

```
// client — looks local, runs remote
user := client.GetUser(ctx, &UserReq{Id: 42})
// over the wire: HTTP/2 POST /UserService/GetUser, protobuf body
```

A REST equivalent would be `GET /users/42` returning JSON — more universal and cache-friendly, but untyped and bulkier than the ~handful of protobuf bytes here.

## Pitfalls

- **Exposing gRPC straight to browsers/public clients.** Native gRPC needs HTTP/2 and a proxy (gRPC-Web); for public APIs, REST/JSON is often the safer edge — terminate at an [[api-gateway-routing-aggregation-offloading|API gateway]].
- **Tight coupling via the shared stub.** Regenerating breaks callers if you rename or renumber fields; treat the `.proto` as a versioned contract and only add fields.
- **Leaky abstraction.** A "function call" that crosses the network can be slow or fail; you still need timeouts, [[circuit-breaker-retry-throttling-bulkhead|retries, and circuit breakers]].
- **Debuggability.** Binary frames are not curl-able or human-readable; invest in reflection, logging, and tooling early.

## See also

- [[rest-graphql]]
- [[http]]
