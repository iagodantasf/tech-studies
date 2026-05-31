---
title: "`std::async` / Futures & Promises"
track: cpp
group: Concurrency
tags: [cpp, futures]
prerequisites: [threads-std-thread, lambda-expressions]
see-also: [threads-std-thread, condition-variables, exceptions-try-catch-throw, mutexes-locks]
---

# `std::async` / Futures & Promises

`<future>` gives a one-shot channel for a result computed elsewhere: a `std::future` reads the value, a `std::promise` (or `std::async`) produces it — with exceptions propagated across the thread boundary.

## Why it matters

This is the high-level "run this and give me the answer later" model: no manual mutex/condition-variable plumbing for a single result, and an exception thrown in the worker is re-thrown when you call `get()`. It is the cleanest way to fan out independent tasks and collect results, and it sidesteps the [[threads-std-thread|`std::thread` join footguns]] for compute-and-return work.

## How it works

A *shared state* connects the two ends: the producer sets a value or exception, the consumer's `future::get()` blocks until it is ready, then returns it **once** (get is single-use).

| Producer | Pairs with | Notes |
|---|---|---|
| `std::async(policy, f, args...)` | returned `future` | runs `f`, captures return/exception |
| `std::promise<T>` | `p.get_future()` | manual `set_value` / `set_exception` |
| `std::packaged_task<R(Args)>` | `t.get_future()` | wraps a callable for a thread/pool |

- `std::async` takes a launch policy: `launch::async` forces a new thread; `launch::deferred` runs lazily on the *calling* thread at `get()`; the **default `async|deferred` lets the implementation choose** — so it may never run in parallel.
- `future::get()` blocks, moves the result out, and re-throws any stored exception. `wait_for`/`wait_until` poll without consuming; `valid()` is false after `get()`.
- A `std::promise` is the explicit form: a worker holds it and calls `set_value(x)` or `set_exception(...)`; the other side already holds the matching `future`.
- For multiple consumers of one result, convert with `future::share()` into a `std::shared_future`.

## Example

```cpp
std::future<int> f = std::async(std::launch::async,
                                []{ return heavy(); });   // forced onto a thread
// ... do other work meanwhile ...
int result = f.get();                                     // blocks; rethrows if heavy() threw
```

Manual promise hand-off across threads:

```cpp
std::promise<int> p;
std::future<int> f = p.get_future();
std::thread t([&]{ p.set_value(compute()); });            // producer end
int r = f.get();                                          // consumer end, blocks
t.join();
```

## Pitfalls

- **The `std::async` return value's destructor blocks.** A discarded `std::async(...)` (default/async policy) future joins in its destructor — so `async(f); async(g);` runs *sequentially*, not in parallel. Keep the futures named and alive.
- **Default launch policy may defer.** Without `launch::async`, the task can run lazily at `get()` on your thread; if you never call `get()`/`wait()`, it may never run at all.
- **`get()` is one-shot.** Calling it twice on a `future` is UB; use `shared_future` for multiple reads.
- **Broken promise:** destroying a `std::promise` without setting it makes the waiting `get()` throw `std::future_error{broken_promise}` — always set a value or exception on every path.

## See also

- [[threads-std-thread]]
- [[exceptions-try-catch-throw]]
- [[condition-variables]]
