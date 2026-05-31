---
title: Containers (vector, array, list, deque)
track: cpp
group: Standard Library (STL)
tags: [cpp, containers]
prerequisites: [arrays-and-dynamic-arrays, raii, move-semantics-rvalue-references]
see-also: [associative-containers-map-set-unordered-map, iterators, std-span]
---

# Containers (vector, array, list, deque)

The sequence containers are RAII-owning, value-semantic data structures that store elements in a defined order, each trading layout for different operation costs.

## Why it matters

Picking the wrong sequence container is one of the most common silent performance bugs in C++. `vector` is the right default ~90% of the time because contiguous memory means cache locality and trivial interop with C APIs and [[std-span]]; choosing `list` "because we insert a lot" usually *loses* to `vector` once cache misses are counted. Each container owns its storage and frees it deterministically ([[raii]]), so there are no leaks even on exception unwind.

## How it works

| Container | Layout | Random access | Push back | Insert middle | Iterator/ref stability |
|---|---|---|---|---|---|
| `array<T,N>` | contiguous, stack, fixed N | O(1) | n/a | n/a | always stable |
| `vector<T>` | contiguous, heap | O(1) | O(1) amortized | O(n) | invalidated on realloc |
| `deque<T>` | segmented blocks | O(1) | O(1) | O(n) | refs stable on end-ops |
| `list<T>` | doubly-linked nodes | O(n) | O(1) | O(1) given iterator | always stable |

- `vector` grows by a factor (≈2 on libstdc++/libc++, 1.5 on MSVC); a realloc moves every element and **invalidates all iterators/pointers**. `reserve(n)` up front avoids repeated copies. See [[arrays-and-dynamic-arrays]].
- `deque` is a ring of fixed blocks: `push_front`/`push_back` are O(1) and never invalidate *references* to existing elements (iterators may still move). It is the default backing for `std::stack`/`std::queue`.
- `list` (and `forward_list`) shine only when you hold iterators and splice nodes, or need permanent element addresses; the per-node heap alloc and pointer-chasing cost dominate otherwise.
- Modern growth uses [[move-semantics-rvalue-references]]: a `noexcept` move ctor lets `vector` *move* elements on realloc instead of copying.

## Example

```cpp
std::vector<int> v;
v.reserve(1000);              // one allocation, no later reallocs
for (int i = 0; i < 1000; ++i) v.push_back(i);
int* p = &v[0];               // valid...
v.push_back(1001);            // capacity was 1000 -> realloc -> p DANGLES

std::array<double,3> a{1,2,3}; // no heap, sizeof(a)==24, usable in constexpr
```

A 1M-element traversal: `vector` ~1x time, `list` often 5-20x slower purely from cache misses, despite identical big-O.

## Pitfalls

- **`push_back` invalidates** all iterators/pointers/references on reallocation. Cache indices, not pointers, or `reserve` first.
- **`std::vector<bool>` is a bit-packed specialization**, not a container of `bool`; `operator[]` returns a proxy, so `&v[i]`, `auto& b = v[i]`, and many algorithms misbehave. Use `vector<char>` or `std::bitset`.
- **Iterating while erasing** from a `vector` invalidates the loop — use the `it = v.erase(it)` return value, or the erase-remove idiom / C++20 `std::erase_if`.
- **Defaulting to `list`** for "lots of inserts" is usually wrong; benchmark against `vector` before assuming linked nodes win.

## See also

- [[associative-containers-map-set-unordered-map]]
- [[iterators]]
- [[std-span]]
