---
title: Compilers (GCC, Clang, MSVC)
track: cpp
group: Introduction
tags: [cpp, compilers]
prerequisites: [setting-up-the-environment]
see-also: [how-c-works-compilation-model, c-standards-c-11-14-17-20-23]
---

# Compilers (GCC, Clang, MSVC)

The three production C++ compilers — GCC, Clang/LLVM, and Microsoft MSVC — each implement the same ISO standard but differ in flags, diagnostics, standard library, and ABI.

## Why it matters

Portable C++ is code that compiles clean on all three; CI matrices routinely build every commit against GCC + Clang + MSVC to catch nonconformance early (one compiler accepting an extension another rejects). They also differ in *which* standard features ship first and how aggressively they optimize, so the compiler is a real variable in both correctness and performance.

## How it works

Each pairs a frontend with a standard library and emits native code (see [[how-c-works-compilation-model]]):

| Compiler | Default stdlib | Platforms | Flag style |
|---|---|---|---|
| GCC (`g++`) | libstdc++ | Linux, MinGW | `-std=c++20 -O2 -Wall` |
| Clang (`clang++`) | libc++ or libstdc++ | macOS, Linux, Win | `-std=c++20 -O2 -Wall` (GCC-compatible) |
| MSVC (`cl.exe`) | MS STL | Windows | `/std:c++20 /O2 /W4` |

- **Optimization** maps `-O0` (debug, no opt) → `-O1` → `-O2` (release default) → `-O3` (aggressive) → `-Os` (size); MSVC uses `/Od`/`/O1`/`/O2`.
- **Warnings are your linter** — `-Wall -Wextra -Wpedantic` (GCC/Clang) or `/W4`; add `-Werror` in CI to make warnings fatal.
- **ABI**: GCC and Clang share the Itanium C++ ABI on Linux (interchangeable objects); MSVC uses its own — you cannot link MSVC and MinGW objects together.
- **Clang** doubles as a tooling platform: clangd, clang-tidy, and clang-format reuse its frontend.

## Example

The same source, three invocations:

```bash
g++     -std=c++20 -O2 -Wall -Wextra main.cpp -o app   # Linux
clang++ -std=c++20 -O2 -Wall -Wextra main.cpp -o app   # macOS, libc++
cl      /std:c++20 /O2 /W4 main.cpp                     # Windows MSVC
```

Clang famously pioneered readable diagnostics with carets and fix-it hints; GCC has since caught up, while MSVC's wording still differs — a reason to read errors from more than one.

## Pitfalls

- **Compiler-specific extensions** (`__builtin_*`, MSVC `__declspec`, VLAs in GCC) compile on one toolchain and break the others — guard with `-Wpedantic`.
- **Mixing standard libraries** — objects built against libstdc++ and libc++ have incompatible `std::string`/`std::list` layouts; link one consistently.
- **`-O3` is not free** — it can bloat code and occasionally expose latent UB that `-O0` hid; `-O2` is the usual release default.
- **Default standard varies** — older GCC defaulted to C++14/17; always pass `-std=` explicitly.

## See also

- [[how-c-works-compilation-model]]
- [[c-standards-c-11-14-17-20-23]]
