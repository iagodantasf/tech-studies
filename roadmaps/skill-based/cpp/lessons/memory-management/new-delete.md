---
title: "`new` / `delete`"
track: cpp
group: Memory Management
tags: [cpp, dynamic-allocation]
prerequisites: [stack-vs-heap, pointers]
see-also: [raii, smart-pointers-unique-ptr-shared-ptr-weak-ptr, exceptions-try-catch-throw]
---

# `new` / `delete`

`new` allocates raw storage on the heap *and* runs a constructor; `delete` runs the destructor *and* frees the storage — together they are the language-level free-store interface.

## Why it matters

`new`/`delete` are how dynamic objects are born and killed, and every mismatch is a bug class: leaks, double-frees, and the array/scalar mix-up are undefined behavior that sanitizers and Valgrind hunt for ([[sanitizers-asan-ubsan-tsan]]). Knowing the two-phase mechanics (allocate + construct) explains why exceptions mid-construction don't leak and why you should almost never call them by hand.

## How it works

`new T(args)` does two steps: call `operator new(sizeof(T))` to get storage, then construct `T` in place. `delete p` reverses it: run `~T()`, then `operator delete(p)`. Array forms track the element count separately.

| Expression | Pairs with | Notes |
|---|---|---|
| `new T` | `delete p` | single object |
| `new T[n]` | `delete[] p` | array; count stored by impl |
| `operator new(n)` | `operator delete(p)` | raw bytes, no ctor |
| `new (buf) T` | `p->~T()` | placement: construct in existing `buf` |

- Plain `new` throws `std::bad_alloc` on failure; `new (std::nothrow) T` returns `nullptr` instead.
- If `T`'s constructor throws, the storage is automatically freed — no leak from a half-built object. See [[exceptions-try-catch-throw]].

## Example

```cpp
Widget* w = new Widget(42);   // allocate + construct
// ... if anything here throws and returns early, w leaks ...
delete w;                     // destruct + free  (must run exactly once)

auto up = std::make_unique<Widget>(42);  // same, but leak-proof
```

The raw version leaks on any early return or exception between `new` and `delete`; the [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]] version cannot.

## Pitfalls

- **`new[]` with `delete` (or vice-versa) is UB** — the array cookie is mismatched. Always pair the forms.
- **Double `delete`** corrupts the allocator; set pointers to `nullptr` after delete, or just don't own raw.
- **Leaks on exception paths**: any code between `new` and `delete` that throws skips the `delete`.
- **Prefer `make_unique`/`make_shared`**: in modern C++ a bare `new` in normal code is a smell — wrap it in [[raii]].

## See also

- [[raii]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[stack-vs-heap]]
