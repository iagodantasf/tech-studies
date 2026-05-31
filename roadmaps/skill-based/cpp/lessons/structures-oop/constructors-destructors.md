---
title: Constructors & Destructors
track: cpp
group: Structures & OOP
tags: [cpp, lifetime]
prerequisites: [classes-objects, object-lifetime]
see-also: [copy-move-constructors, raii, the-rule-of-0-3-5]
---

# Constructors & Destructors

A constructor establishes a class's invariants when an object comes into existence; a destructor releases its resources when the object dies — the pair that makes [[raii]] work.

## Why it matters

This pair is the spine of deterministic resource management: a lock acquired in a constructor and released in a destructor cannot leak even if an exception unwinds the stack. It is why C++ needs no `finally` and no garbage collector — see [[object-lifetime]]. Getting initialization order and destructor `noexcept` right is the difference between a tight RAII type and a double-free.

## How it works

Constructors run base classes first, then members **in declaration order** (not init-list order), then the body. Destructors run the exact reverse.

- **Member init list** `: a_(x), b_(y)` initializes; assigning in the body instead *default-constructs then assigns* — slower and impossible for `const`/reference members.
- Special members the compiler may generate: default ctor, copy/move ctor, copy/move assign, destructor — see [[the-rule-of-0-3-5]] and [[copy-move-constructors]].
- `explicit` blocks implicit conversions: `explicit Buf(int);` stops `Buf b = 5;` and accidental conversions in overload resolution.
- A **destructor must not throw**; it is implicitly `noexcept`. Throwing during stack unwinding calls `std::terminate`.
- Delegating ctor: `Foo() : Foo(0) {}` reuses another ctor; `= default` / `= delete` request or forbid a special member.

## Example

Declaration order, not list order, drives initialization:

```cpp
struct W {
  int a_;
  int b_;
  W(int x) : b_(x), a_(b_) {}   // a_ runs FIRST (declared first):
};                              // reads b_ before it is set -> garbage
```

The fix is to list members so dependencies are declared earlier; compilers warn with `-Wreorder`.

## Pitfalls

- **Calling a `virtual` from a ctor/dtor** dispatches to the *current* class, not the derived override — the object isn't fully formed yet.
- **`-Wreorder` bug**: init list reordered relative to declaration silently uses uninitialized members.
- Forgetting to free a raw resource in the destructor leaks; prefer [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]] so the dtor is `= default`.
- A throwing destructor during unwinding terminates the program; mark cleanup `noexcept` and swallow errors.

## See also

- [[copy-move-constructors]]
- [[raii]]
- [[the-rule-of-0-3-5]]
