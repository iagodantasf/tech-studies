---
title: "`std::span`"
track: cpp
group: Standard Library (STL)
tags: [cpp, span]
prerequisites: [containers-vector-array-list-deque, pointers, std-string-std-string-view]
see-also: [iterators, dangling-pointers-memory-leaks, ranges-c-20]
---

# `std::span`

`std::span<T>` (C++20) is a non-owning `{pointer, length}` view over a contiguous block of elements — the array analogue of [[std-string-std-string-view]].

## Why it matters

It kills the C-style `(T* ptr, size_t n)` parameter pair, where the size can be passed wrong or forgotten. One `span<int>` parameter accepts a `vector`, a `std::array`, a raw array, or a slice — with **no template, no copy, no allocation** — while carrying the length so `.size()` and bounds-checked iteration come for free. It is the right type for "a function that reads/writes a range it doesn't own."

## How it works

| Property | Value |
|---|---|
| Owns data? | no — view only |
| `sizeof` (dynamic extent) | 16 B (ptr + length) |
| `sizeof` (static extent `span<T,N>`) | 8 B (ptr only; N in type) |
| Element mutability | `span<T>` writes through; `span<const T>` is read-only |
| Requires | contiguous storage |

- **Mutable by default**: unlike `string_view` (always const chars), `span<int>` lets you *modify* the underlying elements. Use `span<const int>` for read-only.
- Two extents: **dynamic** (`std::span<T>`, length stored at runtime) or **static** (`std::span<T, 8>`, length baked into the type — zero size overhead and compile-time checkable).
- O(1) sub-views: `.first(n)`, `.last(n)`, `.subspan(off, n)` — pointer arithmetic only, no copy.
- It is a contiguous range, so it plugs straight into [[algorithms-algorithm]] and [[ranges-c-20]]; `.data()` *is* null-terminated only if the source was.

## Example

```cpp
// One signature serves vector, array, and C arrays — read or write:
double sum(std::span<const double> xs) {           // const view: read-only
    return std::accumulate(xs.begin(), xs.end(), 0.0);
}
void scale(std::span<double> xs, double k) {       // mutable view: writes through
    for (double& x : xs) x *= k;
}

std::vector<double> v{1,2,3,4};
std::array<double,3>  a{5,6,7};
double raw[] = {8,9};
sum(v); sum(a); sum(raw);          // all bind, zero copies
scale(std::span{v}.subspan(1,2), 10);  // scales v[1],v[2] only
```

The same three calls with a `vector<double>` parameter would each construct and free a temporary vector.

## Pitfalls

- **Dangling spans**: a `span` does not own or extend lifetime. Returning `span` to a local array, or holding one after the source `vector` *reallocates* (e.g. on `push_back`), dangles exactly like a raw pointer. See [[dangling-pointers-memory-leaks]].
- **Indexing is not bounds-checked** by default (`span[i]` is UB out of range) — use `.at()` (C++26) or check `.size()`; many stdlibs only check in hardened/debug builds.
- **Not null-terminated.** `span<char>` carries length, not a `\0`; don't hand `.data()` to C string APIs.
- **Mutability surprise**: `span<T>` (no `const`) silently allows callers to mutate your buffer — annotate read-only ranges as `span<const T>`.

## See also

- [[std-string-std-string-view]]
- [[iterators]]
- [[ranges-c-20]]
