---
title: Message queues
track: system-design
group: Asynchronism
tags: [system-design, messaging]
prerequisites: [application-layer-microservices]
see-also: [task-queues, event-driven-architecture]
---

# Message queues

A message queue is durable middleware that buffers messages between producers and consumers so the two never have to be available at the same instant.

## Why it matters

Synchronous calls couple a producer's latency and uptime to its slowest downstream: if the consumer is slow or down, the caller blocks or fails. A queue breaks that link — the producer hands off a message and returns immediately, while the consumer drains the backlog at its own pace. This absorbs traffic spikes (the queue is the shock absorber), lets you scale consumers independently, and keeps a sudden 10x burst from toppling a service sized for the average.

## How it works

A **broker** (RabbitMQ, SQS, ActiveMQ) holds messages until a consumer acknowledges them. Two routing shapes dominate:

| Model | Fan-out | Each message goes to | Example |
|---|---|---|---|
| Queue (point-to-point) | No | exactly one consumer | RabbitMQ work queue, SQS |
| Pub/sub (topic) | Yes | every subscriber | Kafka topic, SNS |

Delivery hinges on the **ack**: the consumer processes, then acknowledges; only then does the broker delete the message. Crash before ack and the message is redelivered — giving **at-least-once** delivery, which is why consumers must be [[idempotent-operations|idempotent]]. Repeatedly failing messages are routed to a **dead-letter queue (DLQ)** after N attempts so one poison message can't block the line. This buffering is the backbone of [[event-driven-architecture]] and decouples microservices ([[application-layer-microservices]]) from slow downstreams.

## Example

Order checkout that emails a receipt without blocking the response:

```
POST /checkout
  → write order to DB
  → publish "OrderPlaced" to queue   (~2 ms, returns 200 now)

EmailWorker (×4 consumers):
  pull msg → render + send email (slow, calls SMTP)
  ack on success; on 3 failures → DLQ for manual review
```

A 5-minute SMTP outage just deepens the queue; checkout latency is untouched, and workers catch up once SMTP recovers.

## Pitfalls

- **Assuming exactly-once.** Brokers give at-least-once; design consumers to dedupe (idempotency key) or you double-charge and double-email.
- **No DLQ or alert on it.** A poison message silently retries forever, blocking the queue or burning CPU; always cap retries and alert on DLQ depth.
- **Unbounded growth.** If producers outrun consumers indefinitely, the queue is a leak, not a buffer — monitor depth and apply [[back-pressure]].
- **Ordering assumptions.** Most queues don't guarantee global order across partitions; if you need it, use a single partition or sequence numbers.

## See also

- [[task-queues]]
- [[event-driven-architecture]]
