---
title: "Atomics"
track: cpp
group: Concurrency
tags: [cpp, atomics]
prerequisites: [memory-model-data-races, mutexes-locks]
see-also: [memory-model-data-races, mutexes-locks, condition-variables, bit-manipulation]
---

# Atomics

`std::atomic<T>` (`<atomic>`) provides indivisible, race-free operations on a value shared between threads, with control over how surrounding memory operations are ordered.

## Why it matters

An atomic is the only race-free way to share a mutable scalar *without a mutex* — plain `int` access from two threads is undefined behavior (see [[memory-model-data-races]]). Atomics power lock-free counters, flags, sequence numbers, and the spin in a `std::shared_ptr` refcount. They are faster than a mutex for tiny operations but far subtler: ordering bugs are silent and non-deterministic.

## How it works

Reads (`load`), writes (`store`), and read-modify-write ops (`fetch_add`, `exchange`, `compare_exchange_*`) execute atomically. Each takes a **memory order** controlling visibility of *other* (non-atomic) memory around it.

| `std::memory_order` | Guarantee |
|---|---|
| `relaxed` | atomicity only; no ordering of other memory |
| `acquire` | later reads/writes can't move before this load |
| `release` | earlier reads/writes can't move after this store |
| `acq_rel` | both, for read-modify-write ops |
| `seq_cst` (default) | single total order across all threads |

- A **release store** paired with an **acquire load** of the same variable creates a *happens-before* edge: everything the writer did before the release is visible to the reader after the acquire. This is how you publish data lock-free.
- `compare_exchange_weak(expected, desired)` is the CAS loop primitive; the *weak* form may fail spuriously, so it lives inside a `while` loop and is faster on LL/SC architectures (ARM).
- `atomic<T>::is_lock_free()` is true for types the CPU handles natively (usually ≤ pointer width); larger `T` may fall back to an internal lock, losing the benefit.
- `relaxed` is correct for a pure counter where you only need the final total (e.g. statistics); it is *wrong* for flags that publish other data.

## Example

A lock-free spin flag publishing a payload:

```cpp
std::atomic<bool> ready{false};
int data = 0;                                    // plain, non-atomic

// producer
data = 42;
ready.store(true, std::memory_order_release);    // publishes data

// consumer
while (!ready.load(std::memory_order_acquire))   // acquires
  std::this_thread::yield();
assert(data == 42);                              // guaranteed by acq/rel pairing
```

A CAS-based counter: `while(!n.compare_exchange_weak(cur, cur+1)) {}` — `cur` is reloaded automatically on failure.

## Pitfalls

- **`relaxed` does not order other memory.** Using it for the `ready` flag above lets the consumer see `ready==true` but `data==0`. Publish with release/acquire.
- **Atomicity ≠ a transaction.** `x.load(); x.store(x+1)` is two atomic ops with a race between them; use `fetch_add` or a CAS loop for read-modify-write.
- **`compare_exchange_weak` failing spuriously** must be tolerated; only use the `_strong` form outside a loop where a spurious retry would be wrong.
- **`volatile` is not atomic.** It governs memory-mapped I/O, gives no atomicity or cross-thread ordering, and never replaces `std::atomic`.

## See also

- [[memory-model-data-races]]
- [[mutexes-locks]]
- [[condition-variables]]
