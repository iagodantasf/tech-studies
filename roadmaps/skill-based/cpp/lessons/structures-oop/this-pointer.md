---
title: "`this` Pointer"
track: cpp
group: Structures & OOP
tags: [cpp, this]
prerequisites: [classes-objects, pointers]
see-also: [operator-overloading, static-members, constructors-destructors]
---

# `this` Pointer

`this` is the implicit pointer, passed to every non-static member function, that addresses the object the function was called on.

## Why it matters

Every `member` access inside a method is silently `this->member`, so understanding `this` demystifies how one function body operates on millions of distinct objects. It is essential for returning `*this` to chain operators ([[operator-overloading]]), disambiguating a member from a same-named parameter, and — via C++23's explicit object parameter — writing one method that works for both `const` and non-`const` callers.

## How it works

A call `obj.f(args)` is compiled to `f(&obj, args)`; inside `f`, `this == &obj`. Its type carries the method's cv-qualifiers.

| Method declaration | Type of `this` |
|---|---|
| `void f();` | `T*` |
| `void f() const;` | `const T*` |
| `void f() &&;` | `T*` (rvalue-qualified) |

- `this` is a **prvalue** — you cannot reassign it; `*this` is an lvalue referring to the object.
- [[static-members]] functions have **no** `this`: they are class-scoped free functions and cannot touch non-static members.
- Returning `*this` (type `T&`) enables fluent chaining: `obj.setA(1).setB(2)`.
- C++23 "deducing this": `void f(this Self&& self)` makes the object parameter explicit, deducing const/ref qualifiers and enabling recursive lambdas.

## Example

```cpp
struct Builder {
  int a_ = 0, b_ = 0;
  Builder& setA(int a) { this->a_ = a; return *this; } // disambiguate + chain
  Builder& setB(int b) { b_ = b;       return *this; }
};
Builder{}.setA(1).setB(2);   // each call returns the same object by ref
```

`this->a_` is required only because the parameter is also named `a`; `b_` needs no qualifier.

## Pitfalls

- **`delete this;`** is legal but lethal if the object wasn't `new`-allocated or is touched afterward — a classic dangling-`this` crash.
- Capturing `this` in a [[lambda-expressions]] that outlives the object dangles; capture `*this` by copy (C++17) or a `shared_ptr`.
- Using `this` in a member initializer or constructor before subobjects are built reads half-constructed state.
- Comparing `this` to `nullptr` to "detect a null call" is UB — calling a method on a null pointer was already undefined.

## See also

- [[operator-overloading]]
- [[static-members]]
- [[constructors-destructors]]
