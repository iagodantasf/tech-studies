---
title: "Utility Types (`pair`, `tuple`, `optional`, `variant`, `any`)"
track: cpp
group: Standard Library (STL)
tags: [cpp, utility-types]
prerequisites: [structs, templates-generics, error-codes-std-expected]
see-also: [associative-containers-map-set-unordered-map, std-string-std-string-view, exceptions-try-catch-throw]
---

# Utility Types (`pair`, `tuple`, `optional`, `variant`, `any`)

A family of vocabulary types for ad-hoc aggregates and choices: heterogeneous bundles (`pair`/`tuple`), a maybe-value (`optional`), a tagged union (`variant`), and a type-erased box (`any`).

## Why it matters

These are the standard way to return multiple values, model "no result", and express "one of several types" without inventing a struct or `enum`+union by hand. `optional<T>` makes the absence of a value a *type-system fact* instead of a magic `-1`/null/sentinel; `variant` is a type-safe, never-UB replacement for raw `union`. They are the building blocks under [[error-codes-std-expected]] and structured bindings.

## How it works

| Type | Holds | Cost / storage | Bad-access behavior |
|---|---|---|---|
| `pair<A,B>` | exactly 2, fixed types | sum of members | n/a |
| `tuple<T...>` | N, fixed types | sum of members | n/a |
| `optional<T>` | 0 or 1 of `T` | `sizeof(T)` + bool flag | `.value()` throws; `*` is UB |
| `variant<T...>` | exactly 1 of the listed types | max member + tag | `get<>` wrong type throws |
| `any` | 1 of *any* type | small-buffer or heap | `any_cast` wrong type throws |

- `optional`/`variant` (C++17) store **inline** — no heap. `any` may allocate for large/non-trivial types. None of `optional`/`variant`/`any` ever leaves you with raw UB on misuse *if* you use the checked accessors.
- Read `variant` with `std::visit(visitor, v)` (exhaustive, compile-checked) or `std::get_if<T>(&v)` (returns `nullptr`, no throw). `std::get<T>(v)` throws `bad_variant_access` on the wrong alternative.
- **Structured bindings** destructure them: `auto [k, v] = *map.find(key);` or `auto [ok, val] = parse();`.
- Prefer `optional<T>` over `pair<bool,T>` and `variant<T,Error>` (or `std::expected`, C++23) over out-params for fallible returns. See [[error-codes-std-expected]].

## Example

```cpp
std::optional<int> parse(std::string_view s) {
    int n;
    auto [p, ec] = std::from_chars(s.data(), s.data()+s.size(), n);
    if (ec == std::errc{}) return n;     // success
    return std::nullopt;                 // explicit "no value"
}
if (auto r = parse("42"))  use(*r);      // contextual bool: engaged?
int port = parse(cfg).value_or(8080);    // default if absent

std::variant<int,std::string> v = "hi";
std::visit([](auto&& x){ std::cout << x; }, v);   // picks the right overload
```

`value_or` collapses the "missing? use default" branch into one expression.

## Pitfalls

- **`*opt` / `opt->` on a disengaged optional is UB**, just like dereferencing null. Guard with `if (opt)` or use `.value()` (throws) / `.value_or(x)`.
- **Default-constructed `variant` holds its *first* alternative** — order matters; put a cheap/sane type first, or make it `monostate`.
- **`std::get<T>(v)` and `any_cast<T>` throw** on type mismatch; in hot paths use `get_if`/the pointer form of `any_cast` to branch without exceptions ([[exceptions-try-catch-throw]]).
- **`tuple` hurts readability** past 2-3 fields and is positional — `std::get<2>(t)` says nothing. A named `struct` is clearer for anything long-lived.

## See also

- [[error-codes-std-expected]]
- [[associative-containers-map-set-unordered-map]]
- [[exceptions-try-catch-throw]]
