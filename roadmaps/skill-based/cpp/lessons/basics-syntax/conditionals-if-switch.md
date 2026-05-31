---
title: Conditionals (if / switch)
track: cpp
group: Basics / Syntax
tags: [cpp, control-flow]
prerequisites: [operators]
see-also: [loops-for-while-do-while, utility-types-pair-tuple-optional-variant-any]
---

# Conditionals (if / switch)

`if`/`else` branch on a boolean; `switch` does a multi-way jump on an integral or enum value, often compiled to a jump table for `O(1)` dispatch.

## Why it matters

`switch` on a dense set of cases lowers to a jump table — constant-time regardless of case count — whereas a chain of `if`s is linear; for hot dispatch (bytecode interpreters, state machines) this is measurable. C++17's **init-statement** (`if (auto x = f(); cond)`) scopes a variable to the branch, a clean pattern for lock guards, `std::optional` unwrapping, and error checks.

## How it works

- **`if (init; cond)`** and **`switch (init; cond)`** (C++17) declare a variable visible only inside the statement and its `else` — tighter scope, fewer leaks into the enclosing block.
- **`if constexpr`** (C++17) discards the untaken branch *at compile time* — essential in [[function-templates|templates]] to avoid instantiating invalid code.
- **`switch`** requires integral/enum/`constexpr`-convertible conditions; non-matching falls to `default` if present.
- **`[[likely]]` / `[[unlikely]]`** (C++20) hint the branch predictor for codegen.

| Construct | Dispatch | Compile-time | Typical use |
|---|---|---|---|
| `if/else if` | linear | no | few, complex conditions |
| `switch` | jump table | no | dense integral cases |
| `if constexpr` | none | yes | template branch pruning |

## Example

```cpp
if (auto it = cache.find(key); it != cache.end())
    return it->second;             // it scoped to the if/else only

switch (token.kind) {
    case Plus:  emit_add(); break; // break: no fall-through
    case Minus: emit_sub(); break;
    default:    error();           // catch-all
}

template <class T> void f(T v) {
    if constexpr (std::is_pointer_v<T>) use(*v);  // other branch never compiled
    else use(v);
}
```

## Pitfalls

- **Missing `break`** falls through to the next case — sometimes intended (mark with `[[fallthrough]];`), usually a bug.
- **Declaring a variable in a `case` without braces** can skip its initialization; wrap the case body in `{ }`.
- **`if (x = 5)`** assigns then tests truthiness — meant `==`. Enable `-Wparentheses`; or write `if (5 == x)`.
- **Runtime `if`, not `if constexpr`**, on a type trait still compiles *both* branches and fails on the invalid one.

## See also

- [[loops-for-while-do-while]]
- [[operators]]
