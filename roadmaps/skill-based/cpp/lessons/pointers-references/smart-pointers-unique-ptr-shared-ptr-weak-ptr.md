---
title: "Smart Pointers (`unique_ptr`, `shared_ptr`, `weak_ptr`)"
track: cpp
group: Pointers & References
tags: [cpp, smart-pointers]
prerequisites: [pointers, raii, move-semantics-rvalue-references]
see-also: [raii, dangling-pointers-memory-leaks, new-delete, pointers]
---

# Smart Pointers (`unique_ptr`, `shared_ptr`, `weak_ptr`)

Smart pointers are [[raii]] wrappers in `<memory>` that own a heap object and free it automatically, encoding *who owns what* in the type.

## Why it matters

They make leaks and double-frees largely a non-issue: ownership is explicit and destruction is deterministic, with no GC. The modern rule is **never write a naked `new`/`delete`** — use `std::make_unique` / `std::make_shared` — so resources clean up correctly even when exceptions unwind the stack. See [[new-delete]] and [[dangling-pointers-memory-leaks]].

## How it works

| Type | Ownership | `sizeof` (64-bit) | Copyable? | Overhead |
|---|---|---|---|---|
| `unique_ptr<T>` | sole | 8 B (1 ptr) | no, move-only | zero vs raw `T*` |
| `shared_ptr<T>` | shared (refcounted) | 16 B (2 ptrs) | yes | atomic refcount block |
| `weak_ptr<T>` | none (observer) | 16 B | yes | none until `lock()` |

- **`unique_ptr`** transfers ownership by move ([[move-semantics-rvalue-references]]); its deleter is part of the type, so it stays 8 bytes. Ideal default.
- **`shared_ptr`** keeps a control block with a **strong** and a **weak** count; the object dies when strong hits 0, the block when weak also hits 0. Refcount updates are atomic (thread-safe count, *not* thread-safe pointee).
- **`weak_ptr`** observes a `shared_ptr` without extending its life; call `.lock()` to get a `shared_ptr` (null if expired). It is the standard fix for reference cycles.

`make_shared` does one allocation for object + control block (vs two for `shared_ptr(new T)`); `make_unique` (C++14) also gives exception-safe construction.

## Example

A parent owns children with `shared_ptr`; each child points *back* with `weak_ptr` to avoid a cycle that would leak both:

```cpp
struct Node {
  std::shared_ptr<Node> next;   // owns
  std::weak_ptr<Node>   prev;   // observes — breaks the cycle
};
auto a = std::make_shared<Node>();
auto b = std::make_shared<Node>();
a->next = b;                    // strong: a keeps b alive
b->prev = a;                    // weak:   does NOT keep a alive
if (auto p = b->prev.lock())    // promote to shared_ptr to use safely
  /* a still alive */;
```

If `prev` were a `shared_ptr`, `a` and `b` would each hold the other at refcount 1 forever — a classic leak.

## Pitfalls

- **`shared_ptr` cycles leak.** Two objects referring to each other strongly never reach refcount 0 — break one edge with `weak_ptr`.
- **Don't build two `shared_ptr`s from the same raw pointer** (`shared_ptr<T>(p)` twice) — independent control blocks cause a double-free. Use `make_shared`, or `enable_shared_from_this`.
- **`shared_ptr` is not zero-cost:** atomic refcount churn hurts in hot/multithreaded paths. Default to `unique_ptr`; reach for `shared` only when ownership is genuinely shared.
- **The pointee isn't synchronized.** Concurrent writes to `*sp` still need a [[mutexes-locks|mutex]]; only the refcount is atomic.

## See also

- [[raii]]
- [[dangling-pointers-memory-leaks]]
- [[new-delete]]
