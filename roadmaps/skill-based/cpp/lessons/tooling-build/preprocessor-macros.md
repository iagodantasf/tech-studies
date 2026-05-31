---
title: "Preprocessor & Macros"
track: cpp
group: Tooling & Build
tags: [cpp, preprocessor]
prerequisites: [how-c-works-compilation-model, header-source-separation]
see-also: [header-source-separation, constexpr-functions, modules-c-20]
---

# Preprocessor & Macros

The preprocessor is a textual pass that runs before the compiler, rewriting the source via `#include`, `#define`, and `#if` directives into a single translation unit.

## Why it matters

It is the mechanism behind every header inclusion, conditional compilation (`#ifdef _WIN32`), and the `assert`/feature-detection machinery that real codebases lean on. But because it operates on tokens with no knowledge of types, scope, or namespaces, macros are the source of some of the nastiest bugs in C++ — and modern features (`constexpr`, templates, [[modules-c-20]]) exist largely to replace them.

## How it works

The preprocessor runs as an early phase of the [[how-c-works-compilation-model|compilation model]] and emits text the compiler then parses. Key directives:

| Directive | Purpose |
|---|---|
| `#include` | paste a file's contents verbatim |
| `#define X v` | object-like macro: replace `X` with `v` |
| `#define F(a)` | function-like macro: token substitution |
| `#if` / `#ifdef` / `#endif` | conditional compilation |
| `#pragma once` | include guard (non-standard but universal) |
| `#error` | abort compilation with a message |

- Function-like macros substitute *tokens*, not values: arguments are re-evaluated each time they appear, so `MAX(a++, b)` can increment `a` twice.
- `#` stringizes an argument; `##` pastes tokens together. Double-expansion macros (`STR(X)` calling `STR_(X)`) are needed to stringize a macro's *value* rather than its name.
- `__FILE__`, `__LINE__`, `__func__`, and `__cplusplus` (e.g. `202002L` for C++20) are predefined; test feature support with `__has_include` / `__cpp_*` macros.
- Guard every header against double inclusion with `#pragma once` or an `#ifndef PROJ_FOO_H` triad — see [[header-source-separation]].

## Example

```cpp
#define SQUARE(x) ((x) * (x))   // parens are mandatory
int a = SQUARE(1 + 2);          // ((1+2)*(1+2)) = 9, not 1+2*1+2 = 5
int b = SQUARE(a++);            // a incremented TWICE -> UB-ish surprise

// prefer the typed, single-evaluation alternative:
constexpr auto square(auto x) { return x * x; }
```

The macro version has no type checking, ignores namespaces, and breaks debuggers; the [[constexpr-functions|constexpr]] one is type-safe and evaluates `x` once.

## Pitfalls

- **Missing parentheses** around parameters and the whole body cause precedence bugs (`SQUARE(1+2)`), and **multiple evaluation** of side-effecting arguments silently doubles work.
- **Macros ignore scope and case** — `#define max(...)` collides with `std::max`; including `<windows.h>` defines `min`/`max` macros that wreck the STL unless you `#define NOMINMAX`.
- **No debugger visibility**: macro-expanded code has no symbols, so you cannot step into or breakpoint inside a macro.
- **`#ifdef` typos compile silently**: a misspelled or never-defined name just evaluates false, so a whole block vanishes with no error.

## See also

- [[header-source-separation]]
- [[constexpr-functions]]
- [[modules-c-20]]
