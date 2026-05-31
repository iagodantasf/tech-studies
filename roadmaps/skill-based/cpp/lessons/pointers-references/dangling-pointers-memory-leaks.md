---
title: Dangling Pointers & Memory Leaks
track: cpp
group: Pointers & References
tags: [cpp, memory-safety]
prerequisites: [pointers, new-delete, object-lifetime]
see-also: [smart-pointers-unique-ptr-shared-ptr-weak-ptr, raii, sanitizers-asan-ubsan-tsan, profilers-perf-valgrind]
---

# Dangling Pointers & Memory Leaks

These are the two opposite failures of manual memory: a **dangling** pointer outlives its object (freed too early), a **leak** keeps an object alive with no pointer (freed too late, or never).

## Why it matters

Use-after-free and double-free are among the most exploited security bugs in C/C++ — Microsoft and Chromium both attribute roughly 70% of their CVEs to memory-safety errors, dangling pointers prominent among them. Leaks bleed long-running services (servers, daemons) until they OOM. Both are *undefined behavior* or silent resource exhaustion, not clean crashes.

## How it works

A pointer dangles whenever its pointee's [[object-lifetime]] ends but the pointer keeps the stale address:

| Cause | Mechanism |
|---|---|
| `delete p` then use `*p` | heap freed, address reused later — use-after-free |
| `delete p` twice | double-free corrupts allocator metadata |
| return `&local` | stack frame gone on return |
| iterator after `vector` realloc | `push_back` moved the buffer, old pointers stale |

A leak is the mirror image: every `new` needs exactly one matching `delete` on every path. Throw an exception or hit an early `return` between `new` and `delete` and the object leaks — the core reason raw [[new-delete]] is fragile and [[raii]] exists.

```text
dangling:  [obj freed] ......... p ──▶ (dead memory)   read = UB
leak:      p destroyed ......... [obj] ──▶ (no owner)  never freed
```

## Example

A textbook leak-on-throw, and its RAII fix:

```cpp
void bad() {
  Widget* w = new Widget;
  mayThrow();          // throws → delete below is skipped → LEAK
  delete w;
}
void good() {
  auto w = std::make_unique<Widget>();  // freed by ~unique_ptr on any exit
  mayThrow();                           // unwinding still releases w
}
```

Detection tooling: AddressSanitizer (`-fsanitize=address`) flags use-after-free and double-free at runtime; Valgrind/ASan leak-check reports unfreed blocks — see [[sanitizers-asan-ubsan-tsan]] and [[profilers-perf-valgrind]].

## Pitfalls

- **Iterator/pointer invalidation:** `vector::push_back` may reallocate, dangling every outstanding pointer, reference, and iterator into it — re-acquire after mutation.
- **Returning a reference/pointer to a local** or to a `const&`-bound temporary dangles immediately — see [[references]].
- **Mismatched delete:** `new[]` must pair with `delete[]`, plain `new` with `delete`; crossing them is UB. Smart pointers pick the right one for you.
- **Self-reset:** `p->reset()` or `delete this->member` while iterating logic still holds a copy of the old pointer is a stealthy use-after-free.

## See also

- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[raii]]
- [[sanitizers-asan-ubsan-tsan]]
