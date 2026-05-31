---
title: Template Metaprogramming
track: cpp
group: Templates & Generics
tags: [cpp, metaprogramming]
prerequisites: [template-specialization, variadic-templates, constexpr-functions]
see-also: [concepts-c-20, sfinae, class-templates]
---

# Template Metaprogramming

Template metaprogramming (TMP) is computation performed by the *compiler*, using templates and `constexpr` as a Turing-complete sub-language that runs at compile time and emits types or constants.

## Why it matters

It's how the standard library computes traits (`std::is_same`, `std::tuple_element`), selects optimal layouts, unrolls fixed-size loops, and validates invariants before the program ever runs — moving work and bug-catching from runtime to compile time. Library authors use it to give zero-overhead generic abstractions; mis-used, it's also the classic source of glacial compile times. Modern C++ replaces much of the old recursive style with `constexpr` and [[concepts-c-20]].

## How it works

Three eras of doing the same thing, increasingly readable:

| Style | Era | "Return a value" via |
|---|---|---|
| recursive class templates | C++98 | `::value` static member |
| type traits + `_v`/`_t` aliases | C++11/14 | `trait_v<T>` / `trait_t<T>` |
| `constexpr`/`consteval` functions | C++14/20 | a normal `return` |

- **Values as types**: classic TMP encodes numbers as `std::integral_constant`-like types and recurses via [[template-specialization]] — a base case stops the recursion (e.g. `Factorial<0>`).
- **Type transformations**: traits map a type to another type (`std::remove_cv_t`, `std::conditional_t<B,X,Y>` picks `X` or `Y` at compile time).
- **`if constexpr`** (C++17) discards the dead branch *before* instantiation, replacing tag dispatch and much SFINAE for in-function branching.
- Prefer **`constexpr` functions** for value computation: they read like ordinary code and the compiler folds them.

## Example

```cpp
// Classic recursive TMP: factorial in the type system
template<int N> struct Fact { static constexpr long v = N * Fact<N-1>::v; };
template<>      struct Fact<0> { static constexpr long v = 1; };       // base case
static_assert(Fact<5>::v == 120);          // computed at compile time

constexpr long fact(int n) { return n ? n * fact(n-1) : 1; }          // modern equivalent
static_assert(fact(5) == 120);             // same result, readable
```

The `Fact<5>` form instantiates 6 types; the `constexpr` form instantiates none and is the preferred modern style.

## Pitfalls

- **Instantiation depth and compile time**: deep recursion (e.g. `Fact<10000>`) hits the compiler's instantiation limit (~900 default in GCC/Clang) and can take seconds per template — favor `constexpr`/fold expressions.
- **`if constexpr` still parses the dead branch**: it must be syntactically valid even when discarded, so it can't reference names that don't exist for that type without a dependent guard.
- **Error messages are notoriously deep** — a TMP mistake prints the whole recursion stack; `static_assert` with a message at the base case localizes failures.
- **Reach for the simplest tool**: `constexpr` over recursion, `concepts` over `enable_if`, [[sfinae]] only when targeting older standards.

## See also

- [[concepts-c-20]]
- [[sfinae]]
- [[class-templates]]
