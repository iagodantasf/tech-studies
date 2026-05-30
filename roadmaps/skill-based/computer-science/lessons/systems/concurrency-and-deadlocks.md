---
title: Concurrency & deadlocks
track: computer-science
group: Systems
tags: [cs, systems, concurrency]
prerequisites: [operating-systems]
see-also: [operating-systems, graphs]
---

# Concurrency & deadlocks

Concurrency is structuring a program as multiple flows that make progress independently — and
managing the **shared state** they fight over without corrupting it or wedging the program.

## Why it matters

Multi-core is the only way left to go faster, but shared mutable state turns "obviously correct" code
into a minefield of races and hangs that vanish under a debugger. Knowing the standard hazards —
**data races** and **deadlocks** — and the tools that prevent them is what separates code that works
on your laptop from code that survives production load.

## How it works

A **race condition** occurs when two threads touch the same memory and at least one writes, with no
ordering between them; the result depends on timing. The fix is a **critical section** guarded by a
**mutex**, or lock-free **atomics** for simple counters.

A **deadlock** is a cycle of threads each holding a resource the next one needs. It requires all four
**Coffman conditions** at once:

- **Mutual exclusion** — a resource is held exclusively.
- **Hold and wait** — a thread holds one resource while requesting another.
- **No preemption** — resources are released only voluntarily.
- **Circular wait** — a cycle in the "waits-for" [[graphs|graph]].

Break any one condition and deadlock is impossible. The most practical fix is **lock ordering**:
acquire locks in a fixed global order so no cycle can form. Related hazards are **livelock** (threads
keep reacting but make no progress) and **starvation** (a thread never gets scheduled).

## Example

```
# Classic deadlock: two threads, opposite lock order
T1: lock(A); lock(B)   # holds A, waits for B
T2: lock(B); lock(A)   # holds B, waits for A   → circular wait

# Fix: both acquire in the same order
T1: lock(A); lock(B)
T2: lock(A); lock(B)   # no cycle possible
```

In Rust this maps onto `Arc<Mutex<T>>` for shared ownership plus locking; the compiler enforces that
you actually hold the lock before touching the data.

## Pitfalls

- **Forgetting to release a lock** on an early return or panic — use RAII/scope guards so unlocking
  is automatic.
- **Holding a lock during slow I/O** — serializes every thread behind one blocking call; copy out and
  release first.
- **Double-checked locking without atomics** — a classic broken pattern; the visibility guarantees
  aren't there without proper memory ordering.

## See also

- [[operating-systems]]
- [[graphs]]
