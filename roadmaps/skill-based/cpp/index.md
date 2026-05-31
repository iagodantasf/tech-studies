---
title: C++
track: cpp
category: Skill-based
tags: [roadmap, cpp]
---

# C++

> roadmap.sh: https://roadmap.sh/cpp

Suggested path through the **C++** nodes. Each node links to its lesson when written.

## Nodes

### Introduction
- [[what-is-c]]
- [[c-vs-c]]
- [[c-standards-c-11-14-17-20-23]]
- [[setting-up-the-environment]]
- [[compilers-gcc-clang-msvc]]
- [[running-first-program]]
- [[how-c-works-compilation-model]]

### Basics / Syntax
- [[variables-and-constants]]
- [[data-types]]
- [[type-modifiers]]
- [[auto-and-type-inference]]
- [[operators]]
- [[conditionals-if-switch]]
- [[loops-for-while-do-while]]
- [[range-based-for-loop]]
- [[comments]]
- [[input-output-iostream]]

### Functions
- [[declaring-defining-functions]]
- [[parameters-and-arguments]]
- [[pass-by-value-reference-pointer]]
- [[default-arguments]]
- [[function-overloading]]
- [[inline-functions]]
- [[lambda-expressions]]
- [[constexpr-functions]]
- [[recursion]]

### Pointers & References
- [[pointers]]
- [[references]]
- [[pointer-arithmetic]]
- [[nullptr]]
- [[const-pointers-pointer-to-const]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[dangling-pointers-memory-leaks]]

### Memory Management
- [[stack-vs-heap]]
- [[new-delete]]
- [[raii]]
- [[object-lifetime]]
- [[move-semantics-rvalue-references]]
- [[copy-vs-move]]

### Structures & OOP
- [[structs]]
- [[classes-objects]]
- [[access-specifiers]]
- [[constructors-destructors]]
- [[copy-move-constructors]]
- [[operator-overloading]]
- [[this-pointer]]
- [[static-members]]
- [[friend-functions-classes]]
- [[inheritance]]
- [[polymorphism-virtual-functions]]
- [[abstract-classes-interfaces]]
- [[encapsulation]]
- [[the-rule-of-0-3-5]]

### Templates & Generics
- [[function-templates]]
- [[class-templates]]
- [[template-specialization]]
- [[variadic-templates]]
- [[concepts-c-20]]
- [[sfinae]]
- [[template-metaprogramming]]

### Standard Library (STL)
- [[containers-vector-array-list-deque]]
- [[associative-containers-map-set-unordered-map]]
- [[iterators]]
- [[algorithms-algorithm]]
- [[std-string-std-string-view]]
- [[utility-types-pair-tuple-optional-variant-any]]
- [[std-span]]
- [[function-objects-std-function]]
- [[ranges-c-20]]

### Error Handling
- [[exceptions-try-catch-throw]]
- [[exception-safety-guarantees]]
- [[noexcept]]
- [[error-codes-std-expected]]
- [[assertions]]

### Concurrency
- [[threads-std-thread]]
- [[mutexes-locks]]
- [[condition-variables]]
- [[atomics]]
- [[std-async-futures-promises]]
- [[memory-model-data-races]]
- [[coroutines-c-20]]

### Tooling & Build
- [[preprocessor-macros]]
- [[header-source-separation]]
- [[build-systems-cmake-make]]
- [[package-managers-vcpkg-conan]]
- [[debuggers-gdb-lldb]]
- [[sanitizers-asan-ubsan-tsan]]
- [[static-analysis-clang-tidy-cppcheck]]
- [[profilers-perf-valgrind]]
- [[unit-testing-googletest-catch2]]
- [[modules-c-20]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a small JSON parser/serializer from scratch using only the STL, exercising templates, `std::variant`, and RAII for the value tree.
- Implement a thread-safe bounded producer/consumer queue with `std::mutex` + condition variables, then benchmark it against a lock-free `std::atomic` ring buffer.
- Write a tiny `unique_ptr`/`shared_ptr` clone (with custom deleters and a reference count) to internalize move semantics and the Rule of 5.
