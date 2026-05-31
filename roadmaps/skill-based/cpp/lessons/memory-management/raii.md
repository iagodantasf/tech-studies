---
title: RAII
track: cpp
group: Memory Management
tags: [cpp, raii]
prerequisites: [object-lifetime, constructors-destructors]
see-also: [smart-pointers-unique-ptr-shared-ptr-weak-ptr, new-delete, exception-safety-guarantees]
---

# RAII

Resource Acquisition Is Initialization: bind a resource (memory, file, lock, socket) to the lifetime of a stack object so its destructor releases the resource automatically.

## Why it matters

RAII is *the* C++ answer to "who cleans up?" and it makes correctness automatic even across early returns and exceptions — the destructor runs no matter how the scope exits ([[exception-safety-guarantees]]). It is why idiomatic modern C++ rarely needs `try/finally`: the standard library's smart pointers, `std::lock_guard`, `std::fstream`, and `std::vector` are all RAII wrappers that turn manual [[new-delete]] into automatic cleanup.

## How it works

A guard object acquires in its constructor and releases in its destructor. Because the compiler guarantees [[object-lifetime]] semantics — destructors fire at scope exit in reverse construction order — release is tied to a code region, not to disciplined manual calls.

- **Acquire in ctor, release in dtor.** Half-constructed objects don't run the dtor, which is why ctors must not leak.
- **One owner per resource.** Copying a naive guard double-releases; obey [[the-rule-of-0-3-5]] (delete copies, or define move).
- **Stack unwinding** during an exception destroys every fully-built local on the way out, releasing each resource exactly once.

| Resource | RAII wrapper |
|---|---|
| heap object | `std::unique_ptr` / `std::shared_ptr` |
| mutex | `std::lock_guard` / `std::scoped_lock` |
| file handle | `std::fstream` |
| arbitrary cleanup | custom guard / `std::unique_ptr` with deleter |

## Example

```cpp
void write(const std::string& path, std::span<const char> data) {
  std::lock_guard lk(g_mtx);        // acquire lock
  std::ofstream out(path);          // acquire file
  out.write(data.data(), data.size());
}  // out closed, then lk unlocked — even if write() throws
```

No `close()`, no `unlock()`, no leak on the throw path: both destructors run during unwinding, in reverse order (`out` then `lk`).

## Pitfalls

- **Leaking the guard**: `new Guard(...)` puts the guard on the heap, so its dtor never runs at scope exit. Keep guards as locals.
- **Naming a temporary out of existence**: `std::lock_guard(m);` creates an unnamed temporary that dies immediately, locking nothing. Always name it.
- **Throwing destructors** during unwinding call `std::terminate`; dtors should be [[noexcept]].
- **Copyable guards** without proper copy/move semantics double-release — see [[the-rule-of-0-3-5]].

## See also

- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[object-lifetime]]
- [[exception-safety-guarantees]]
