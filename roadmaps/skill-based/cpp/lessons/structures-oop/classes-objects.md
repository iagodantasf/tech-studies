---
title: Classes & Objects
track: cpp
group: Structures & OOP
tags: [cpp, classes]
prerequisites: [structs, data-types]
see-also: [access-specifiers, constructors-destructors, encapsulation, this-pointer]
---

# Classes & Objects

A class is a user-defined type bundling data members with the functions that operate on them; an object is a concrete instance of that type occupying storage.

## Why it matters

Classes are how C++ models invariants: by making state `private` and exposing only methods that preserve it, you turn "a valid `Date`" from a convention into something the type system enforces ([[encapsulation]]). Combined with [[constructors-destructors]] they give deterministic resource ownership ([[raii]]), the feature that lets C++ manage files, locks, and memory without a garbage collector.

## How it works

A class declaration introduces a type; defining an object allocates storage and runs a constructor. Member functions receive an implicit [[this-pointer]] to the object they act on.

- **Data members** live inside each object; **static members** are shared (one per class — see [[static-members]]).
- **Member functions** are not stored per-object; they are ordinary functions taking a hidden `this`. Only `virtual` functions add per-object cost via a vptr — see [[polymorphism-virtual-functions]].
- Declaration vs definition: prefer the class in a header, method bodies in a `.cpp` ([[header-source-separation]]); methods defined *inside* the class body are implicitly `inline`.
- A `const` member function promises not to modify the object: `int size() const;` — callable on `const` objects.

## Example

```cpp
class Counter {
  int n_ = 0;                       // private by default
public:
  void tick() { ++n_; }
  int  value() const { return n_; } // const: read-only
};
Counter c;        // object on the stack; n_ initialized to 0
c.tick();         // c.tick()  ==  Counter::tick(&c)
int v = c.value();
```

`value()` being `const` lets it work on a `const Counter&`; `tick()` would not.

## Pitfalls

- **`sizeof` surprises**: a class with one `virtual` function is ~8 bytes larger (the vptr); an empty class is 1 byte, not 0.
- Defining a method body in the header *without* `inline` and including it in two translation units is an ODR violation — link error.
- Marking a method `const` but having it mutate via a non-`const` pointer member compiles (const is shallow) — a silent logical bug.
- Conflating "class" and "object" in design talk leads to putting per-instance data in [[static-members]] by mistake.

## See also

- [[access-specifiers]]
- [[constructors-destructors]]
- [[this-pointer]]
