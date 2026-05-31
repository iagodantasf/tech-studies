---
title: CQRS & event sourcing
track: system-design
group: Resiliency & patterns
tags: [system-design, event-sourcing]
prerequisites: [consistency-patterns-weak-eventual-strong]
see-also: [event-driven-architecture, denormalization]
---

# CQRS & event sourcing

CQRS splits the write model from the read model; event sourcing stores state as an append-only log of events rather than as current rows.

## Why it matters

Reads and writes have opposing needs: writes want strict validation and normalization, reads want denormalized shapes optimized per query. Forcing both through one model compromises each. CQRS lets you scale and design them independently. Event sourcing adds a perfect audit trail and time-travel, since the log *is* the history — invaluable for finance, debugging, and rebuilding [[denormalization|denormalized]] views.

## How it works

The two patterns are separable but commonly paired.

| Concern | Traditional CRUD | Event sourcing |
|---|---|---|
| Source of truth | Current-state row | Append-only event log |
| Update | Overwrite in place | Append a new event |
| History | Lost on update | Fully preserved |

With CQRS, **commands** mutate state and **queries** read it through different models. With event sourcing, you never `UPDATE`; you append immutable events (`MoneyDeposited`, `OrderShipped`). Current state is a **left fold** (reduce) over the events. **Projections** consume the event stream and build read-optimized views, which is naturally [[event-driven-architecture|event-driven]].

```
write side:  Command → validate → append Event → event store
read  side:  Event → projection → materialized read view (denormalized)
state(account) = events.reduce(apply, EMPTY)   # replay to rebuild
```

Read views update asynchronously, so the system is [[consistency-patterns-weak-eventual-strong|eventually consistent]]: a write is durable instantly, but its projection lags by milliseconds. **Snapshots** cache the fold at version N so replay doesn't start from zero.

## Example

A bank account, event-sourced:

```
events:  Opened, Deposited(100), Withdrew(30), Deposited(50)
balance = fold(+) = 120              ← derived, never stored directly
query "show transactions" → reads the events directly (free audit log)
dispute on the -30? → replay events up to that point, see exact state
```

A traditional row would show only `balance=120`, with no record of how it got there.

## Pitfalls

- **Eventual consistency surprises** — read-your-own-write breaks if the UI reads the lagging projection right after a command.
- **Schema evolution of events** — old events are immutable forever; you must version event shapes and upcast on replay.
- **Replay without snapshots** — rebuilding from millions of events on every load is slow; snapshot periodically.
- **Applying CQRS everywhere** — for a simple CRUD form it is pure overhead; reserve it for complex, audit-heavy domains.

## See also

- [[event-driven-architecture]]
- [[denormalization]]
