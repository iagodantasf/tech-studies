---
title: Const Pointers / Pointer to Const
track: cpp
group: Pointers & References
tags: [cpp, const-correctness]
prerequisites: [pointers, variables-and-constants]
see-also: [pointers, references, nullptr, smart-pointers-unique-ptr-shared-ptr-weak-ptr]
---

# Const Pointers / Pointer to Const

`const` on a pointer can lock either the pointee (you can't write *through* it) or the pointer itself (you can't *reseat* it) — two independent guarantees.

## Why it matters

Const-correctness is how C++ encodes read-only intent in the type system: a `const T*` parameter promises a function won't mutate the buffer you pass, which the compiler enforces and the optimizer exploits. APIs taking `const char*` / `const T*` are everywhere, and getting the placement right is a perennial source of confusion.

## How it works

Read the declaration **right-to-left** from the variable name. Whatever `const` sits left of the `*` qualifies the pointee; `const` right of the `*` qualifies the pointer.

| Declaration | Pointee writable? | Pointer reseatable? | Reads as |
|---|---|---|---|
| `int* p` | yes | yes | pointer to int |
| `const int* p` | no | yes | pointer to const int |
| `int* const p` | yes | no | const pointer to int |
| `const int* const p` | no | no | const pointer to const int |

`const int*` and `int const*` are identical (east vs west const). You may take a `const T*` to a non-const object — adding read-only restriction is always allowed — but going the other way needs `const_cast`, and writing through a stripped pointer to an originally-`const` object is undefined behavior.

## Example

A const pointee blocks writes through that name while the underlying object stays mutable elsewhere:

```cpp
int x = 1, y = 2;
const int* pc = &x;   // pointer to const int
*pc = 9;              // ERROR: cannot write through pc
pc = &y;              // OK: reseat pc to y

int* const cp = &x;   // const pointer
*cp = 9;              // OK: x == 9
cp = &y;              // ERROR: cannot reseat cp
```

A `const T* const` is the closest raw analog to a `const T&` [[references]] — both fix target and forbid writes — but only the pointer can be [[nullptr]].

## Pitfalls

- **Reading right-to-left is the only reliable parse.** "`const` binds to what's on its left, except at the start of the declaration where it binds right."
- **Top-level const on a by-value parameter is ignored** for the function's signature: `void f(int* const)` and `void f(int*)` are the *same* function and can't both be declared.
- **`const_cast` away + write to a truly-const object is UB**, even if it compiles. Only cast away const you know was added on top of a mutable object.
- **`const std::unique_ptr<T>`** fixes the pointer but still lets you mutate `*p`; for a const pointee use `unique_ptr<const T>` — see [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]].

## See also

- [[pointers]]
- [[references]]
- [[nullptr]]
