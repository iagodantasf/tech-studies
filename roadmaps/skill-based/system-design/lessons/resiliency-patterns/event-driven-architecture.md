---
title: Event-driven architecture
track: system-design
group: Resiliency & patterns
tags: [system-design, event-driven]
prerequisites: [message-queues]
see-also: [cqrs-event-sourcing, async-request-reply]
---

# Event-driven architecture

Event-driven architecture (EDA) is a style where services communicate by emitting and reacting to events instead of calling each other directly.

## Why it matters

Direct request/response coupling means the caller must know, and wait on, every downstream — so one slow or down service drags the whole chain with it. EDA inverts this: a producer announces "this happened" and forgets, while any number of consumers react independently. This yields loose coupling, independent scaling, and resilience — a consumer can be offline and catch up later from the [[message-queues|queue]] — at the cost of harder reasoning about end-to-end flow.

## How it works

The producer never names its consumers; an event broker (Kafka, SNS/SQS, RabbitMQ) decouples them. Two delivery topologies dominate:

| Model | Shape | Use when |
|---|---|---|
| Pub/Sub | Broadcast to all subscribers | Many independent reactions |
| Event stream | Durable, replayable, ordered log | Replay / new consumers later |

- **Event** — an immutable fact about the past (`OrderPlaced`), not a command telling someone what to do.
- **Topic** — a named channel; consumers subscribe to what they care about.
- **Consumer group** — a set of workers splitting a partition's load for horizontal scale.

```
order-svc ──OrderPlaced──► [topic] ──► email-svc   (send confirmation)
                                  ├──► inventory-svc (decrement stock)
                                  └──► analytics-svc (record metric)
```

Adding a new reaction means adding a subscriber — zero changes to the producer. Delivery is at-least-once, so consumers must be [[idempotent-operations|idempotent]]. This is the substrate that [[cqrs-event-sourcing|event sourcing]] projections ride on, and the async counterpart to [[async-request-reply|async request-reply]].

## Example

Checkout in a monolith fires three synchronous calls (charge, email, ship), so a slow email API stalls the whole purchase. Re-modeled as EDA:

```
checkout: persist order → publish OrderPlaced → return 200 (fast)
later, independently:
  payment-svc   consumes → charges card
  email-svc     consumes → sends receipt  (its outage doesn't block checkout)
  shipping-svc  consumes → schedules dispatch
```

The user's request completes in milliseconds; downstream work happens out of band.

## Pitfalls

- **Eventual consistency everywhere** — there is no instant global state; the UI must tolerate "ordered, not yet shipped" gaps.
- **Hard to trace** — a logical flow spans many async hops; without correlation IDs and tracing, debugging is brutal.
- **Duplicate delivery** — at-least-once means consumers re-see events; non-idempotent handlers double-process.
- **Lost ordering** — events across partitions have no global order; design for it instead of assuming sequence.

## See also

- [[cqrs-event-sourcing]]
- [[async-request-reply]]
