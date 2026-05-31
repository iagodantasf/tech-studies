---
title: "Memory Model & Data Races"
track: cpp
group: Concurrency
tags: [cpp, memory-model]
prerequisites: [atomics, mutexes-locks]
see-also: [atomics, mutexes-locks, sanitizers-asan-ubsan-tsan, concurrency-and-deadlocks]
---

# Memory Model & Data Races

The C++11 memory model defines exactly when one thread's writes become visible to another, and declares any unsynchronized conflicting access a **data race** — undefined behavior.

## Why it matters

Before C++11 the language had *no* threading semantics; correctness depended on the compiler and CPU. The standardized model is the contract every concurrency primitive rests on: it tells you which programs are well-defined and lets the compiler and hardware reorder freely otherwise. Misunderstanding it produces bugs that vanish under a debugger and only appear under load on one CPU vendor.

## How it works

A **data race** occurs when two threads access the same memory location, at least one writes, and the accesses are *not ordered* by any synchronization — that program has no defined behavior at all (not "garbage value", but UB).

- **Sequenced-before** orders operations in one thread; **synchronizes-with** links a release on one thread to an acquire on another; together they form **happens-before**. If two conflicting accesses have *no* happens-before relation, it's a race.
- Synchronization edges come from: locking/unlocking a [[mutexes-locks|mutex]], release/acquire [[atomics|atomic]] pairs, thread `join`, and `std::async`/`future` completion.
- The default atomic order `seq_cst` gives a single total order all threads agree on — easiest to reason about; `relaxed` gives atomicity with *no* ordering of surrounding memory.

| Concept | Meaning |
|---|---|
| sequenced-before | program order within one thread |
| synchronizes-with | release store ↔ acquire load of same atomic |
| happens-before | transitive union of the two above |
| data race | conflicting access with no happens-before → UB |

- Compilers exploit "no race" to optimize: a loop reading a non-atomic flag can be hoisted so the thread **never sees the update** — a `while(!done){}` on a plain `bool` can spin forever even after `done = true`.

## Example

```cpp
bool done = false; int x = 0;             // both plain, non-atomic

// thread A                               // thread B
x = 1;                                    while (!done) {}   // may NEVER exit
done = true;                              std::cout << x;    // and x is a race -> UB
```

This has **two** problems: `done` may be cached in a register so B loops forever, and even if B exits, the read of `x` races with A's write. Making `done` a `std::atomic<bool>` with release/acquire fixes both — the acquire-load also makes `x = 1` visible.

## Pitfalls

- **"It worked on my machine" is meaningless** for races — x86's strong ordering hides bugs that ARM/PowerPC expose. Test under [[sanitizers-asan-ubsan-tsan|TSan]].
- **A data race is UB, not a stale read.** The compiler may delete code, fuse loads, or invent writes; reasoning about "which value wins" is invalid.
- **`volatile` provides no thread synchronization** — it forbids the compiler's elision but adds no happens-before and no atomicity. Use `std::atomic`.
- **Word-tearing / false sharing:** unrelated atomics on the same 64-byte cache line ping-pong between cores; pad hot per-thread data to a cache line.

## See also

- [[atomics]]
- [[mutexes-locks]]
- [[sanitizers-asan-ubsan-tsan]]
