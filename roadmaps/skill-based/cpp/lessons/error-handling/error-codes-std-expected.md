---
title: "Error Codes & `std::expected`"
track: cpp
group: Error Handling
tags: [cpp, expected]
prerequisites: [exceptions-try-catch-throw, utility-types-pair-tuple-optional-variant-any]
see-also: [exceptions-try-catch-throw, noexcept, utility-types-pair-tuple-optional-variant-any]
---

# Error Codes & `std::expected`

The value-based alternative to exceptions: a function returns *either* a result *or* an error, encoded in the return type rather than the control flow.

## Why it matters

Exceptions are unsuitable on hot paths, across ABI/C boundaries, or where the toolchain disables them (`-fno-exceptions` in many game/embedded/kernel codebases). The classic answer was `errno`/`std::error_code` out-parameters; C++23's `std::expected<T, E>` (header `<expected>`) makes the error *part of the value*, so it cannot be silently ignored and needs no `try`. It is a type-safe `T`-or-`E` that composes via monadic `.and_then`/`.transform`.

## How it works

`expected<T,E>` holds exactly one of a `T` (success) or an `E` (failure), like a purpose-built [[utility-types-pair-tuple-optional-variant-any|variant]]. Failures are wrapped in `std::unexpected<E>`.

| Approach | Cost on success | Ignorable? | Crosses ABI |
|---|---|---|---|
| Exceptions | zero | hard to ignore | no (unsafe) |
| `error_code` out-param | branch + write | yes (silently) | yes |
| `std::expected<T,E>` | branch | nodiscard-guarded | yes |

- Query with `e.has_value()` / `if (e)`; read success via `*e` / `e.value()` and failure via `e.error()`.
- `e.value()` on an error throws `bad_expected_access<E>`; `e.value_or(d)` and `e.error()` never throw.
- **Chaining**: `.and_then(f)` runs `f` only on success (and `f` itself returns an `expected`), `.transform(f)` maps the value, `.or_else(f)` handles the error — short-circuiting on the first failure with no `if` pyramid.
- Unlike `optional`, the failure carries *why* it failed (an `E`), not just "empty".

## Example

```cpp
std::expected<int, std::string> parse(std::string_view s) {
  int v{};
  auto [p, ec] = std::from_chars(s.data(), s.data() + s.size(), v);
  if (ec != std::errc{}) return std::unexpected("not a number");
  return v;                                  // success path
}

auto r = parse("21")
           .transform([](int n){ return n * 2; })   // 42, runs only if ok
           .value_or(-1);                            // -1 if any step failed
```

`parse("oops")` short-circuits: `transform` is skipped and `value_or` yields `-1` — no exception, no manual error check between steps.

## Pitfalls

- **Pre-C++23 / no `<expected>`:** reach for `tl::expected`, Abseil `StatusOr`, or Boost.Outcome — the API is near-identical.
- **`std::expected` is marked nodiscard, but a local you assign and forget still drops the error.** Discipline (or `.value()`) is needed; it is harder to ignore than `error_code`, not impossible.
- **`expected<void, E>`** is the form for "succeeds or fails with no payload" — don't reach for `expected<bool, E>`, which conflates the result with success.
- **Don't mix paradigms randomly:** a codebase that throws *and* returns `expected` for the same failure class forces callers to handle both. Pick one per layer; convert at the boundary.

## See also

- [[exceptions-try-catch-throw]]
- [[noexcept]]
- [[utility-types-pair-tuple-optional-variant-any]]
