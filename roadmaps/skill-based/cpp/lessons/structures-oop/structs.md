---
title: Structs
track: cpp
group: Structures & OOP
tags: [cpp, structs]
prerequisites: [data-types, variables-and-constants]
see-also: [classes-objects, access-specifiers, the-rule-of-0-3-5]
---

# Structs

A `struct` groups named members into one object; in C++ it is a full class whose members default to `public`, used idiomatically for plain data aggregates.

## Why it matters

Structs are the building block of every node-based data structure ([[linked-lists]], [[trees]]) and every C interop boundary, because their layout is predictable and they can be passed across an ABI. The "aggregate" rules also unlock brace initialization, designated initializers (C++20), and structured bindings — the ergonomic way to return and unpack multiple values without a heavyweight class.

## How it works

`struct` and `class` differ in exactly two defaults: member access (`public` vs `private`) and base-class access on inheritance. Everything else — methods, constructors, templates — is identical.

| Trait | `struct` | `class` |
|---|---|---|
| Default member access | public | private |
| Default inheritance | public | private |
| Can have methods/ctors | yes | yes |

- An **aggregate** (no user-provided/`explicit` ctors, no private non-static data, no virtuals) gets brace init `Point p{1, 2};` and C++20 designated init `Point p{.x = 1, .y = 2};`.
- Members are laid out in declaration order; the compiler inserts **padding** so each member meets its alignment. Order members large-to-small to shrink `sizeof`.
- Structured bindings `auto [a, b] = p;` decompose any aggregate — see [[references]] for `auto&` binding.

## Example

Padding makes member order matter for `sizeof`:

```cpp
struct Bad  { char c; double d; char e; }; // sizeof == 24 (7+7 padding)
struct Good { double d; char c; char e; };  // sizeof == 16 (6 tail padding)
```

Reordering the same three members cuts 8 bytes — significant in a `std::vector<Good>` of millions of elements.

## Pitfalls

- **Forgetting padding** when computing array memory or writing a struct to disk/socket; never `memcpy` a struct across machines without `#pragma pack` or explicit serialization.
- An aggregate with a member that has a default member initializer was *not* an aggregate before C++14 — watch the standard version.
- Adding a user-declared constructor disables aggregate init: `Point p{1,2};` stops compiling.
- `struct` vs `class` is a style signal only; mixing the tags in a forward declaration and definition is legal but warned on by MSVC.

## See also

- [[classes-objects]]
- [[access-specifiers]]
- [[the-rule-of-0-3-5]]
