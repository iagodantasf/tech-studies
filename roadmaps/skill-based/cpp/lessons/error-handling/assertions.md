---
title: Assertions
track: cpp
group: Error Handling
tags: [cpp, assertions]
prerequisites: [preprocessor-macros]
see-also: [error-codes-std-expected, exceptions-try-catch-throw, preprocessor-macros]
---

# Assertions

An assertion checks a condition that must hold if the program is correct, aborting (or failing to compile) when it doesn't — a tool for catching *bugs*, not handling *errors*.

## How it works

There are three distinct mechanisms, applying at different phases:

| Tool | Phase | On failure | Disabled by |
|---|---|---|---|
| `static_assert(c, msg)` | compile time | translation error | — (always on) |
| `assert(c)` | run time (debug) | `abort()` + message | `NDEBUG` |
| contracts (C++26) | run time | configurable handler | build mode |

- **`assert`** (from `<cassert>`) prints file/line/expression and calls `std::abort` (SIGABRT). When `NDEBUG` is defined — the convention for release builds — the macro expands to nothing, so the check **and its side effects vanish**.
- **`static_assert`** runs during compilation; ideal for template preconditions like `static_assert(sizeof(T) <= 8)`. It costs nothing at runtime and can never be disabled.
- A common idiom is `assert(cond && "human message")` — the string is always truthy, so it rides along into the diagnostic for free.
- Assertions document and enforce **invariants and preconditions**; they are not a substitute for validating untrusted input.

## Why it matters

Asserts encode the programmer's assumptions as executable checks, so a violated invariant fails *loudly at its source* instead of corrupting state and crashing somewhere unrelated. They are a debug-time safety net that compiles to zero in release, so you pay nothing in production. The contrast with [[exceptions-try-catch-throw]] and [[error-codes-std-expected]] is the core lesson: *errors* (bad input, missing file) are expected and recoverable; *bugs* (a null `this`, a broken invariant) are not — and assertions are for the latter.

## Example

```cpp
#include <cassert>

template <class T>
void sort_range(T* p, std::size_t n) {
  static_assert(std::is_arithmetic_v<T>);   // compile-time precondition
  assert(p != nullptr || n == 0);           // runtime precondition (debug only)
  // ...
}

// DANGER: side effect inside assert disappears under NDEBUG
assert(connect() == 0);                      // release build never connects!
```

In a release build (`-DNDEBUG`) the second `assert` is erased *entirely*, so `connect()` is never called — a classic disappearing-side-effect bug.

## Pitfalls

- **No side effects in `assert`.** Any work inside (mutation, I/O, `++i`) vanishes under `NDEBUG`, so debug and release diverge. Keep the expression a pure predicate.
- **Don't assert on user/network input.** That is a recoverable *error* — use exceptions or `std::expected`; an `abort()` is a denial-of-service, not validation.
- **Asserts and sanitizers complement, not replace, each other** — keep them enabled in tests/CI, where their abort surfaces bugs that release builds would hide.
- **`static_assert` needs a compile-time-constant condition**; a runtime value gives "expression is not constant", not a failed assert.

## See also

- [[exceptions-try-catch-throw]]
- [[error-codes-std-expected]]
- [[preprocessor-macros]]
