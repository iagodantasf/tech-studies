---
title: "Coroutines (C++20)"
track: cpp
group: Concurrency
tags: [cpp, coroutines]
prerequisites: [lambda-expressions, move-semantics-rvalue-references]
see-also: [std-async-futures-promises, ranges-c-20, threads-std-thread, exceptions-try-catch-throw]
---

# Coroutines (C++20)

A coroutine is a function that can **suspend and later resume**, keeping its locals alive across the pause — enabling lazy generators and async code written in straight-line style.

## Why it matters

Coroutines turn callback- and state-machine-heavy code (async I/O, parsers, pull-based streams) into linear functions, with the compiler synthesizing the state machine. One suspended coroutine costs a small heap frame, not a thread or stack — so a server can hold *millions* of in-flight async operations where one-thread-per-connection would exhaust memory. They are the foundation of `std::generator` (C++23) and library executors like Asio's `awaitable`.

## How it works

Any function containing `co_await`, `co_yield`, or `co_return` **is** a coroutine. The compiler allocates a *coroutine frame* (usually on the heap) holding the parameters, locals, and a `promise_type` that you (or a library) define to drive behavior.

| Keyword | Meaning |
|---|---|
| `co_await expr` | suspend until the awaitable is ready, then resume |
| `co_yield v` | produce a value and suspend (generators) |
| `co_return v` | finish the coroutine, set the result |

- The return type's `promise_type` has hooks: `initial_suspend()`/`final_suspend()` (suspend at start/end?), `yield_value()`, `return_value()`/`return_void()`, and `unhandled_exception()`.
- An **awaitable** implements `await_ready()` (skip suspension?), `await_suspend(handle)` (schedule resumption), and `await_resume()` (the value `co_await` yields).
- A `std::coroutine_handle<>` is the resume/destroy token; whoever holds it controls when the coroutine continues. Suspension is *symmetric transfer* — resuming can tail-call into another coroutine without growing the stack.
- **Coroutines are a language mechanism, not a library.** C++20 ships almost no ready-made types (only `std::generator` arrived in C++23); production code uses a library (cppcoro, Asio, libunifex) or a hand-written `task`.

## Example

A lazy generator (the canonical hello-world):

```cpp
generator<int> fib() {                 // generator<> is a user/library type
  int a = 0, b = 1;
  while (true) {
    co_yield a;                        // emit and suspend here
    std::tie(a, b) = std::make_tuple(b, a + b);   // resumes from this point
  }
}
for (int x : fib()) {                  // pulls one value per iteration
  if (x > 50) break;                   // 0 1 1 2 3 5 8 13 21 34
}
```

Each loop iteration resumes `fib`, runs to the next `co_yield`, and suspends — only as many values as consumed are ever computed.

## Pitfalls

- **Dangling captures.** A coroutine that suspends must not hold references/`string_view`s to arguments that die before it resumes — capture by value into the frame. Coroutine lambdas that capture by reference are a classic use-after-free.
- **Heap allocation per frame.** Each coroutine may allocate; in hot paths rely on the compiler's HALO elision (not guaranteed) or a custom allocator via `promise_type`.
- **Bare standard library.** Without a `task`/`generator` type you must write `promise_type` yourself — easy to get the suspend points or lifetime wrong.
- **`co_await` does not create parallelism.** Suspension yields control back to the scheduler/caller; whether work runs concurrently depends entirely on the executor behind the awaitable.

## See also

- [[std-async-futures-promises]]
- [[ranges-c-20]]
- [[threads-std-thread]]
