---
title: Circuit breaker, retry, throttling, bulkhead
track: system-design
group: Resiliency & patterns
tags: [system-design, resiliency]
prerequisites: [availability-patterns-failover-replication]
see-also: [idempotent-operations, back-pressure]
---

# Circuit breaker, retry, throttling, bulkhead

Four complementary client-side patterns that stop a single slow or failing dependency from cascading into a system-wide outage.

## Why it matters

In a distributed system a downstream slowdown is contagious: callers pile up blocked threads waiting on it, exhaust their own pools, and fail too — a cascading failure. These patterns convert "wait forever and die together" into "fail fast, shed load, isolate the blast radius," which is the difference between one degraded feature and a full outage. They directly raise your effective [[availability-in-numbers-the-nines|availability]].

## How it works

Each pattern attacks a different failure mode; production systems layer all four.

| Pattern | Protects against | Mechanism |
|---|---|---|
| Retry | Transient blips | Re-issue with backoff + jitter |
| Circuit breaker | A persistently sick dependency | Stop calling after N failures |
| Throttling | Overload / abuse | Cap request rate, reject excess |
| Bulkhead | One dependency hogging resources | Isolate into separate pools |

A **circuit breaker** wraps calls in a state machine — `Closed` (pass through, count failures) → `Open` (fail instantly, no call) → `Half-Open` (let one probe through; success closes it, failure re-opens). **Retries** must use exponential backoff with jitter and a cap, or synchronized clients create a thundering herd. **Bulkheads** give each dependency its own connection/thread pool so a stall in one can't drain the shared pool. Throttling enforces a rate limit and is the server-side cousin of client [[back-pressure|back-pressure]].

## Example

```
order-svc → payment-svc (p99 latency spikes to 30s)
breaker: 5 failures in 10s window → trips OPEN
  next 30s: every call fails instantly (50ms), threads freed
  t+30s: HALF-OPEN → 1 probe call
    success → CLOSED (resume)
    failure → OPEN again, double the cooldown
meanwhile: bulkhead capped payment to 20 threads,
           so checkout's other 80 threads keep serving
```

## Pitfalls

- **Retrying non-idempotent calls** doubles side effects (two charges). Only retry [[idempotent-operations|idempotent]] operations or use idempotency keys.
- **No jitter** — uniform backoff re-synchronizes clients into retry storms that DDoS the recovering service.
- **Breaker threshold too loose** keeps hammering a dead dependency; too tight trips on normal noise. Tune against real error rates.
- **Retrying through an open breaker** just burns the retry budget for nothing; the breaker should short-circuit first.

## See also

- [[idempotent-operations]]
- [[back-pressure]]
