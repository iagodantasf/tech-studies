---
title: Variables and Constants
track: cpp
group: Basics / Syntax
tags: [cpp, variables]
prerequisites: [data-types]
see-also: [auto-and-type-inference, constexpr-functions]
---

# Variables and Constants

A variable names a typed, mutable region of storage; a constant binds a name to a value that must not change, with several flavors that differ in *when* the value is known.

## Why it matters

Choosing the right constant kind is a real performance and correctness lever, not pedantry. `constexpr` values fold into the instruction stream and enable compile-time sizing (array bounds, `template` args); `const` lets the compiler reason about aliasing and de-duplicate string literals into read-only `.rodata`; uninitialized locals are a classic source of [[memory-model-data-races|UB]] and flaky bugs.

## How it works

A declaration introduces a name; a definition allocates storage. Initialization style matters — prefer **brace init** `int x{5};`, which bans narrowing (`int x{3.9};` won't compile).

- **`const`** — runtime-immutable after init; can be set from a runtime value.
- **`constexpr`** — value must be a compile-time constant; implies `const`. Usable as an array size or non-type [[class-templates|template]] argument.
- **`constinit`** (C++20) — forces compile-time *initialization* (kills the static-init-order fiasco) but the object stays mutable.
- **`static`** (local) — one instance, lazily and thread-safely initialized on first pass.

| Kind | Value known at | Mutable | Use as array size |
|---|---|---|---|
| `int x` | runtime | yes | no |
| `const int x` | runtime | no | no |
| `constexpr int x` | compile time | no | yes |
| `constinit int x` | compile time | yes | no |

See [[auto-and-type-inference]] for letting the compiler deduce the type.

## Example

```cpp
constexpr int kBufSize = 256;   // folded; legal array bound
char buf[kBufSize];             // sized at compile time
const int id = readId();        // immutable, but value is runtime
buf[0] = 'x';                   // ok: buf is mutable
// id = 7;                      // error: assignment to const
```

## Pitfalls

- **Uninitialized locals** hold garbage; reading one is UB. Always initialize, ideally with `{}`.
- **`const` is shallow.** A `const` pointer can still mutate its pointee unless it's pointer-*to*-const — see [[const-pointers-pointer-to-const]].
- **`#define` is not a constant.** Macros have no type, no scope, and don't respect namespaces; use `constexpr` instead — see [[preprocessor-macros]].
- **`constexpr` ≠ runtime-only.** A `constexpr` variable in a header is implicitly `inline` (C++17), avoiding ODR violations.

## See also

- [[data-types]]
- [[auto-and-type-inference]]
