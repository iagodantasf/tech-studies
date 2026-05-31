---
title: What is C++
track: cpp
group: Introduction
tags: [cpp, overview]
prerequisites: []
see-also: [c-vs-c, how-c-works-compilation-model]
---

# What is C++

C++ is a statically typed, compiled, multi-paradigm systems language that adds zero-overhead abstractions — classes, templates, RAII — on top of C's machine model.

## Why it matters

C++ runs where you cannot afford a garbage collector or a runtime tax: browsers (Chrome, Firefox), game and physics engines (Unreal), databases (MySQL, MongoDB), HFT, embedded firmware, and ML kernels (TensorFlow, LLVM). Its defining promise is the **zero-overhead principle** (Stroustrup): "what you don't use, you don't pay for; what you do use, you couldn't hand-code better." You get C-level control over memory and layout *and* high-level generics that compile down to the same code you'd write by hand.

## How it works

C++ is governed by an ISO standard (ISO/IEC 14882), not a single vendor — see [[c-standards-c-11-14-17-20-23]]. Code is compiled ahead-of-time to native machine code; there is no VM. Several paradigms coexist (see [[programming-paradigms]]):

- **Procedural** — free functions and plain data, inherited from C.
- **Object-oriented** — classes, inheritance, runtime [[polymorphism-virtual-functions]] via vtables.
- **Generic** — [[function-templates]] and the [[containers-vector-array-list-deque|STL]], resolved at compile time.
- **Functional-ish** — [[lambda-expressions]], `<algorithm>`, immutability via `const`/`constexpr`.

The cornerstone idiom is [[raii]]: resource lifetimes are bound to object scope, so destructors release memory, files, and locks deterministically — no `finally`, no GC pauses.

| Trait | C++ | Java / C# | Python |
|---|---|---|---|
| Memory model | manual + RAII | GC | GC |
| Dispatch default | static | virtual | dynamic |
| Runtime overhead | ~none | JIT + GC | interpreter |

## Example

A `std::vector<int>` is a template instantiated at compile time, stores its elements contiguously like a raw C array (same cache behavior, same `O(1)` index), yet its destructor frees the buffer automatically when it leaves scope. You pay for the bytes you store — nothing more — which is the zero-overhead principle made concrete.

## Pitfalls

- **"C++ is just C with classes."** Modern C++ (since C++11) is a different language in practice — `auto`, move semantics, smart pointers, ranges — see [[c-vs-c]].
- **Undefined behavior (UB)** is the price of the control: out-of-bounds reads, signed overflow, and use-after-free are not checked at runtime by default.
- **Long compile times** from heavy template use and textual `#include` — a real engineering cost that [[modules-c-20]] aims to cut.

## See also

- [[c-vs-c]]
- [[c-standards-c-11-14-17-20-23]]
