---
title: "Build Systems (CMake, Make)"
track: cpp
group: Tooling & Build
tags: [cpp, build-systems]
prerequisites: [header-source-separation, how-c-works-compilation-model]
see-also: [header-source-separation, package-managers-vcpkg-conan, modules-c-20]
---

# Build Systems (CMake, Make)

A build system turns source files into binaries by tracking dependencies and invoking the compiler/linker incrementally; CMake is a generator that produces the actual build (Make, Ninja, MSBuild).

## Why it matters

Real C++ projects span dozens to thousands of translation units across platforms and compilers; hand-running `g++` does not scale. Make rebuilds only what changed via timestamp comparison; CMake sits above it as the de-facto standard for portable C++ builds and is what [[package-managers-vcpkg-conan|package managers]] and IDEs integrate with. "It builds on my machine" almost always traces back to build-system configuration.

## How it works

Make reads a `Makefile` of `target: prerequisites` rules and shell recipes, rebuilding a target when any prerequisite is newer. CMake is one level up: you describe *targets and their requirements* declaratively, and it generates Make/Ninja files.

| CMake command | Meaning |
|---|---|
| `add_executable(app a.cpp b.cpp)` | define a binary target |
| `add_library(core STATIC ...)` | static/shared/header-only lib |
| `target_link_libraries(app PRIVATE core)` | link + propagate usage reqs |
| `target_include_directories(... PUBLIC inc)` | include paths, transitively |
| `find_package(fmt REQUIRED)` | locate an installed dependency |

- **Modern "target-based" CMake** (≥3.x) attaches include dirs, flags, and `compile_features` to targets with `PUBLIC`/`PRIVATE`/`INTERFACE` scope, so consumers inherit them automatically — avoid the old global `include_directories`.
- Two phases: **configure** (`cmake -S . -B build`, runs `CMakeLists.txt`, detects compiler) then **build** (`cmake --build build`, invokes the generator).
- Set the toolchain and standard explicitly: `target_compile_features(app PRIVATE cxx_std_20)` is preferred over raw `-std=c++20` flags.
- Prefer **Ninja** (`-G Ninja`) over Make for large builds: faster dependency graph and better parallelism.

## Example

```cmake
cmake_minimum_required(VERSION 3.20)
project(demo LANGUAGES CXX)

add_library(core STATIC src/core.cpp)
target_include_directories(core PUBLIC include)
target_compile_features(core PUBLIC cxx_std_20)

add_executable(app src/main.cpp)
target_link_libraries(app PRIVATE core)  # app inherits core's includes
```

```bash
cmake -S . -B build -G Ninja   # configure
cmake --build build -j         # parallel build; rebuilds only changed TUs
```

## Pitfalls

- **In-source builds** (`cmake .`) pollute the tree with generated files; always use a separate `build/` dir.
- **Wrong propagation scope**: marking an include dir `PRIVATE` when consumers need it gives "header not found" downstream; `PUBLIC`/`INTERFACE` are for usage requirements.
- **Globbing sources** (`file(GLOB ...)`) means CMake doesn't re-run when you add a file — list sources explicitly or accept stale builds.
- **Recursive Make** across directories breaks the dependency graph and parallelism; prefer a single CMake project or non-recursive Make.

## See also

- [[header-source-separation]]
- [[package-managers-vcpkg-conan]]
- [[modules-c-20]]
