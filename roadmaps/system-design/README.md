---
title: System Design
roadmap: system-design
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, system-design]
---

# System Design

> roadmap.sh: https://roadmap.sh/system-design

Track for the **System Design** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Fundamentals
- [ ] What is system design & how to approach it
- [ ] Performance vs scalability
- [ ] Latency vs throughput
- [ ] Availability vs consistency (CAP theorem)
- [ ] Consistency patterns (weak, eventual, strong)
- [ ] Availability patterns (failover, replication)
- [ ] Availability in numbers (the nines)

### Networking & delivery
- [ ] Domain Name System (DNS)
- [ ] Content Delivery Network (CDN) — push vs pull
- [ ] Load balancers — L4 vs L7, algorithms, active-passive/active-active
- [ ] Reverse proxy (vs load balancer)
- [ ] Horizontal vs vertical scaling

### Application layer
- [ ] Application layer & microservices
- [ ] Service discovery
- [ ] API gateway (routing, aggregation, offloading)

### Databases
- [ ] RDBMS & replication (master-slave, master-master)
- [ ] Federation
- [ ] Sharding
- [ ] Denormalization
- [ ] SQL tuning
- [ ] NoSQL — key-value, document, wide-column, graph
- [ ] SQL vs NoSQL — when to use which

### Caching
- [ ] Where to cache (client, CDN, web server, database, application)
- [ ] Caching strategies — cache-aside, write-through, write-behind, refresh-ahead
- [ ] Eviction policies & cache pitfalls

### Asynchronism
- [ ] Message queues
- [ ] Task queues
- [ ] Back pressure
- [ ] Async request-reply

### Communication
- [ ] TCP vs UDP
- [ ] RPC & gRPC
- [ ] REST & GraphQL
- [ ] HTTP

### Resiliency & patterns
- [ ] Circuit breaker, retry, throttling, bulkhead
- [ ] Idempotent operations
- [ ] Leader election
- [ ] CQRS & event sourcing
- [ ] Event-driven architecture
- [ ] Strangler fig (incremental migration)

### Observability
- [ ] Health & performance monitoring
- [ ] Instrumentation, alerts & visualization

### Security
- [ ] Security basics (authn/authz, encryption, rate limiting)

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Design a URL shortener (encode, redirect, scale reads, analytics)
- Design a rate limiter (token bucket vs sliding window) and implement one in `playgrounds/go/`
- Sketch a news feed / timeline (fan-out on write vs read)
