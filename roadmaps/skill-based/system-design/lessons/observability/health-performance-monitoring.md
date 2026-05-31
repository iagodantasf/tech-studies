---
title: Health & performance monitoring
track: system-design
group: Observability
tags: [system-design, monitoring]
prerequisites: [latency-vs-throughput]
see-also: [instrumentation-alerts-visualization, availability-in-numbers-the-nines]
---

# Health & performance monitoring

Health monitoring asks "is this instance alive and ready?"; performance monitoring asks "is the system meeting its latency, throughput, and error targets?" — two different questions answered by two different signals.

## Why it matters

You cannot operate what you cannot see. Health signals decide routing and self-healing — a [[load-balancers-l4-vs-l7-algorithms-active-passive-active-active|load balancer]] only sends traffic to instances that pass checks, and [[service-discovery]] evicts ones that fail. Performance signals tell you whether you are burning your [[availability-in-numbers-the-nines|error budget]] before customers complain. Without both, your first sign of an outage is an angry user, not a graph.

## How it works

Separate **liveness** (is the process up — restart if not) from **readiness** (can it serve right now — pull from rotation if not). A warming cache or a draining instance is live but not ready; conflating them causes restart loops or routing to cold nodes.

- **Health checks** must be *deep*: hit a `/health` endpoint that actually pings the DB and downstream deps, not just a TCP accept. A shallow check passes a process that can't serve a single request.
- Frame performance with a known model. **RED** (Rate, Errors, Duration) suits request-driven services; **USE** (Utilization, Saturation, Errors) suits resources like CPU, disk, and queues. Google's **four golden signals** are latency, traffic, errors, saturation.
- Watch **saturation** — the leading indicator. Queue depth, thread-pool fill, and connection-pool waits climb *before* latency does, giving you warning that [[latency-vs-throughput|throughput]] is about to collapse.

| Signal | Health | Performance |
|---|---|---|
| Question | Alive / ready? | Meeting SLO? |
| Consumer | LB, scheduler, registry | On-call, capacity planning |
| Example | `/ready` 200 vs 503 | p99 latency, error rate |

Report latency as **percentiles** (p50/p95/p99/p99.9), never the mean — one [[availability-patterns-failover-replication|failover]] stall hides in an average but shows honestly at the tail.

## Example

```
GET /ready on payment-svc instance 10.0.3.7
 ├─ checks DB pool: 2/50 in use   → ok
 ├─ checks cache:   reachable      → ok
 └─ checks Stripe:  circuit OPEN   → 503 Not Ready
LB stops routing to 10.0.3.7; instance stays "live" (no restart),
re-enters rotation once the [[circuit-breaker-retry-throttling-bulkhead|circuit]] closes.
```

## Pitfalls

- **Shallow health checks** — answering TCP while unable to serve keeps a broken instance in rotation.
- **Liveness checking dependencies** — if `/live` fails when the DB is down, every instance restarts at once and a recoverable blip becomes a full outage. Only `/ready` should gate on deps.
- **Averaging latency** — a healthy mean can hide a brutal p99.9 that is the real user experience under fan-out.
- **No saturation metric** — watching only latency means you learn about overload only after it has already hurt users.

## See also

- [[instrumentation-alerts-visualization]]
- [[availability-in-numbers-the-nines]]
