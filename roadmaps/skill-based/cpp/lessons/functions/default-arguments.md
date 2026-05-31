---
title: Default Arguments
track: cpp
group: Functions
tags: [cpp, functions]
prerequisites: [parameters-and-arguments]
see-also: [function-overloading, declaring-defining-functions]
---

# Default Arguments

A default argument lets the caller omit a trailing parameter, with the compiler substituting a value supplied at the declaration — a lightweight alternative to writing several overloads.

## Why it matters

Defaults shrink call sites and version APIs gracefully: add a trailing `int flags = 0` and every existing caller still compiles. But they are a *call-site* mechanism, not a runtime one — the default is baked in where the function is **called**, which interacts badly with virtual dispatch and across header/library boundaries. Knowing this prevents a classic family of "wrong default got used" bugs.

## How it works

- Defaults bind **right-to-left**: once a parameter has one, every parameter after it must too.
- Put the default on the **declaration in the header**, exactly once; do not repeat it on the definition.
- The expression is evaluated **per call**, at the call site, in the caller's scope — `f()` with `int x = next_id()` calls `next_id()` each time.
- A later declaration in the same scope may *add* defaults to trailing params, but never **redefine** an existing one.

```cpp
void connect(std::string host, int port = 443, int timeout_ms = 5000);
connect("a.com");            // port=443, timeout=5000
connect("a.com", 8080);      // timeout=5000
connect("a.com", , 100);     // ERROR: cannot skip middle argument
```

When you need to vary a *non-trailing* argument, reach for [[function-overloading]] instead.

## Example

```cpp
struct Base   { virtual void f(int x = 10) { std::cout << x; } };
struct Derived: Base { void f(int x = 20) override { std::cout << x; } };

Base* p = new Derived;
p->f();   // prints 10, NOT 20
```

The default `10` is chosen statically from `Base*` (the static type), while the *body* dispatches dynamically to `Derived::f` — a notorious trap.

## Pitfalls

- **Default + virtual** picks the default from the static type and the body from the dynamic type; never give virtuals defaults.
- **Different defaults in different headers** for the same function are an ODR violation — silently uses whichever TU's value.
- Defaults **interfere with overload resolution**: `f(int=0)` and `f()` together make `f()` ambiguous.
- A default that **allocates or calls** runs on every invocation; `= std::string{}` constructs a temporary each call — cheap, but not free.

## See also

- [[function-overloading]]
- [[declaring-defining-functions]]
