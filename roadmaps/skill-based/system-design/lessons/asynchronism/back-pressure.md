---
title: Back pressure
track: system-design
group: Asynchronism
tags: [system-design, flow-control]
prerequisites: [message-queues]
see-also: [circuit-breaker-retry-throttling-bulkhead, latency-vs-throughput]
---

# Back pressure

Back pressure is a flow-control signal that tells a fast producer to slow down (or stops accepting work) when a downstream consumer can't keep up, so the system sheds or queues load deliberately instead of collapsing.

## Why it matters

Every buffer is finite. If producers outrun consumers, an unbounded queue grows until it exhausts memory, latency balloons (work waits behind a mile-long backlog), and the service falls over — often taking healthy callers with it. Back pressure makes the limit explicit: the system degrades gracefully — rejecting or pausing intake — rather than failing catastrophically. It is the difference between a controlled "try again later" and an out-of-memory crash.

## How it works

You bound the queue and decide what happens when it's full. Common strategies:

| Strategy | When buffer fills | Cost |
|---|---|---|
| Block | producer waits (pull-based) | producer throughput drops |
| Drop | discard new (or oldest) | data loss, but system survives |
| Reject (load shed) | return 429 / 503 | caller must retry |
| Buffer to disk | spill overflow to disk | latency, bounded by disk |

**Pull-based** systems (consumer requests N items when ready) have back pressure built in — the consumer's pace sets the rate. **Push-based** systems need explicit signals: a bounded queue, a 429 status with `Retry-After`, or TCP's own window (the OS stops ACKing when the receive buffer is full, throttling the sender). Pair load shedding with [[circuit-breaker-retry-throttling-bulkhead|throttling and circuit breakers]] so rejected callers back off instead of hammering. The goal is to protect [[latency-vs-throughput|latency]] for accepted work, not to maximize raw intake.

## Example

An ingestion API in front of a queue that a worker pool drains:

```
queue depth limit = 10_000

POST /events:
  depth < 8_000  → enqueue, 202 Accepted
  depth ≥ 10_000 → 429 Too Many Requests, Retry-After: 2

client: on 429 → exponential backoff + jitter, retry
```

A 5x traffic spike now returns clean 429s for the overflow while accepted events keep flowing at worker capacity — instead of the queue eating all RAM and crashing every consumer at once.

## Pitfalls

- **Unbounded queues.** "Just buffer it" with no cap converts a load spike into an OOM crash; always set a ceiling.
- **Silent dropping.** Shedding load without metrics/alerts hides that you're losing data; count and alert on rejections.
- **Retry storms.** Rejecting without telling clients to back off (no `Retry-After`, no jitter) creates a synchronized retry stampede that's worse than the original spike.
- **Pushing pressure to the wrong layer.** Back pressure must propagate to the true source; absorbing it midstream just relocates the unbounded buffer.

## See also

- [[message-queues]]
- [[circuit-breaker-retry-throttling-bulkhead]]
