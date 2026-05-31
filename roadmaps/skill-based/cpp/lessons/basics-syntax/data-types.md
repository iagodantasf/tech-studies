---
title: Data Types
track: cpp
group: Basics / Syntax
tags: [cpp, types]
prerequisites: []
see-also: [type-modifiers, floating-point-representation]
---

# Data Types

C++ has a small set of built-in (fundamental) types — booleans, characters, integers, and floating-point — whose exact sizes are implementation-defined but constrained by the standard.

## Why it matters

Sizes are *not* fixed by the language, only lower-bounded, so code that assumes `long == 64 bits` breaks across platforms: on 64-bit Windows `long` is 32 bits (LLP64), on Linux it's 64 (LP64). Picking the right width drives memory footprint, cache behavior (see [[time-and-space-complexity]]), and whether arithmetic silently overflows. For portable, intent-revealing widths use the fixed-width aliases in `<cstdint>`.

## How it works

The standard guarantees a *minimum* width and a size ordering, not absolute bytes. Use `sizeof` and `<cstdint>` when exactness matters.

| Type | Typical size | Guaranteed min | Notes |
|---|---|---|---|
| `bool` | 1 B | — | `true`/`false`, not an int |
| `char` | 1 B | 1 B | signedness is impl-defined |
| `int` | 4 B | 2 B | natural word on most ABIs |
| `long` | 4–8 B | 4 B | 32 on LLP64, 64 on LP64 |
| `long long` | 8 B | 8 B | since C++11 |
| `float` | 4 B | — | IEEE-754 single |
| `double` | 8 B | — | IEEE-754 double |

`int8_t`/`uint32_t`/`int64_t` from `<cstdint>` give exact widths; `size_t` is the unsigned type for object sizes and indices. See [[floating-point-representation]] for `float`/`double` internals.

## Example

```cpp
static_assert(sizeof(int)   >= 2);   // standard floor, not 4
static_assert(sizeof(long)  >= sizeof(int));
std::int32_t  rgba = 0xFF00FF00;     // exactly 32 bits, portable
std::size_t   n    = vec.size();     // matches container index type
```

## Pitfalls

- **`char` signedness varies** by platform/compiler; use `signed char`/`unsigned char` for arithmetic on bytes.
- **`sizeof` returns `size_t`** (unsigned); `sizeof(a) - sizeof(b)` underflows to a huge value if `b > a`.
- **Floating-point is base-2**: `0.1 + 0.2 != 0.3`. Never compare floats with `==` — see [[floating-point-representation]].
- **Fixed-width types are optional**: `int64_t` need not exist on exotic targets; `int_least64_t` always does.

## See also

- [[type-modifiers]]
- [[floating-point-representation]]
