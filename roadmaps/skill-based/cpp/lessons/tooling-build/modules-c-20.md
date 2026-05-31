---
title: "Modules (C++20)"
track: cpp
group: Tooling & Build
tags: [cpp, modules]
prerequisites: [header-source-separation, preprocessor-macros]
see-also: [header-source-separation, preprocessor-macros, build-systems-cmake-make]
---

# Modules (C++20)

C++20 modules replace textual `#include` with a compiled, importable interface unit, giving real encapsulation and far faster builds than the preprocessor model.

## Why it matters

The header model recompiles the same declarations in every translation unit — a project including `<vector>` 1000 times parses it 1000 times — and leaks macros across files. Modules compile an interface *once* into a binary artifact (BMI/CMI) that imports load directly, cutting parse work dramatically and stopping [[preprocessor-macros|macro]] bleed. They are the long-term successor to [[header-source-separation|header/source split]], though toolchain and build-system support is still maturing.

## How it works

A *module interface unit* exports names; consumers `import` it instead of `#include`-ing a header. The compiler emits a binary module interface the importer reads — no re-parsing, no token pasting.

| Concept | Header model | Module model |
|---|---|---|
| Share declarations | `#include "x.h"` | `import x;` |
| Expose a name | external linkage | `export` keyword |
| Hide a name | unnamed namespace | non-`export` (truly private) |
| Macro propagation | leaks into TU | does **not** cross `import` |
| Reuse cost | re-parse per TU | parse once -> BMI |

- A module begins with `export module name;`; only entities marked `export` are visible to importers — everything else is genuinely private, unlike header internals.
- **`import std;`** (C++23) replaces dozens of standard `#include`s with one statement, a major compile-time win.
- **Macros do not flow through `import`** (they're not part of the interface), which removes a whole class of order-dependent bugs but means config macros must be passed another way.
- Build order matters: a module's interface must be **compiled before** its importers, so the build system needs a dependency scan — CMake supports this via `target_sources(... FILE_SET CXX_MODULES ...)` with Ninja and a recent compiler.

## Example

```cpp
// math.ixx  (module interface unit)
export module math;
export int add(int a, int b) { return a + b; }
int helper() { return 42; }        // NOT exported -> invisible to importers

// main.cpp
import math;
int main() { return add(2, 3); }   // helper() is unreachable here
```

Build (Clang): the compiler scans `import math;`, builds `math`'s BMI first, then `main.cpp` — no `#include`, no include guards, no macro leakage.

## Pitfalls

- **Toolchain immaturity**: full support (GCC 14+, Clang 16+, MSVC) plus a modules-aware build (CMake ≥3.28 + Ninja) is required; mixing compilers' BMIs is not portable.
- **Build-order dependency**: importers fail to compile until the interface's BMI exists, so naive parallel/recursive builds break without a proper scan.
- **Mixing `#include` and `import` of the same library** can cause ODR/duplicate-declaration clashes; don't pull a header and its module form into one TU.
- **Macros you relied on disappear** across module boundaries — config flags passed via headers must move to build-system definitions or explicit interfaces.

## See also

- [[header-source-separation]]
- [[preprocessor-macros]]
- [[build-systems-cmake-make]]
