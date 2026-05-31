---
title: Latency vs throughput
track: system-design
group: Fundamentals
tags: [system-design, performance]
prerequisites: [performance-vs-scalability]
see-also: [back-pressure, message-queues]
---

# Latency vs throughput

**Latency** is the time for one request to complete; **throughput** is how many requests complete per unit time — related but independently optimizable.

## Why it matters

You design for both, and they trade off. Batching and queuing raise throughput but add latency; replicating for low latency can cap throughput per node. SLOs are usually written on **tail latency** (p99/p99.9), not the average, because at scale the slow tail is what users actually hit — a request that fans out to 100 services sees the *slowest* of 100, so a rare 1-in-100 stall becomes the common case.

## How it works

Think of a pipe: **latency** is its length, **throughput** is its width. **Little's Law** ties them: `L = λ × W` — concurrent requests in flight = arrival rate × latency. A useful corollary: with bounded concurrency, **lower latency directly buys higher throughput**.

- Report **percentiles**, never just the mean — p50/p95/p99/p99.9. One GC pause skews the mean but shows up honestly at the tail.
- **Batching/pipelining** amortizes fixed cost (round trips, fsync) across many items → throughput up, per-item latency up.
- A queue ([[message-queues]]) decouples producer/consumer rate; under overload it must shed or apply [[back-pressure]] or latency grows unbounded.

| Lever | Latency | Throughput |
|---|---|---|
| Batch writes | worse | better |
| Add replica/shard | same/better | better |
| Bigger queue | worse | hides spikes |

A rough latency ladder worth memorizing: L1 ~1 ns, main memory ~100 ns, SSD read ~100 µs, intra-DC round trip ~0.5 ms, cross-continent ~150 ms.

## Example

A logging service must absorb 1M events/s. Writing each individually fsyncs per event (~1 ms each) and collapses. Batching 10K events per flush raises throughput past 1M/s while adding only ~10 ms of buffering latency — a deliberate latency-for-throughput trade users never notice on a log.

## Pitfalls

- **Tuning the mean** — a great average can hide a brutal p99.9.
- **Unbounded queues** trading a fast failure for slowly rising latency until OOM; bound them and apply [[back-pressure]].
- **Ignoring coordinated omission** — load tools that pause during stalls under-report tail latency.

## See also

- [[message-queues]]
- [[back-pressure]]
