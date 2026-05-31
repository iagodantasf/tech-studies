---
title: "Header / Source Separation"
track: cpp
group: Tooling & Build
tags: [cpp, headers]
prerequisites: [how-c-works-compilation-model, preprocessor-macros]
see-also: [preprocessor-macros, build-systems-cmake-make, modules-c-20]
---

# Header / Source Separation

C++ splits code into headers (`.h`/`.hpp`, declarations the compiler shares) and source files (`.cpp`, definitions each compiled once), tied together by the one-definition rule.

## Why it matters

This is the foundation of C++'s separate-compilation model: every `.cpp` is a translation unit compiled independently into an object file, then the linker stitches them. Get the header/source split wrong and you get either *multiple-definition* linker errors or *undefined-reference* errors — two of the most common failures new and senior engineers alike hit. It also governs build times: a header included by 500 files recompiles all 500 when it changes.

## How it works

A header declares *what exists*; the matching source defines *what it does*. The [[preprocessor-macros|preprocessor]] textually pastes headers in, so each must be self-contained and guarded.

| Goes in the header | Goes in the source |
|---|---|
| function/class declarations | function bodies (non-inline) |
| `inline` / `constexpr` functions | out-of-line member definitions |
| templates (must be visible) | non-`inline` globals |
| `class` layout, member decls | static data member definitions |

- The **One-Definition Rule (ODR)**: a non-`inline` free function or global may have exactly *one* definition across the whole program; put bodies in `.cpp`, declarations in `.h`.
- Guard every header with `#pragma once` (or an `#ifndef` triad) so multiple includes in one TU don't redefine things.
- **Templates and `inline` functions** must live in the header — their full definition has to be visible at every use site, since the compiler instantiates them per TU.
- Use **forward declarations** (`class Widget;`) instead of `#include` when you only need a pointer/reference, to cut compile-time coupling.

## Example

```cpp
// math.h
#pragma once
int add(int a, int b);            // declaration only
inline int twice(int x){return 2*x;} // inline: body OK in header

// math.cpp
#include "math.h"
int add(int a, int b){ return a + b; }   // the single definition

// main.cpp  -> sees the declaration, links against math.o
```

Compile each separately: `g++ -c math.cpp main.cpp` then `g++ math.o main.o`. Putting `add`'s body in the header and including it twice yields a duplicate-symbol link error.

## Pitfalls

- **Defining a non-inline function in a header** included by 2+ TUs gives a "multiple definition" linker error — mark it `inline` or move it to a `.cpp`.
- **Declaring but never defining** (or forgetting to compile/link the `.cpp`) gives "undefined reference at link time" — the compile succeeds, the link fails.
- **Fat headers** (pulling in `<vector>`, project headers, etc. transitively) explode build times; forward-declare and include in the `.cpp` instead.
- **Missing include guard** causes redefinition errors the moment two paths include the header; never rely on the compiler to dedupe.

## See also

- [[preprocessor-macros]]
- [[build-systems-cmake-make]]
- [[modules-c-20]]
