---
title: C++ vs C
track: cpp
group: Introduction
tags: [cpp, comparison]
prerequisites: [what-is-c]
see-also: [raii, how-c-works-compilation-model]
---

# C++ vs C

C++ began as "C with Classes" and stays *mostly* source-compatible with C, but adds type safety, RAII, generics, and exceptions — and is **not** a strict superset.

## Why it matters

You constantly cross this boundary: calling C libraries (POSIX, OpenSSL, SQLite) from C++, or exposing a C ABI from a C++ library so other languages can bind to it. Knowing exactly where the languages diverge prevents linker errors, silent ABI mismatches, and double-frees. The stable, flat **C ABI** is also why C — not C++ — is the lingua franca for FFI.

## How it works

C++ adds whole subsystems C lacks: classes and [[inheritance]], [[function-templates|templates]], [[exceptions-try-catch-throw|exceptions]], namespaces, references, [[operator-overloading]], and the STL. It also tightens existing C rules.

- **Not a superset.** Valid C that breaks in C++: `int new;` (keyword), implicit `void*`→`T*` conversion (`malloc` needs a cast in C++), and tentative definitions.
- **Linkage.** C++ *name-mangles* symbols to encode types for overloading; to call/expose C symbols you wrap them in `extern "C" { ... }` so the names stay flat.
- **Idiom shift.** C uses `malloc`/`free` and manual cleanup with `goto fail`; C++ uses [[raii]] + [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]] so destructors free resources automatically — no leaks on early return or exception.

| Concern | C | C++ |
|---|---|---|
| Allocation | malloc / free | new / delete, RAII |
| Polymorphism | function pointers | virtual functions |
| Generics | macros / void* | templates |
| Error path | return codes / errno | exceptions or codes |
| Symbol names | flat | mangled |

## Example

```cpp
// Make a C++ function callable from C (no mangling):
extern "C" int add(int a, int b) { return a + b; }

// Consume a C header from C++:
extern "C" {
  #include <sqlite3.h>   // its symbols keep C linkage
}
```

Without `extern "C"`, the linker emits `_Z3addii` and the C side's reference to `add` goes unresolved.

## Pitfalls

- **Assuming superset semantics** — `sizeof('a')` is `sizeof(int)` in C but `sizeof(char)` (1) in C++; `char` literals differ.
- **Mixing `malloc` with `delete`** (or `new` with `free`) is UB; never cross allocators, and never `free` a non-trivially-destructible object.
- **Throwing a C++ exception across a C stack frame** is UB — the C frames don't know how to unwind.
- **One `extern "C"` function can't be overloaded** — C linkage has no mangling to disambiguate.

## See also

- [[raii]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
