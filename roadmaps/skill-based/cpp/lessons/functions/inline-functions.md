---
title: Inline Functions
track: cpp
group: Functions
tags: [cpp, inline]
prerequisites: [declaring-defining-functions]
see-also: [header-source-separation, constexpr-functions]
---

# Inline Functions

The `inline` keyword's *real* job is an ODR exemption — it lets a function be defined in a header and included in many translation units — while "inlining" the call is a separate optimizer decision.

## Why it matters

Most engineers think `inline` means "paste the body to avoid a call." It barely does in modern compilers — the optimizer inlines based on cost heuristics regardless of the keyword, and at `-O2` happily inlines functions you never marked. What `inline` *guarantees* is linkage: defining a function in a header without it causes "multiple definition" link errors. Since C++17, `inline` also applies to variables, solving the header-only global problem.

## How it works

- `inline` permits **multiple identical definitions** across TUs; the linker merges them into one. All definitions must be token-for-token the same (ODR).
- It is a **hint, not a command**, for actual inline expansion; the compiler may ignore it or inline non-`inline` functions.
- Functions **defined inside a class body** are implicitly `inline`.
- `constexpr` functions are implicitly `inline` too — see [[constexpr-functions]].
- Force/forbid expansion with compiler attributes, not the keyword: `gnu::always_inline`, `__forceinline` (MSVC), `gnu::noinline`.

| Mark | ODR exemption | Forces expansion |
|---|---|---|
| `inline` | yes | no (hint only) |
| `gnu::always_inline` | no | yes (best effort) |
| nothing, at `-O2` | no | optimizer decides |

## Example

```cpp
// util.hpp — header-only, included everywhere
inline int square(int x) { return x * x; }   // OK in N TUs
inline int counter = 0;                       // C++17 inline variable, one shared instance
```

Drop the `inline` on `square` and include `util.hpp` in two `.cpp` files: link fails with `multiple definition of square(int)`.

## Pitfalls

- **Believing `inline` controls performance** — measure; the optimizer already inlines hot small calls without it, and over-inlining can *hurt* via instruction-cache pressure.
- **ODR mismatch**: two TUs with subtly different `inline` bodies (e.g. behind different `#define`s) is UB the linker won't catch.
- **Recursive or large functions** can't be expanded usefully; the keyword is then pure linkage.
- Marking everything `gnu::always_inline` bloats code size and can slow the program down.

## See also

- [[header-source-separation]]
- [[constexpr-functions]]
