---
title: Lambda Expressions
track: cpp
group: Functions
tags: [cpp, lambdas]
prerequisites: [declaring-defining-functions, references]
see-also: [function-objects-std-function, algorithms-algorithm]
---

# Lambda Expressions

A lambda is syntax for an anonymous *function object* — the compiler generates a unique unnamed class with `operator()` and the captured state as members.

## Why it matters

Lambdas are the connective tissue of the modern STL: every `std::sort`, `std::for_each`, or `std::ranges` call takes one as a predicate, inlined with zero call overhead. They replaced the verbose pre-C++11 functor boilerplate and made capturing local state trivial. Understanding that a lambda is *a class instance*, not a function pointer, explains why captures cost storage and why a capturing lambda won't convert to a plain function pointer.

## How it works

`[captures](params) specifiers -> ret { body }`. Captures decide what local state is stored:

| Capture | Meaning | Lifetime risk |
|---|---|---|
| `[x]` | copy of `x` | safe; snapshot |
| `[&x]` | reference to `x` | dangles if lambda outlives `x` |
| `[=]` | copy all used | safe but can copy a lot |
| `[&]` | reference all used | easy to dangle |
| `[this]` | the enclosing object's `this` | dangles if object dies |
| `[x = expr]` | init-capture (C++14) | move-in: `[p = std::move(ptr)]` |

- A capture-less lambda **converts to a function pointer**; a capturing one does not — type-erase it with [[function-objects-std-function]].
- `mutable` lets the body modify *by-copy* captures. `auto` params (C++14) make it a *generic* lambda (a template `operator()`).
- Each lambda has a **distinct, unnamable type**; store with `auto` or `std::function`.

## Example

```cpp
std::vector<int> v{5, 2, 8, 1};
int threshold = 4;
auto n = std::count_if(v.begin(), v.end(),
                       [threshold](int x){ return x > threshold; });  // n == 2
```

The lambda becomes a tiny struct holding one `int threshold`; `count_if` inlines its `operator()`, so this is as fast as a hand-written loop.

## Pitfalls

- **`[&]` outliving its scope** is the #1 lambda bug: returning or storing a `[&]`-capturing lambda dangles. Prefer explicit captures.
- **`[=]` does NOT copy members** — it captures `this` by pointer, so a "copy-all" lambda stored on a heap object can still dangle. Use `[*this]` (C++17) to copy the object.
- **Forgetting `mutable`** makes by-value captures `const`; mutating them won't compile.
- A **capturing lambda assigned to a function pointer** fails to compile — the conversion exists only for captureless ones.

## See also

- [[function-objects-std-function]]
- [[algorithms-algorithm]]
