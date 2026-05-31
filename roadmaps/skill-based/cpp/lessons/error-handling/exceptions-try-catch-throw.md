---
title: Exceptions (try / catch / throw)
track: cpp
group: Error Handling
tags: [cpp, exceptions]
prerequisites: [raii, constructors-destructors]
see-also: [exception-safety-guarantees, noexcept, error-codes-std-expected, raii]
---

# Exceptions (try / catch / throw)

Exceptions transfer control from a `throw` to the nearest matching `catch`, unwinding the stack and destroying every fully-constructed local along the way.

## Why it matters

Exceptions separate the error path from the happy path, so a deep call chain need not thread a status code through every return. Constructors have no return value — exceptions are the *only* way they can report failure — and the STL (e.g. `vector::at`, `new`, `std::stoi`) relies on them. They make [[raii]] the backbone of cleanup: when an exception propagates, destructors run automatically, so locks release and memory frees with zero boilerplate.

## How it works

`throw x` copies/moves `x` into an implementation-managed region, then **unwinds**: each stack frame between the throw and the handler runs its locals' destructors in reverse order before being discarded.

| Construct | Meaning |
|---|---|
| `throw e;` | start propagation with object `e` |
| `catch (const T& e)` | handle by reference (the norm) |
| `catch (...)` | catch-all; cannot inspect the object |
| `throw;` (bare, in catch) | rethrow the *current* exception |

- Handlers are tried **top to bottom**, first-match-wins — order base classes *after* derived, or the base catches everything.
- Matching ignores conversions except base-from-derived; an `int` thrown is **not** caught by `catch (long)`.
- The "zero-cost" / table-based model (Itanium ABI) adds **no runtime cost on the non-throwing path**; cost is paid only when an exception is actually thrown.
- Throw by value, catch by `const&` to avoid slicing and extra copies. Prefer types deriving from `std::exception`.

## Example

```cpp
struct Conn { ~Conn() { close(); } };          // RAII: always closed

double parse(const std::string& s) {
  return std::stod(s);                          // throws std::invalid_argument
}

try {
  Conn c;                                       // c.~Conn() runs during unwind
  auto v = parse("oops");
} catch (const std::invalid_argument& e) {
  log(e.what());                                // "stod" -> here
} catch (const std::exception& e) {             // base last
  log(e.what());
}
```

If `parse` throws, `c`'s destructor still runs *before* control reaches the handler — the connection is never leaked.

## Pitfalls

- **Never let a destructor throw.** During unwinding a second escaping exception calls `std::terminate`. Mark destructors `noexcept` (the default) and swallow internally — see [[noexcept]].
- **Slicing on catch-by-value:** `catch (std::exception e)` copies just the base subobject, losing the derived type and `what()`. Catch by `const&`.
- **`catch` order:** a `catch (const std::exception&)` placed before a derived handler shadows it; the derived block becomes dead code (some compilers warn).
- **Throwing across a binary boundary** (DLL/`.so`) or out of a C callback is UB; an exception that escapes `main` or a `noexcept` function calls `terminate`.

## See also

- [[exception-safety-guarantees]]
- [[noexcept]]
- [[raii]]
