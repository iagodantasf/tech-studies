---
title: "`auto` and Type Inference"
track: cpp
group: Basics / Syntax
tags: [cpp, type-deduction]
prerequisites: [data-types]
see-also: [variables-and-constants, lambda-expressions]
---

# `auto` and Type Inference

`auto` (C++11) tells the compiler to deduce a variable's type from its initializer using template-argument deduction rules, eliminating redundant and error-prone type spellings.

## Why it matters

Without `auto`, iterator and lambda types are unwriteable or grotesque (`std::vector<int>::const_iterator`); lambdas have no name at all. Deduction also prevents *accidental conversions*: writing the wrong explicit type (e.g. `int` for a `size_t` index, or `std::pair<int,int>` vs the map's real `std::pair<const int,int>`) silently copies or truncates. In generic code, `auto` is the only way to name a type you don't know.

## How it works

`auto` follows the same rules as a deduced [[function-templates|template]] parameter `T`, with one twist for braces. Crucially, **plain `auto` strips top-level `const`, `volatile`, and references** — you must add them back.

- `auto x = expr;` — drops cv/ref; you get a value copy.
- `const auto&` / `auto&` — bind a reference, avoid copies.
- `auto&&` — a *forwarding* reference, preserves value category.
- `decltype(expr)` — deduces the *declared* type **with** ref/cv, exactly.
- `decltype(auto)` — return-type deduction that preserves ref-ness.

| Init | Deduced type | Note |
|---|---|---|
| `auto i = 0;` | `int` | literal type |
| `const std::string s; auto c = s;` | `std::string` | const dropped, copied |
| `auto& r = s;` | `const std::string&` | ref kept |
| `auto x{1};` | `int` | C++17 single-brace |

## Example

```cpp
std::map<int, std::string> m;
for (const auto& [k, v] : m)        // structured binding; no copy
    use(k, v);

auto add = [](auto a, auto b) { return a + b; };   // generic lambda
decltype(auto) front(std::vector<int>& v) { return v[0]; }  // returns int&
```

## Pitfalls

- **`auto` copies by default.** `for (auto x : big_vec)` deep-copies each element; reach for `const auto&`.
- **Proxy types lie.** `auto b = vec_of_bool[0];` deduces `std::vector<bool>::reference`, not `bool` — a dangling proxy.
- **`auto x{1,2};`** is ill-formed; `auto x = {1,2};` deduces `std::initializer_list<int>`, often a surprise.
- **Over-`auto`** can hide an unwanted implicit conversion or an expensive type from the reader.

## See also

- [[variables-and-constants]]
- [[lambda-expressions]]
