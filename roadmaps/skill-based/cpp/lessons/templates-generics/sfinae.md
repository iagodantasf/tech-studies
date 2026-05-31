---
title: SFINAE
track: cpp
group: Templates & Generics
tags: [cpp, sfinae]
prerequisites: [function-templates, function-overloading]
see-also: [concepts-c-20, template-specialization, template-metaprogramming]
---

# SFINAE

SFINAE — *Substitution Failure Is Not An Error* — is the rule that a template whose signature becomes ill-formed during argument substitution is silently dropped from overload resolution rather than aborting the compile.

## Why it matters

Before C++20 it was the only way to write a template that *conditionally exists* based on a type's capabilities — "enable this overload only if `T` has `.begin()`". It powers `std::enable_if`, the type traits in `<type_traits>`, and tag-dispatch idioms throughout the pre-concepts STL. You still meet it in any codebase targeting C++14/17, and it explains how detection idioms work under the hood. [[concepts-c-20]] is its modern, far cleaner successor.

## How it works

Substitution failures count *only* in the **immediate context** of the signature (template/function parameter types, return type), not inside a function body — a body error is a hard error.

| Mechanism | Where it lives | Effect |
|---|---|---|
| `std::enable_if_t<cond, R>` | return type / extra param | overload vanishes if `cond` false |
| `decltype(expr)` trailing | return type | drops if `expr` ill-formed |
| `std::void_t<...>` | partial spec | detect well-formed types |
| trailing default `= 0` NTTP | param list | adds an SFINAE hook |

- `enable_if<B, T>::type` exists **only when `B` is true**; naming `::type` when `B` is false is a substitution failure, so that overload is removed.
- The **detection idiom** uses `void_t`: a primary trait says "no", a `void_t<decltype(T().foo())>` partial specialization says "yes" when the expression compiles.
- Two SFINAE overloads must have *disjoint* conditions, or both survive and you get an ambiguity error.

## Example

```cpp
// Overload A: only for integral T
template<class T,
         std::enable_if_t<std::is_integral_v<T>, int> = 0>
void show(T x) { std::cout << "int-like " << x; }

// Overload B: only for floating T
template<class T,
         std::enable_if_t<std::is_floating_point_v<T>, int> = 0>
void show(T x) { std::cout << "float-like " << x; }

show(42);    // A; B removed by substitution failure
show(3.14);  // B; A removed
```

Each call sees exactly one viable overload — the other's `::type` failed to substitute and was discarded.

## Pitfalls

- **Only immediate-context failures are SFINAE.** An error deep inside the function body, or inside a class template used by the signature, is a *hard* error and kills the build — keep the condition in the signature.
- **Forgetting to make conditions mutually exclusive** leaves multiple overloads enabled → ambiguous call.
- **Cryptic diagnostics**: an over-constrained call yields "no matching function" with a wall of failed candidates and no reason — the exact pain [[concepts-c-20]] fixes.
- **`enable_if` on a non-deduced return type** can block deduction; prefer the extra-default-parameter form for constructors and operators.

## See also

- [[concepts-c-20]]
- [[template-specialization]]
- [[template-metaprogramming]]
