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
- What is C++
- C++ vs C
- C++ Standards (C++11/14/17/20/23)
- Setting up the Environment
- Compilers (GCC, Clang, MSVC)
- Running First Program
- How C++ Works (Compilation Model)

### Basics / Syntax
- Variables and Constants
- Data Types
- Type Modifiers
- `auto` and Type Inference
- Operators
- Conditionals (if / switch)
- Loops (for / while / do-while)
- Range-based for Loop
- Comments
- Input / Output (iostream)

### Functions
- Declaring & Defining Functions
- Parameters and Arguments
- Pass by Value / Reference / Pointer
- Default Arguments
- Function Overloading
- Inline Functions
- Lambda Expressions
- `constexpr` Functions
- Recursion

### Pointers & References
- Pointers
- References
- Pointer Arithmetic
- `nullptr`
- Const Pointers / Pointer to Const
- Smart Pointers (`unique_ptr`, `shared_ptr`, `weak_ptr`)
- Dangling Pointers & Memory Leaks

### Memory Management
- Stack vs Heap
- `new` / `delete`
- RAII
- Object Lifetime
- Move Semantics & Rvalue References
- Copy vs Move

### Structures & OOP
- Structs
- Classes & Objects
- Access Specifiers
- Constructors & Destructors
- Copy / Move Constructors
- Operator Overloading
- `this` Pointer
- Static Members
- Friend Functions / Classes
- Inheritance
- Polymorphism & Virtual Functions
- Abstract Classes & Interfaces
- Encapsulation
- The Rule of 0 / 3 / 5

### Templates & Generics
- Function Templates
- Class Templates
- Template Specialization
- Variadic Templates
- Concepts (C++20)
- SFINAE
- Template Metaprogramming

### Standard Library (STL)
- Containers (vector, array, list, deque)
- Associative Containers (map, set, unordered_map)
- Iterators
- Algorithms (`<algorithm>`)
- `std::string` / `std::string_view`
- Utility Types (`pair`, `tuple`, `optional`, `variant`, `any`)
- `std::span`
- Function Objects & `std::function`
- Ranges (C++20)

### Error Handling
- Exceptions (try / catch / throw)
- Exception Safety Guarantees
- `noexcept`
- Error Codes & `std::expected`
- Assertions

### Concurrency
- Threads (`std::thread`)
- Mutexes & Locks
- Condition Variables
- Atomics
- `std::async` / Futures & Promises
- Memory Model & Data Races
- Coroutines (C++20)

### Tooling & Build
- Preprocessor & Macros
- Header / Source Separation
- Build Systems (CMake, Make)
- Package Managers (vcpkg, Conan)
- Debuggers (gdb / lldb)
- Sanitizers (ASan, UBSan, TSan)
- Static Analysis (clang-tidy, cppcheck)
- Profilers (perf, Valgrind)
- Unit Testing (GoogleTest, Catch2)
- Modules (C++20)

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a small JSON parser/serializer from scratch using only the STL, exercising templates, `std::variant`, and RAII for the value tree.
- Implement a thread-safe bounded producer/consumer queue with `std::mutex` + condition variables, then benchmark it against a lock-free `std::atomic` ring buffer.
- Write a tiny `unique_ptr`/`shared_ptr` clone (with custom deleters and a reference count) to internalize move semantics and the Rule of 5.
