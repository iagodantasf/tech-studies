---
title: Parameters and Arguments
track: cpp
group: Functions
tags: [cpp, functions]
prerequisites: [declaring-defining-functions]
see-also: [pass-by-value-reference-pointer, default-arguments]
---

# Parameters and Arguments

A *parameter* is the variable in a function's declaration; an *argument* is the concrete value you bind to it at the call site — and the rules of that binding (conversions, order, lifetime) are where surprises live.

## Why it matters

Every API boundary is a parameter list. Choosing `const std::string&` vs `std::string` vs `std::string_view` for a parameter directly drives whether a call copies, allocates, or just aliases bytes — measurable in hot loops. And because C++ allows implicit conversions on arguments, a call can silently compile by truncating a `double` to `int` or constructing a temporary you didn't intend.

## How it works

- **Parameter** = the named slot (`void f(int n)` — `n`). **Argument** = the value passed (`f(42)` — `42`).
- Arguments undergo *copy-initialization* into parameters, allowing one user-defined conversion plus standard conversions.
- **Evaluation order of arguments is unsequenced** (still, through C++23) — `f(g(), h())` may run `h()` first.
- Top-level `const` on a *by-value* parameter is ignored for the signature: `f(int)` and `f(const int)` are the same function.

| You write | Parameter type | Cost of the bind |
|---|---|---|
| `f(std::string s)` | by value | copy or move construct |
| `f(const std::string& s)` | by ref-to-const | none; binds temporaries too |
| `f(std::string_view s)` | view | none; non-owning, 16 bytes |

See [[pass-by-value-reference-pointer]] for the full trade-off and [[default-arguments]] for omitted trailing arguments.

## Example

```cpp
void log(int level, const std::string& msg);
log(2, "boot");        // "boot" -> temporary std::string, bound to const&
log(2.9, "boot");      // 2.9 -> 2 (narrowing!), compiles with a warning
```

The second call passes `2`, not `2.9` — the `double`→`int` conversion happens before `log` runs.

## Pitfalls

- **Unspecified argument evaluation order**: `v[i] = f(i++)` is a bug; don't depend on left-to-right.
- **Binding a `const&` parameter to a temporary** is fine *inside* the call, but storing that reference for later use dangles once the temporary dies.
- **Implicit narrowing** on arguments (`double`→`int`) compiles silently; brace-init `{}` would reject it.
- An **unnamed parameter** `void f(int)` is legal and useful to silence "unused parameter" while keeping the signature.

## See also

- [[pass-by-value-reference-pointer]]
- [[default-arguments]]
