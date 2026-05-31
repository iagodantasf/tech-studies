---
title: Resiliency & patterns
track: system-design
group: Resiliency & patterns
tags: [system-design]
---

# Resiliency & patterns

Lessons in this group, roughly in build order:

- [[circuit-breaker-retry-throttling-bulkhead]] — Four complementary client-side patterns that stop a single slow or failing dependency from cascading into…
- [[idempotent-operations]] — An operation is idempotent when applying it once or many times yields the same end state — making retries safe
- [[leader-election]] — Leader election is the process by which a cluster of equal nodes agrees on a single one to coordinate…
- [[cqrs-event-sourcing]] — CQRS splits the write model from the read model; event sourcing stores state as an append-only log of…
- [[event-driven-architecture]] — Event-driven architecture (EDA) is a style where services communicate by emitting and reacting to events…
- [[strangler-fig-incremental-migration]] — The strangler fig pattern replaces a legacy system gradually by routing slices of traffic to new services…
