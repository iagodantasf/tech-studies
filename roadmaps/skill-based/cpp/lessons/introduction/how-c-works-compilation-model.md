---
title: How C++ Works (Compilation Model)
track: cpp
group: Introduction
tags: [cpp, compilation]
prerequisites: [running-first-program]
see-also: [preprocessor-macros, header-source-separation]
---

# How C++ Works (Compilation Model)

C++ uses a four-stage ahead-of-time pipeline — preprocess, compile, assemble, link — built around independent **translation units** that the linker later stitches into one binary.

## Why it matters

Almost every confusing build error maps to a specific stage: "undefined reference" is the *linker*, "unknown type" is the *compiler*, "no such file" is the *preprocessor*. Understanding the model explains why C++ needs headers, why ODR violations are silent landmines, and why incremental builds only recompile changed translation units. It is the basis for [[header-source-separation]] and [[build-systems-cmake-make]].

## How it works

Each `.cpp` plus everything it `#include`s forms one **translation unit (TU)**, compiled in isolation with no knowledge of the others:

| Stage | Tool | In → Out | Job |
|---|---|---|---|
| Preprocess | cpp | `.cpp` → `.i` | expand `#include`, `#define`, `#if` |
| Compile | cc1plus | `.i` → `.s` | parse, type-check, optimize → assembly |
| Assemble | as | `.s` → `.o` | assembly → machine code object |
| Link | ld | `.o` + libs → exe | resolve symbols across TUs |

- **Headers are textual copy-paste** by the [[preprocessor-macros|preprocessor]] — no module boundary, which is why include guards (`#pragma once`) stop double inclusion.
- **Declaration vs definition**: TUs see each other only through declarations in headers; the linker matches each *use* to exactly one *definition*.
- **ODR (One Definition Rule)**: every entity needs exactly one definition program-wide; duplicate non-inline definitions → linker error, conflicting ones → silent UB.
- See `g++ -E` (stop after preprocess), `-S` (after compile), `-c` (after assemble) to inspect any stage.

## Example

```bash
g++ -E main.cpp -o main.i    # 1. preprocessed source (often 10,000+ lines!)
g++ -S main.i -o main.s      # 2. assembly
g++ -c main.s -o main.o      # 3. object file (machine code, unresolved symbols)
g++ main.o util.o -o app     # 4. link: resolves calls between TUs
```

Change only `util.cpp`? Recompile `util.o` and re-link — `main.o` is untouched. That selective rebuild is exactly what Make and CMake automate.

## Pitfalls

- **Defining a non-inline function in a header** included by 2+ TUs → "multiple definition" at link time; declare in header, define in one `.cpp` (or mark `inline`).
- **Missing `extern`/wrong library order** — the linker scans left to right, so a library must appear *after* the object that uses it.
- **ODR violations from mismatched flags/types** across TUs are *not* diagnosed and cause crashes far from the cause.
- **Template definitions must be visible** in every TU that instantiates them — hence they live in headers, unlike normal functions.

## See also

- [[preprocessor-macros]]
- [[header-source-separation]]
