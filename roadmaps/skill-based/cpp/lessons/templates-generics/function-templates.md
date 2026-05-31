---
title: Function Templates
track: cpp
group: Templates & Generics
tags: [cpp, templates]
prerequisites: [declaring-defining-functions, function-overloading, auto-and-type-inference]
see-also: [class-templates, concepts-c-20, sfinae]
---

# Function Templates

A function template is a *recipe* the compiler stamps into a concrete function once per distinct set of template arguments, deduced from the call site.

## Why it matters

They are how you write one `max`, `swap`, or `std::find` that works for every type without `void*` casts or runtime dispatch — the entire `<algorithm>` header is function templates. Instantiation happens at compile time, so the generated code is as tight as a hand-written overload, with full type checking. The cost is that errors surface deep inside instantiation and that each type combination is a separate symbol in the binary.

## How it works

`template<typename T> T add(T a, T b);`. The compiler runs **template argument deduction** on the call arguments, then instantiates.

| Argument form | Param `T&&` deduces | Param `T` deduces |
|---|---|---|
| lvalue `int x` | `int&` (collapse) | `int` (decays) |
| rvalue `42` | `int` | `int` |
| `const int&` | `const int&` | `int` (strips const) |
| array `int[4]` | `int(&)[4]` | `int*` (decays) |

- A bare `T` parameter **decays**: drops top-level `const`/`&`, arrays-to-pointer. A `T&&` parameter is a *forwarding reference* and uses reference collapsing — the basis of [[variadic-templates]] perfect forwarding.
- No implicit conversions happen *during* deduction: `max(1, 2u)` fails because `T` can't be both `int` and `unsigned`. Fix with two type params or an explicit `max<int>(...)`.
- Non-deduced contexts (a `T` nested behind `::`, or only in the return type) require explicit arguments.
- Overload resolution prefers a non-template exact match over a template; ties between templates pick the *more specialized* one. See [[function-overloading]].

## Example

```cpp
template<typename T, typename U>
auto add(T a, U b) -> decltype(a + b) { return a + b; }   // C++11 trailing return

auto x = add(3, 4.5);    // T=int, U=double  -> double, 7.5
auto y = add<long>(1,2); // T=long explicit, U=int deduced
```

`add(3, 4.5)` instantiates exactly one `add<int,double>`; the `decltype` gives the natural promoted result type. In C++14+ a plain `auto` return replaces the trailing form.

## Pitfalls

- **Definitions must be visible** at the call site — templates live in headers. Splitting declaration and definition across `.cpp` files gives "undefined reference" unless you explicitly instantiate.
- **`T` deduces both args to one type:** mixing `int`/`double` won't compile under a single `T`. Use multiple parameters.
- **Forwarding-reference overloads are greedy** — a `template<class T> f(T&&)` out-competes `f(const std::string&)` for almost everything, hijacking calls. Constrain it with [[concepts-c-20]] or [[sfinae]].
- **Each instantiation is its own symbol**, bloating binaries; heavy generic code can balloon compile times and `.o` size.

## See also

- [[class-templates]]
- [[concepts-c-20]]
- [[sfinae]]
