---
title: "Mutexes & Locks"
track: cpp
group: Concurrency
tags: [cpp, mutexes]
prerequisites: [threads-std-thread, raii]
see-also: [condition-variables, atomics, memory-model-data-races, concurrency-and-deadlocks]
---

# Mutexes & Locks

A mutex serializes access to shared data so only one thread enters a *critical section* at a time; RAII lock guards in `<mutex>` acquire and release it exception-safely.

## Why it matters

Unsynchronized concurrent access to mutable shared state is a data race — undefined behavior (see [[memory-model-data-races]]). A mutex is the default, correct fix. The lock *guards* matter as much as the mutex: hand-written `lock()`/`unlock()` leaks the lock on any early return or [[exceptions-try-catch-throw|throw]], which then [[concurrency-and-deadlocks|deadlocks]] every other thread.

## How it works

The mutex provides mutual exclusion; a *lock* type is a [[raii]] owner that unlocks in its destructor — you almost never call `unlock()` by hand.

| Mutex / lock | Use |
|---|---|
| `std::mutex` | basic, non-recursive exclusive lock |
| `std::recursive_mutex` | same thread may lock N times (rarely needed) |
| `std::shared_mutex` (C++17) | many readers **or** one writer |
| `std::lock_guard` | scoped, no-frills RAII lock |
| `std::unique_lock` | movable, deferrable, works with `condition_variable` |
| `std::scoped_lock` (C++17) | locks several mutexes deadlock-free |

- A thread locking a `std::mutex` it already holds is **undefined behavior** (self-deadlock); that is what `recursive_mutex` exists for.
- `std::shared_mutex` lets readers share via `std::shared_lock` and writers exclude via `std::unique_lock` — a win only when reads vastly outnumber writes.
- To take two locks safely, use `std::scoped_lock{m1, m2}`, which applies a deadlock-avoidance algorithm; never lock them in ad-hoc order across call sites.
- An uncontended `std::mutex` lock is cheap (often a few ns, a single atomic CAS); contention forces a kernel wait that costs microseconds.

## Example

```cpp
class Counter {
  mutable std::mutex m_;     // mutable so const reads can lock
  long n_ = 0;
public:
  void inc()       { std::lock_guard lg(m_); ++n_; }        // RAII: unlocks on scope exit
  long get() const { std::lock_guard lg(m_); return n_; }   // even reads must lock
};
```

Transferring between two accounts deadlock-free:

```cpp
std::scoped_lock lk(a.m, b.m);   // locks both, any order, no deadlock
a.bal -= x; b.bal += x;
```

## Pitfalls

- **Hold the lock too long** (I/O, callbacks, allocation) and you serialize the program — keep critical sections tiny.
- **Lock-order inversion** across two mutexes deadlocks: thread A holds m1 wants m2 while B holds m2 wants m1. Use `scoped_lock` or a fixed global order.
- **Forgetting to lock the read path** is still a race — `get()` above must lock even though it only reads, because another thread may be mid-write.
- **Returning a reference/pointer to guarded data** lets callers touch it after the guard unlocks; copy the value out instead.

## See also

- [[condition-variables]]
- [[concurrency-and-deadlocks]]
- [[atomics]]
