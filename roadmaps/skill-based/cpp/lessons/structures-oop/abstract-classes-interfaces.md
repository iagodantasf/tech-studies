---
title: Abstract Classes & Interfaces
track: cpp
group: Structures & OOP
tags: [cpp, interfaces]
prerequisites: [polymorphism-virtual-functions, inheritance]
see-also: [classes-objects, encapsulation, concepts-c-20]
---

# Abstract Classes & Interfaces

A class with at least one **pure virtual** function (`= 0`) is *abstract*: it cannot be instantiated and exists only to define a contract that derived classes must implement.

## Why it matters

Abstract classes are C++'s closest equivalent to a Java/C# interface — they decouple "what" from "how", letting callers depend on a stable API while implementations vary (dependency inversion). A pure-virtual base is the canonical way to define a plugin boundary, a mockable seam for testing, or a strategy that can be swapped at runtime.

## How it works

`virtual T f() = 0;` declares a pure virtual; a class holding any (declared or inherited-but-unoverridden) is abstract.

- An abstract class **cannot** be an object, but you can hold a `Base*` / `Base&` / `unique_ptr<Base>` to a concrete derived ([[polymorphism-virtual-functions]]).
- A derived class stays abstract until it overrides **every** pure virtual; otherwise it too is abstract.
- A pure virtual **may still have a definition** (`void f() override = 0; ... void Base::f(){}`), callable via `Base::f()` to share default logic.
- An **interface** in C++ idiom = an abstract class with only pure virtuals, a virtual destructor, and no data members.
- For *compile-time* polymorphism over a contract, prefer [[concepts-c-20]] — no vtable, errors at the call site.

## Example

```cpp
struct Logger {                       // pure interface
  virtual void log(std::string_view) = 0;
  virtual ~Logger() = default;        // required for delete-through-base
};
struct FileLogger : Logger {
  void log(std::string_view m) override { /* write to file */ }
};
void run(Logger& l) { l.log("start"); }   // depends only on the contract
// Logger x;            // ERROR: cannot instantiate abstract class
```

`run` is testable by passing a `MockLogger` that also derives from `Logger`.

## Pitfalls

- **Omitting the virtual destructor** in an interface leaks the derived part on `delete` through the base pointer.
- Putting **data members or non-virtual logic** in an "interface" couples all implementers to it — keep interfaces data-free.
- A derived class that misspells the signature **doesn't override** and stays abstract → "cannot instantiate" error; use `override`.
- Deep abstract hierarchies add a vtable indirection per level; for hot paths consider [[concepts-c-20]] or CRTP instead.

## See also

- [[classes-objects]]
- [[encapsulation]]
- [[concepts-c-20]]
