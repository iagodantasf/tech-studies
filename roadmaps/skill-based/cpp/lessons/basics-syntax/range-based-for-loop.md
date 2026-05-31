---
title: Range-based for Loop
track: cpp
group: Basics / Syntax
tags: [cpp, control-flow]
prerequisites: [loops-for-while-do-while]
see-also: [iterators, containers-vector-array-list-deque]
---

# Range-based for Loop

`for (decl : range)` (C++11) iterates any object exposing `begin()`/`end()` iterators, hiding the index arithmetic and the off-by-one and invalidation traps of a hand-written loop.

## Why it matters

It's the default loop for "visit every element": shorter, harder to get wrong, and it works uniformly over arrays, [[containers-vector-array-list-deque|STL containers]], `std::initializer_list`, and anything range-conforming. With `const auto&` it iterates without copying; with [[ranges-c-20|ranges]] views you can filter and transform lazily. The 90% case of [[loops-for-while-do-while|raw loops]] collapses into it.

## How it works

The compiler rewrites `for (auto x : r)` to roughly:

```text
auto&& __r = r;
for (auto __it = begin(__r); __it != end(__r); ++__it) {
    auto x = *__it;        // your declaration, bound each iteration
    ...
}
```

The declaration's form decides copy vs reference vs mutation:

| Declaration | Effect | When |
|---|---|---|
| `auto x` | copy each element | cheap values, want a mutable local |
| `const auto& x` | no copy, read-only | default for non-trivial elements |
| `auto& x` | reference, mutate in place | modifying the container |
| `auto&& x` | forwarding | generic code, proxy elements |

C++20 adds an **init-statement**: `for (auto v = make(); auto& e : v)` keeps the temporary alive for the whole loop.

## Example

```cpp
std::vector<std::string> names = load();
for (const auto& n : names) print(n);   // zero copies
for (auto& n : names) n += "!";         // mutate in place

for (auto [k, v] : counts)              // structured binding over a map
    total += v;
```

## Pitfalls

- **The dangling-temporary trap** (pre-C++23): `for (auto x : f().items())` where `f()` returns by value — the temporary's lifetime ends before the loop in some cases; C++23 fixed the common form, but bind to a named variable to be safe.
- **`auto x` silently copies** every element; large structs make this `O(n)` extra cost — prefer `const auto&`.
- **Modifying the container's size** (push/erase) during iteration invalidates the underlying iterators — UB, just like a manual loop.
- **`std::vector<bool>`** yields a proxy, so `auto&` won't bind a real `bool&`; use `auto&&`.

## See also

- [[iterators]]
- [[loops-for-while-do-while]]
