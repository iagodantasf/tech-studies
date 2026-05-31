---
title: "`constexpr` Functions"
track: cpp
group: Functions
tags: [cpp, constexpr]
prerequisites: [declaring-defining-functions]
see-also: [inline-functions, template-metaprogramming]
---

# `constexpr` Functions

A `constexpr` function *may* run at compile time when its arguments are constant expressions, folding work into the binary — and otherwise runs as an ordinary function at runtime.

## Why it matters

`constexpr` is the modern, readable replacement for template metaprogramming and macros: compute lookup tables, validate config, or size arrays with normal-looking code that the compiler evaluates before the program starts. Moving work to compile time removes it from every run and lets results be used where the language *requires* a constant — array bounds, `template` arguments, `case` labels. Since C++20 it spans nearly the whole language, including loops, `if`, and even allocation.

## How it works

- `constexpr` means "**usable** in a constant expression," not "always compile-time." Pass runtime args and it runs at runtime.
- Force compile-time evaluation with `constexpr auto x = f(...);` or, in C++20, mark the function `consteval` ("immediate" — *must* be compile-time).
- A `constexpr` function is **implicitly [[inline-functions|inline]]**, so it's safe to define in a header.
- `constinit` (C++20) guarantees an object is constant-initialized without forcing it `const`.

| Standard | What `constexpr` functions gained |
|---|---|
| C++11 | single `return`, no loops/locals |
| C++14 | loops, locals, multiple statements, mutations |
| C++20 | `try`/`catch`, virtual calls, `new`/`delete`, `std::vector`/`std::string` |
| C++23 | `constexpr` `std::cmath`, relaxed `goto`/labels |

## Example

```cpp
constexpr int factorial(int n) {
  int r = 1;
  for (int i = 2; i <= n; ++i) r *= i;   // loops OK since C++14
  return r;
}
constexpr int f5 = factorial(5);   // computed at compile time -> 120
int arr[factorial(4)];             // size 24, a constant expression
int x = factorial(read_int());     // same function, now runtime
```

`f5` and the array bound are baked into the binary; the last line runs the loop at runtime.

## Pitfalls

- **`constexpr` is a promise, not a guarantee of compile-time**: assign to a `constexpr` variable (or use `consteval`) if you truly need it folded.
- A function that *can't* be constant-evaluated for the given args **silently falls back to runtime** — no error unless used in a constant context.
- **C++11 bodies are severely limited** (effectively one `return`); code that needs loops requires `-std=c++14` or later.
- Calling a **non-`constexpr` function** (e.g. most I/O, `rand()`) inside makes the call non-constant.

## See also

- [[inline-functions]]
- [[template-metaprogramming]]
