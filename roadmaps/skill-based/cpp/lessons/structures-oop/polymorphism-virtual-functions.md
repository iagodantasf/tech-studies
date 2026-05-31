---
title: Polymorphism & Virtual Functions
track: cpp
group: Structures & OOP
tags: [cpp, polymorphism]
prerequisites: [inheritance, pointers]
see-also: [abstract-classes-interfaces, classes-objects, constructors-destructors]
---

# Polymorphism & Virtual Functions

A `virtual` function lets a call through a base pointer/reference dispatch to the *derived* override at runtime — the mechanism behind dynamic polymorphism.

## Why it matters

Runtime polymorphism is how one loop over `std::vector<std::unique_ptr<Shape>>` draws circles and squares without knowing their types — the open-closed principle in action. The cost (an indirect call through a vtable, ~1–3 ns and an inhibited inline) is the trade you accept for that flexibility; knowing when it is and isn't paid for is core to writing fast C++.

## How it works

A class with any `virtual` function gets a hidden **vptr** pointing to a per-class **vtable** of function addresses. A virtual call loads the vptr, indexes the vtable, and calls — *dynamic dispatch*.

- Dispatch is dynamic **only** through a pointer or reference; calling through an object (`obj.f()`) or a sliced value is resolved statically.
- Mark every intended override `override` so a signature mismatch (e.g. a stray `const`) is a *compile error* instead of a silent new function.
- A polymorphic base needs a **`virtual` destructor**, or `delete basePtr` skips the derived destructor — UB / leak.
- `final` on an override stops further overriding and may let the compiler **devirtualize**; non-polymorphic dispatch (templates/CRTP) avoids the vtable entirely.

## Example

```cpp
struct Shape { virtual double area() const = 0; virtual ~Shape() = default; };
struct Circle : Shape {
  double r;
  double area() const override { return 3.14159 * r * r; }
};
void print(const Shape& s) { std::cout << s.area(); } // dispatches to Circle
print(Circle{2.0});   // 12.566 — chosen at runtime via the vtable
```

The same `print` works for any future `Shape` subclass without recompilation of `print`.

## Pitfalls

- **Missing `virtual ~Base()`**: deleting a derived object through a `Base*` runs only the base destructor — leaks/UB.
- **Slicing** (passing a derived *by value* as `Base`) discards the dynamic type; dispatch reverts to `Base`.
- **Calling a virtual from a ctor/dtor** uses the current class's override, not the derived one — the object isn't whole yet.
- Forgetting `override` lets a subtly different signature create a *new* function that never gets called; always annotate.

## See also

- [[abstract-classes-interfaces]]
- [[classes-objects]]
- [[constructors-destructors]]
