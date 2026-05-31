---
title: C++ Standards (C++11/14/17/20/23)
track: cpp
group: Introduction
tags: [cpp, standards]
prerequisites: [what-is-c]
see-also: [compilers-gcc-clang-msvc, move-semantics-rvalue-references]
---

# C++ Standards (C++11/14/17/20/23)

C++ ships on a fixed three-year ISO cadence; each standard (named by year) is what your compiler targets via a `-std=` flag, and the version you pick decides which features compile.

## Why it matters

"C++" is meaningless without a year — `auto`, lambdas, and `std::optional` simply don't exist before specific standards. Production codebases pin a baseline (often C++17 or C++20) for portability across the three major [[compilers-gcc-clang-msvc|compilers]], whose support lags the paper standard by 1–3 years. Picking the standard is a real engineering decision: it gates `std::format`, coroutines, modules, and whether `std::expected` is available.

## How it works

The committee (WG21) freezes a draft, ISO publishes it, then vendors implement. You select it per translation unit:

- `g++ -std=c++20`, `clang++ -std=c++23`, MSVC `/std:c++20`.
- "C++26" exists as a working draft; bleeding-edge features hide behind `-std=c++2c`.

| Std | Year | Headline features |
|---|---|---|
| C++11 | 2011 | auto, lambdas, move semantics, smart pointers, `nullptr`, threads |
| C++14 | 2014 | generic lambdas, `make_unique`, variable templates |
| C++17 | 2017 | structured bindings, `optional`/`variant`, `if constexpr`, parallel STL, filesystem |
| C++20 | 2020 | concepts, ranges, coroutines, modules, `<format>`, three-way `<=>` |
| C++23 | 2023 | `std::expected`, `std::print`, `mdspan`, deducing `this` |

C++11 is the great divide — it's where [[move-semantics-rvalue-references]] and RAII-by-default reshaped idiomatic C++.

## Example

`if constexpr` (C++17) lets a template discard a branch at compile time:

```cpp
template <class T>
auto stringify(T v) {
  if constexpr (std::is_arithmetic_v<T>)
    return std::to_string(v);   // only compiled for numbers
  else
    return std::string{v};
}
```

Compiled with `-std=c++14` this fails — `if constexpr` didn't exist; the discarded branch would be type-checked and break.

## Pitfalls

- **Assuming "C++20" means full support** — as of 2026, modules and coroutines have uneven library support across GCC/Clang/MSVC; check cppreference's compiler-support table before relying on a feature.
- **Mixing standards across TUs** in one binary can cause ODR/ABI mismatches — set the standard once, globally (e.g. CMake `target_compile_features`).
- **`-std=gnu++20` vs `-std=c++20`** — the `gnu` variant enables non-standard extensions that silently reduce portability.

## See also

- [[compilers-gcc-clang-msvc]]
- [[move-semantics-rvalue-references]]
