---
title: Inheritance
track: cpp
group: Structures & OOP
tags: [cpp, inheritance]
prerequisites: [classes-objects, access-specifiers]
see-also: [polymorphism-virtual-functions, abstract-classes-interfaces, the-rule-of-0-3-5]
---

# Inheritance

Inheritance derives a new class from an existing one, reusing and extending its members and establishing an "is-a" relationship the type system understands.

## Why it matters

It is the substrate for runtime [[polymorphism-virtual-functions]]: a `Derived*` converts to a `Base*`, letting one code path handle a whole family of types. Used judiciously it expresses genuine subtype relationships (a `Circle` is-a `Shape`); used carelessly for code reuse it creates rigid hierarchies and slicing bugs — modern style often prefers composition or [[abstract-classes-interfaces]].

## How it works

A derived object contains a complete base subobject; construction runs base-first, destruction derived-first ([[constructors-destructors]]).

| Inheritance mode | Public members of base become | Means |
|---|---|---|
| `: public B` | public | "is-a" (the only substitutable one) |
| `: protected B` | protected | implemented-in-terms-of, exposed to subclasses |
| `: private B` | private | implemented-in-terms-of, hidden |

- Only **`public`** inheritance allows a `Derived*`→`Base*` conversion; `private`/`protected` model "has-a" relationships, usually better done by composition.
- A name in `Derived` **hides** all base overloads of that name; reintroduce them with `using B::f;` ([[function-overloading]]).
- **Multiple inheritance** is allowed; a diamond (two paths to one base) duplicates the base unless declared `virtual`.
- `final` on a class forbids further derivation and can devirtualize calls.

## Example

```cpp
struct Base { void greet() { std::puts("base"); } };
struct Derived : Base {
  void greet(int) { std::puts("derived"); } // HIDES Base::greet()
  using Base::greet;                          // bring it back
};
Derived d;
d.greet();      // OK only because of the using-declaration
Base& b = d;    // public inheritance: slice-free reference upcast
```

Without `using Base::greet;`, `d.greet()` fails to compile — the int overload hid the base one.

## Pitfalls

- **Object slicing**: assigning a `Derived` to a `Base` *by value* copies only the base part, dropping derived state and dynamic type — pass by reference/pointer.
- A **non-virtual base destructor** deleting through a `Base*` is UB — see [[polymorphism-virtual-functions]].
- Inheriting for reuse (not is-a) couples you to the base's interface forever; prefer composition.
- The **diamond problem** silently gives two base subobjects unless every middle layer uses `virtual` inheritance.

## See also

- [[polymorphism-virtual-functions]]
- [[abstract-classes-interfaces]]
- [[the-rule-of-0-3-5]]
