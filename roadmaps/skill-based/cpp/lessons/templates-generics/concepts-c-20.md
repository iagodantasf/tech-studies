---
title: Concepts (C++20)
track: cpp
group: Templates & Generics
tags: [cpp, concepts]
prerequisites: [function-templates, sfinae]
see-also: [sfinae, ranges-c-20, template-metaprogramming]
---

# Concepts (C++20)

A concept is a named, compile-time predicate on template parameters that *constrains* what types a template accepts, replacing brittle SFINAE with readable requirements.

## Why it matters

Concepts turn template errors from 200-line instantiation dumps into one-line "constraint not satisfied" messages pointing at the actual mismatch. They make generic interfaces self-documenting (`template<std::integral T>` says exactly what it needs) and drive overload selection by *subsumption*. The entire C++20 `<ranges>` library is specified in concepts. They are the modern, intended replacement for [[sfinae]].

## How it works

Declare with `concept`, apply via `requires`, an abbreviated parameter, or a constrained `auto`.

| Way to constrain | Syntax |
|---|---|
| concept as type-param | `template<std::integral T>` |
| trailing requires | `template<class T> requires C<T>` |
| requires-clause body | `requires (T a) { a.size(); }` |
| abbreviated function | `void f(std::integral auto x)` |
| constrained variable | `std::integral auto y = ...;` |

- A **requires-expression** `requires(T a){ ... }` yields `true` only if every line is well-formed: a bare expression checks validity, `{e} -> C<...>` checks the result type, `typename T::X` checks a nested type.
- **Subsumption**: when two overloads both match, the one whose constraints *imply* the other's is more constrained and wins — no tie-break hacks needed.
- Many predicates ship in `<concepts>` (`std::integral`, `std::same_as`, `std::convertible_to`, `std::invocable`) and `<ranges>` (`std::ranges::range`).

## Example

```cpp
template<class T>
concept Addable = requires(T a, T b) { { a + b } -> std::same_as<T>; };

template<Addable T>            // reads like a type bound
T sum(T a, T b) { return a + b; }

sum(2, 3);                     // ok, int is Addable
sum(std::string("a"), "b");   // error: 'std::string' does not satisfy 'Addable'
```

The failure names `Addable` directly, instead of an inscrutable error inside `operator+`.

## Pitfalls

- **A requires-expression only checks well-formedness, not truth** — `requires(T t){ t == t; }` is satisfied even if `operator==` always returns nonsense; it tests *compilability*, not semantics.
- **Atomic-constraint identity matters for subsumption**: two spelled-out `sizeof(T) > 0` clauses don't subsume unless they're the *same* named concept; mixing raw expressions and concepts breaks the partial order silently.
- **`requires requires`** (a requires-clause whose condition is an ad-hoc requires-expression) compiles but is a code smell — name the concept instead.
- **Constraints don't replace runtime checks**: a concept can't express "this pointer is non-null"; it's purely a static interface predicate.

## See also

- [[sfinae]]
- [[ranges-c-20]]
- [[template-metaprogramming]]
