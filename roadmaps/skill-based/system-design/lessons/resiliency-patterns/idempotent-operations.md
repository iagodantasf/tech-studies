---
title: Idempotent operations
track: system-design
group: Resiliency & patterns
tags: [system-design, idempotency]
prerequisites: []
see-also: [circuit-breaker-retry-throttling-bulkhead, message-queues]
---

# Idempotent operations

An operation is idempotent when applying it once or many times yields the same end state — making retries safe.

## Why it matters

Networks lie: a request can succeed on the server while the response is lost, leaving the client unsure and prone to retry. Without idempotency that retry double-charges a card or ships two orders. Since every resilient system retries ([[circuit-breaker-retry-throttling-bulkhead|retry/backoff]]) and every [[message-queues|queue]] redelivers under at-least-once semantics, idempotency is the property that makes those retries correct instead of dangerous.

## How it works

Distinguish *naturally* idempotent operations from ones you must *make* idempotent:

| HTTP method | Idempotent? | Note |
|---|---|---|
| GET / PUT / DELETE | Yes | Same final state on repeat |
| POST | No | Creates a new resource each call |

`SET balance = 100` is idempotent; `balance = balance + 10` is not. For the unsafe cases, the standard tool is an **idempotency key**: the client generates a unique ID per logical operation and sends it; the server records `(key → result)` in a dedup store.

```
on request(key, payload):
  if store.has(key):           # already processed
      return store.get(key)    # replay the saved result
  result = process(payload)    # do the work exactly once
  store.put(key, result, ttl)  # remember it
  return result
```

The check-and-store must be atomic (unique constraint or compare-and-set) so two concurrent retries can't both pass. Keys carry a TTL since they can't live forever. This pairs with [[message-queues|message]] consumers, which see the same message twice under at-least-once delivery.

## Example

A user double-clicks "Pay $50". The browser fires two POSTs sharing `Idempotency-Key: 7f3a-91`.

```
req A: key 7f3a-91 → no record → charge $50 → store result → 200
req B: key 7f3a-91 → record exists → skip charge → return stored 200
```

Card charged once; both clicks get a success response. Stripe's API works exactly this way.

## Pitfalls

- **Key tied to the wrong scope** — reusing a key across distinct operations silently drops a legitimate second action.
- **Non-atomic dedup check** — a plain "read then write" lets two concurrent retries both slip through; use a unique constraint.
- **Storing nothing but a flag** — without caching the *result*, the retry can't be answered correctly and may re-run.
- **Confusing idempotent with safe** — `DELETE` is idempotent but still mutates; don't expose it to crawlers.

## See also

- [[circuit-breaker-retry-throttling-bulkhead]]
- [[message-queues]]
