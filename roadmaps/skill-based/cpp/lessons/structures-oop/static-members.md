---
title: Static Members
track: cpp
group: Structures & OOP
tags: [cpp, static]
prerequisites: [classes-objects, variables-and-constants]
see-also: [this-pointer, friend-functions-classes, classes-objects]
---

# Static Members

A static member belongs to the class itself, not to any object: one shared variable or a function with no [[this-pointer]], accessed as `Class::member`.

## Why it matters

Static data is the idiomatic place for per-class shared state — an instance counter, a config singleton, a cached lookup table — without a global variable polluting the namespace. Static functions are factories and helpers that conceptually belong to the type but need no object. The C++17 `inline` keyword finally let you define a static member entirely in a header, removing decades of "undefined reference" friction.

## How it works

There is exactly one copy of a static data member for the whole program; static functions can be called with no instance.

- **Definition rule (pre-C++17)**: a non-`const` static member needs a separate out-of-class definition in one `.cpp`, or the linker errors. `inline static` (C++17) or `static constexpr` defines it in-class — no `.cpp` line.
- Static **functions** have no `this`, so they cannot read non-static members but *can* access `private` statics of the class.
- Initialization across translation units is **unordered** — the "static initialization order fiasco"; defer with a function-local static (Meyers singleton) which inits on first use, thread-safely since C++11.
- A `static constexpr` member is a compile-time constant usable in array bounds and templates.

## Example

```cpp
struct Widget {
  inline static int count = 0;      // C++17: defined here, no .cpp needed
  Widget()  { ++count; }
  ~Widget() { --count; }
  static int alive() { return count; }   // no 'this'
};
Widget a, b;
int n = Widget::alive();            // 2 — class-scoped call
```

`count` is shared: both objects increment the single variable; `alive()` reads it without an instance.

## Pitfalls

- **Static init order fiasco**: one global static using another from a different `.cpp` may see it un-initialized; use a function-local static instead.
- Forgetting the out-of-class definition of a non-`inline` static yields a link-time "undefined reference", not a compile error.
- Static members are **shared across threads** — increments need [[atomics]] or a mutex to avoid data races ([[memory-model-data-races]]).
- Calling a static function via an instance (`obj.alive()`) compiles but misleads readers; prefer `Widget::alive()`.

## See also

- [[this-pointer]]
- [[friend-functions-classes]]
- [[classes-objects]]
