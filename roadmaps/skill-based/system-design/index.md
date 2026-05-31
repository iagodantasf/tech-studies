---
title: System Design
track: system-design
category: Skill-based
tags: [roadmap, system-design]
---

# System Design

> roadmap.sh: https://roadmap.sh/system-design

Suggested path through the **System Design** nodes. Each node links to its lesson when written.

## Nodes

### Fundamentals
- [[what-is-system-design-how-to-approach-it]]
- [[performance-vs-scalability]]
- [[latency-vs-throughput]]
- [[availability-vs-consistency-cap-theorem]]
- [[consistency-patterns-weak-eventual-strong]]
- [[availability-patterns-failover-replication]]
- [[availability-in-numbers-the-nines]]

### Networking & delivery
- [[domain-name-system-dns]]
- [[content-delivery-network-cdn-push-vs-pull]]
- [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active]]
- [[reverse-proxy-vs-load-balancer]]
- [[horizontal-vs-vertical-scaling]]

### Application layer
- [[application-layer-microservices]]
- [[service-discovery]]
- [[api-gateway-routing-aggregation-offloading]]

### Databases
- [[rdbms-replication-master-slave-master-master]]
- [[federation]]
- [[sharding]]
- [[denormalization]]
- [[sql-tuning]]
- [[nosql-key-value-document-wide-column-graph]]
- [[sql-vs-nosql-when-to-use-which]]

### Caching
- [[where-to-cache-client-cdn-web-server-database-application]]
- [[caching-strategies-cache-aside-write-through-write-behind-refresh-ahead]]
- [[eviction-policies-cache-pitfalls]]

### Asynchronism
- [[message-queues]]
- [[task-queues]]
- [[back-pressure]]
- [[async-request-reply]]

### Communication
- [[tcp-vs-udp]]
- [[rpc-grpc]]
- [[rest-graphql]]
- [[http]]

### Resiliency & patterns
- [[circuit-breaker-retry-throttling-bulkhead]]
- [[idempotent-operations]]
- [[leader-election]]
- [[cqrs-event-sourcing]]
- [[event-driven-architecture]]
- [[strangler-fig-incremental-migration]]

### Observability
- [[health-performance-monitoring]]
- [[instrumentation-alerts-visualization]]

### Security
- [[security-basics-authn-authz-encryption-rate-limiting]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- Design a URL shortener (encode, redirect, scale reads, analytics)
- Design a rate limiter (token bucket vs sliding window) and implement one in `playgrounds/go/`
- Sketch a news feed / timeline (fan-out on write vs read)
