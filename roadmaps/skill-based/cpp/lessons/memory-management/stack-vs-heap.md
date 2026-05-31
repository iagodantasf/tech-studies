---
title: Stack vs Heap
track: cpp
group: Memory Management
tags: [cpp, memory]
prerequisites: [pointers, data-types]
see-also: [new-delete, raii, smart-pointers-unique-ptr-shared-ptr-weak-ptr]
---

# Stack vs Heap

Every C++ object lives in one of two regions with very different cost and lifetime rules: the automatic *stack* or the dynamically managed *heap* (free store).

## Why it matters

The choice decides who frees the memory and how fast allocation is. A stack allocation is a single register adjustment (sub the stack pointer); a heap allocation calls into the allocator and may take hundreds of nanoseconds and lock a mutex. Choosing stack where possible is the cheapest performance win in C++, while careless heap use leaks, fragments, and dangles — see [[dangling-pointers-memory-leaks]].

## How it works

The stack is a contiguous, LIFO region per thread; each function call pushes a *frame* holding its locals and pops it on return. The heap is a global pool you carve up explicitly via [[new-delete]] (or `malloc`).

| Aspect | Stack | Heap |
|---|---|---|
| Allocation cost | ~1 instruction | ~50–500 ns, may lock |
| Lifetime | tied to scope (automatic) | until you `delete`/`free` |
| Size | small, fixed (often 1–8 MB) | large (GBs) |
| Fragmentation | none | yes |
| Who frees | compiler | you (or a smart pointer) |
| Failure mode | stack overflow | `bad_alloc` / null |

- Stack objects are destroyed in **reverse** construction order at scope exit — the basis of [[raii]].
- The heap survives the function that allocated it, so it is how you return owning data or build node-based structures ([[linked-lists]], [[trees]]).

## Example

```cpp
void f() {
  int a[1024];                 // stack: ~4 KB, freed at return
  auto p = std::make_unique<int[]>(1'000'000);  // heap: ~4 MB
}                              // a is popped; p's dtor frees the heap block
```

`a` costs nothing to allocate but a `1'000'000`-element array on the stack would blow the ~8 MB limit and crash — that data *must* go on the heap.

## Pitfalls

- **Returning the address of a local** dangles: the frame is popped before the caller reads it. Return by value or heap-allocate.
- **Deep [[recursion]] overflows the stack**; there is no `bad_alloc`, just a segfault. Bound recursion or go iterative.
- **Large locals (`std::array<T, N>` with big N)** silently eat the fixed stack; prefer `std::vector` (heap) for big buffers.
- **VLAs (`int a[n]`)** are not standard C++; use `std::vector` for runtime-sized arrays.

## See also

- [[new-delete]]
- [[raii]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
