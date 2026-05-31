---
title: Move Semantics & Rvalue References
track: cpp
group: Memory Management
tags: [cpp, move-semantics]
prerequisites: [references, copy-vs-move]
see-also: [copy-vs-move, the-rule-of-0-3-5, smart-pointers-unique-ptr-shared-ptr-weak-ptr]
---

# Move Semantics & Rvalue References

An rvalue reference (`T&&`) binds to objects that are about to expire, letting a move steal their resources instead of copying — turning an O(n) deep copy into an O(1) pointer swap.

## Why it matters

Move semantics (C++11) is why returning a `std::vector` or passing a `std::string` by value is cheap: ownership of the heap buffer transfers instead of being duplicated. It is the engine behind `std::unique_ptr` (a move-only type), efficient container growth, and `std::move`/`std::forward`. Without it, every value-returning factory would copy megabytes.

## How it works

`T&` binds lvalues (named, persistent); `T&&` binds rvalues (temporaries, `std::move(x)`). A move constructor/assignment takes `T&&`, pilfers the source's internals, and leaves the source in a *valid but unspecified* state.

- `std::move(x)` is just a `static_cast<T&&>` — it **does not move**, it only enables a move overload to be picked.
- A `T&&` parameter is itself an **lvalue** (it has a name); pass it on with `std::move`/`std::forward`, or the next call copies.
- **Forwarding references**: `template<class T> f(T&&)` deduces `T&` for lvalues and `T` for rvalues; preserve the category with `std::forward<T>`.

| You have | Category | Move applies? |
|---|---|---|
| `make_x()` | rvalue (prvalue) | yes |
| `std::move(named)` | rvalue (xvalue) | yes |
| `named` lvalue | lvalue | no (copies) |
| `T&&` parameter | lvalue | no until you `std::move` it |

## Example

```cpp
std::vector<int> v = make_big();    // returned by value: moved (or elided), no deep copy
std::vector<int> w = std::move(v);  // steals v's buffer: O(1); v is now empty-but-valid

std::string s = "...";
sink(std::move(s));                 // s usable only after reassignment
```

A move ctor for a string copies 3 pointers (~24 bytes) regardless of the string's length; a copy would `memcpy` the whole payload.

## Pitfalls

- **Using a moved-from object's value** is a bug; it is valid (you may assign/destroy it) but its contents are unspecified.
- **`std::move` on a `const T`** silently copies — you can't steal from a const object, so the move overload is rejected.
- **`return std::move(local)`** disables copy elision (NRVO) and is usually *slower*; just `return local;`.
- **Forgetting `std::forward`** in a forwarding wrapper turns every rvalue into a copy.

## See also

- [[copy-vs-move]]
- [[the-rule-of-0-3-5]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
