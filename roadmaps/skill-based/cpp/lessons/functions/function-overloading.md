---
title: Function Overloading
track: cpp
group: Functions
tags: [cpp, overloading]
prerequisites: [parameters-and-arguments]
see-also: [default-arguments, function-templates]
---

# Function Overloading

Overloading lets several functions share a name and be told apart by their parameter lists, with the compiler picking the best match through *overload resolution*.

## Why it matters

It's how `std::cout << x` prints an `int`, a `double`, or a `string` with one syntax, and how a class offers `at(size_t)` plus a `const` overload. The resolution rules are intricate, and the failure modes — "ambiguous call" or, worse, silently choosing the wrong overload via an implicit conversion — are everyday debugging fare. The mangled name in linker errors is overloading made visible.

## How it works

Candidates are ranked by how good the conversion from argument to parameter is:

| Rank | Conversion kind | Example |
|---|---|---|
| 1 (best) | exact / identity | `int` → `int` |
| 2 | promotion | `short` → `int`, `float` → `double` |
| 3 | standard conversion | `int` → `double`, `Derived*` → `Base*` |
| 4 (worst) | user-defined conversion | via a converting constructor |

- Differs **only** by return type? Not an overload — ill-formed.
- Top-level `const` on by-value params doesn't distinguish: `f(int)` vs `f(const int)` clash.
- Resolution is per-scope: a name in a derived class **hides** all base overloads unless you `using Base::f;`.
- Templates compete with non-templates; the non-template wins on an equally good match. See [[function-templates]].

## Example

```cpp
void print(int);
void print(double);
void print(const char*);

print(42);     // print(int)      — exact
print(42.0);   // print(double)   — exact
print('x');    // print(int)      — char promotes to int
print(3.0f);   // print(double)   — float promotes to double
```

`print('x')` calling the `int` overload (not a hypothetical `char` one) surprises people: there is no exact `char` match, so promotion wins.

## Pitfalls

- **`0` / `NULL` ambiguity**: with `f(int)` and `f(char*)`, `f(NULL)` may call `f(int)`; use `nullptr`. See [[nullptr]].
- **Ambiguity from equal-rank conversions**: `f(long)` vs `f(double)` called with an `int` is ambiguous — both are standard conversions.
- **Name hiding** in derived classes silently drops base overloads; the fix is a `using` declaration.
- Combining **overloads with [[default-arguments]]** easily creates ambiguous empty-argument calls.

## See also

- [[default-arguments]]
- [[function-templates]]
