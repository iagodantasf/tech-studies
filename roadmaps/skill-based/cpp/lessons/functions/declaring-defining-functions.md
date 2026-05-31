---
title: Declaring & Defining Functions
track: cpp
group: Functions
tags: [cpp, functions]
prerequisites: [data-types]
see-also: [header-source-separation, parameters-and-arguments]
---

# Declaring & Defining Functions

A *declaration* names a function and its type so the compiler can call it; a *definition* supplies the body — and the one-definition rule (ODR) governs how many of each may exist.

## Why it matters

C++ compiles one translation unit at a time, so calling a function in `b.cpp` that lives in `a.cpp` only works if `b.cpp` first sees a declaration. This is the entire reason headers exist: the declaration goes in the `.hpp`, the definition in the `.cpp`. Get the split wrong and you hit "undefined reference" (linker) or "use of undeclared identifier" (compiler) — two errors at two different phases. See [[header-source-separation]].

## How it works

A function's *signature* is its name plus parameter types (return type is **not** part of it for overload resolution):

| Term | Includes | Example |
|---|---|---|
| Declaration | return type, name, param types, `;` | `int f(double, char);` |
| Definition | declaration + `{ ... }` body | `int f(double d, char c) { ... }` |
| Signature | name + param types only | `f(double, char)` |

- A TU may **declare** a function many times but **define** it at most once (ODR).
- Across the whole program, a non-`inline` function has exactly one definition.
- Trailing-return syntax `auto f() -> int` aids templates where the return type depends on parameters.
- Forward declarations break circular dependencies and cut compile time by hiding bodies.

## Example

```cpp
// math.hpp
int add(int a, int b);          // declaration only

// math.cpp
int add(int a, int b) { return a + b; }   // the one definition

// main.cpp
#include "math.hpp"
int main() { return add(2, 3); }  // sees declaration; linker finds definition
```

Omit `math.cpp` from the build and it compiles fine but fails at link with `undefined reference to add(int, int)`.

## Pitfalls

- **Defining a function in a header** without `inline` and including it in 2+ TUs is an ODR violation — usually a "multiple definition" link error.
- **Default arguments belong on the declaration**, not repeated on the definition; restating them is an error. See [[default-arguments]].
- A **mismatched signature** (e.g. `add(long,long)` in the `.cpp`) silently creates a *different* function and links fail for the one you meant.
- `int f();` in C++ means "takes no args"; the `int f(void)` C-ism is redundant here.

## See also

- [[header-source-separation]]
- [[parameters-and-arguments]]
