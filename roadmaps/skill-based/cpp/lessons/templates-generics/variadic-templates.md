---
title: Variadic Templates
track: cpp
group: Templates & Generics
tags: [cpp, variadic-templates]
prerequisites: [function-templates, move-semantics-rvalue-references]
see-also: [utility-types-pair-tuple-optional-variant-any, function-objects-std-function, template-metaprogramming]
---

# Variadic Templates

A variadic template takes a *parameter pack* — zero or more template arguments — enabling type-safe functions and classes over an arbitrary number of types.

## Why it matters

They power `std::tuple`, `std::variant`, `std::make_unique`, `emplace_back`, and every type-safe `printf` replacement. Before C++11 the only way to take "any number of args" was C varargs (`...` / `va_arg`), which is type-unsafe and breaks on non-trivial types. Variadic templates give the same flexibility with full type checking and perfect forwarding, generated at compile time.

## How it works

`template<typename... Ts> void f(Ts... args);` — `Ts` is a *type* pack, `args` a *function* pack. You operate on packs by **expansion**, written `pattern...`.

| Construct | Meaning |
|---|---|
| `Ts...` | expand the type pack |
| `args...` | expand the value pack |
| `sizeof...(Ts)` | element count (compile-time) |
| `f(forward<Ts>(args)...)` | perfect-forward every element |
| `(args + ...)` | C++17 unary fold, left |

- Pre-C++17 you process a pack by **recursion**: a one-arg base case plus a `head, tail...` step.
- **C++17 fold expressions** collapse a pack with a binary operator in one line: `(... + args)` (left), `(args + ...)` (right), or with an init value `(0 + ... + args)`. They eliminate most recursion.
- Packs combine with `std::forward<Ts>(args)...` for **perfect forwarding**, preserving each argument's value category (the forwarding-reference rule from [[function-templates]]).

## Example

```cpp
template<typename... Args>
auto sum(Args... xs) { return (xs + ...); }      // C++17 right fold

template<typename... Args>                        // perfect forwarding
void log(Args&&... a) { (std::cout << ... << std::forward<Args>(a)); }

sum(1, 2, 3, 4);        // 10, expands to ((1+(2+(3+4))))
log("x=", 42, '\n');    // streams each arg once, no temporaries copied
```

`sum` with 4 args instantiates one function with the fold inlined; there is no runtime loop and no `va_list`.

## Pitfalls

- **Empty packs**: a fold over `&&`/`||`/`,` has a defined identity, but other operators (`+`, `*`) on an *empty* pack are ill-formed — give a binary fold with an init value or guard with `sizeof...`.
- **Expansion only works in pack contexts** — you can't index `args[i]` at runtime; you expand the whole pack or recurse. Indexing needs `std::get` on a captured `std::tuple`.
- **`Args&&...` is a forwarding pack**, so it's greedy and steals overloads just like the single-arg case; forgetting `std::forward` silently copies instead of moves.
- **Recursive (pre-fold) implementations** can explode compile time and instantiation depth for large packs; prefer folds or `std::index_sequence` tricks.

## See also

- [[utility-types-pair-tuple-optional-variant-any]]
- [[function-objects-std-function]]
- [[template-metaprogramming]]
