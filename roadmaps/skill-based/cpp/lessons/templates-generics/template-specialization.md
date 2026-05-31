---
title: Template Specialization
track: cpp
group: Templates & Generics
tags: [cpp, templates]
prerequisites: [class-templates, function-templates]
see-also: [sfinae, template-metaprogramming, concepts-c-20]
---

# Template Specialization

Specialization provides an alternative implementation of a template for specific argument(s), letting one generic interface dispatch to type-tailored code at compile time.

## Why it matters

It is how `std::vector<bool>` becomes a bit-packed type, how `std::hash` gets a definition per key type, and how traits like `std::is_pointer` compute answers. Specialization is the primary customization point of the standard library: you specialize `std::hash<MyKey>` so your type drops into `unordered_map`. It also underpins compile-time branching in [[template-metaprogramming]].

## How it works

Two flavors, with very different rules:

| Form | Applies to | Picks by |
|---|---|---|
| Full (explicit) | classes & functions | exact argument match |
| Partial | **classes only** | pattern match on a *family* |

- **Full**: `template<> struct Trait<int> { ... };` — a concrete drop-in for exactly `int`.
- **Partial**: `template<class T> struct Trait<T*> { ... };` — matches *any* pointer. Functions **cannot** be partially specialized; overload them or dispatch to a class instead.
- The compiler chooses the **most specialized** matching version (partial-ordering rules); ambiguous partials are an error.
- A full specialization is *not* a template — if it lives in a header and isn't `inline`, multiple TUs violate the ODR. Declare it in the header, define once, or mark members `inline`.

## Example

```cpp
template<class T> struct TypeName       { static constexpr auto v = "other"; };
template<>        struct TypeName<int>  { static constexpr auto v = "int";   }; // full
template<class T> struct TypeName<T*>   { static constexpr auto v = "ptr";   }; // partial

TypeName<double>::v;  // "other"  (primary)
TypeName<int>::v;     // "int"    (full beats primary)
TypeName<char*>::v;   // "ptr"    (partial matches the T* family)
```

`int*` would match *both* `int` and `T*` candidates if an `<int*>` full spec existed — the most-specialized rule resolves it.

## Pitfalls

- **Functions can't be partially specialized.** Attempting `template<class T> void f<T*>(...)` is ill-formed; use [[function-overloading]] or tag dispatch instead.
- **A full specialization is a real definition**, so it must obey the ODR — put the body in one `.cpp` or mark it `inline`, or get duplicate-symbol link errors.
- **Specialization must be visible before first use**; specializing *after* the primary was already instantiated for those args is undefined behavior, often a silent wrong pick.
- **`std::` specializations** are only legal for *your own* types and must follow the type's stated requirements; specializing for a standard type is UB. Modern code often prefers [[concepts-c-20]] constraints over a thicket of partials.

## See also

- [[sfinae]]
- [[template-metaprogramming]]
- [[concepts-c-20]]
