---
title: "Threads (`std::thread`)"
track: cpp
group: Concurrency
tags: [cpp, threads]
prerequisites: [lambda-expressions, move-semantics-rvalue-references]
see-also: [mutexes-locks, std-async-futures-promises, memory-model-data-races, operating-systems]
---

# Threads (`std::thread`)

`std::thread` (C++11, `<thread>`) is a portable, move-only handle to one OS thread of execution that runs a callable concurrently with the rest of the program.

## Why it matters

It is the lowest-level standard primitive for true parallelism — one `std::thread` maps to one kernel thread (a pthread on Linux), so CPU-bound work can use all cores. Everything higher (`std::async`, thread pools, `std::jthread`) is built on this model, and the lifetime rules here are the source of the most common "program calls `terminate()`" crashes.

## How it works

A thread starts running *immediately* on construction; you pass a callable plus arguments, which are **copied/moved into the thread** (decay-copied), not passed by reference unless you wrap them.

| Operation | Effect |
|---|---|
| `t.join()` | block until the thread finishes |
| `t.detach()` | sever the handle; thread runs on independently |
| `t.joinable()` | true until joined or detached |
| `std::thread::hardware_concurrency()` | hint: core count (may return 0) |
| `t.get_id()` | unique `std::thread::id` while running |

- Every thread **must be joined or detached before its destructor runs**, or the destructor calls `std::terminate()`. This includes the exception path — an early `throw` past a not-yet-joined `t` kills the process.
- Arguments are stored by value: to pass by reference you need `std::ref(x)`; a raw `T&` parameter alone will not bind.
- `std::thread` is move-only (transfer ownership with `std::move`); copying is deleted. Use [[move-semantics-rvalue-references]] to store them in a `std::vector`.
- **C++20 `std::jthread`** fixes the footgun: its destructor auto-joins and it carries a `std::stop_token` for cooperative cancellation.

## Example

```cpp
void worker(int id, int& out) { out = id * id; }   // takes a reference

int main() {
  int result = 0;
  std::thread t(worker, 7, std::ref(result));      // std::ref is required
  // ... do other work concurrently ...
  t.join();                                         // result now 49; safe to read
  std::cout << result;
}                                                   // forgetting join() -> terminate()
```

Spawning N threads over a vector: reserve, `emplace_back(fn, i)`, then a second loop calls `join()` on each — joining inside the spawn loop would serialize them.

## Pitfalls

- **Not joining = `terminate()`.** A throw between construction and `join()` destroys a joinable thread and aborts the program. Prefer `std::jthread` or an RAII joiner.
- **Reference arguments silently copy.** Without `std::ref`/`std::cref`, the thread gets its own copy and your writes vanish; with `std::ref` to a stack local that ends first, you get a [[dangling-pointers-memory-leaks|dangling]] reference.
- **`detach()` then exit** leaves the thread touching freed globals/statics during shutdown — a frequent crash. Detach only truly fire-and-forget work.
- **Oversubscription:** spawning far more threads than cores adds context-switch and cache-thrash overhead; size pools near `hardware_concurrency()`.

## See also

- [[mutexes-locks]]
- [[std-async-futures-promises]]
- [[memory-model-data-races]]
