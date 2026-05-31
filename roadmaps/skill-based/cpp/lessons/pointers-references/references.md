---
title: References
track: cpp
group: Pointers & References
tags: [cpp, references]
prerequisites: [pointers, variables-and-constants]
see-also: [pointers, pass-by-value-reference-pointer, move-semantics-rvalue-references, const-pointers-pointer-to-const]
---

# References

A reference is an alias — a second name bound to an existing object — that you use with ordinary syntax, never null, never rebound.

## Why it matters

References are the idiomatic way to pass and return large objects without copying and without the null/arithmetic hazards of pointers. They power [[pass-by-value-reference-pointer]], range-based loops over containers, [[operator-overloading]], and — as rvalue references (`T&&`) — the entire [[move-semantics-rvalue-references]] machinery that makes modern C++ fast.

## How it works

`int& r = x;` binds `r` to `x` for the lifetime of `r`. There is no reference object to take an address of — `&r` gives the address of `x`. A reference **must** be initialized and **cannot** be reseated; assignment writes through to the referent.

| Kind | Binds to | Typical use |
|---|---|---|
| `T&` (lvalue) | named/mutable objects | in-out parameters |
| `const T&` | lvalues *and* temporaries | read-only parameters |
| `T&&` (rvalue) | temporaries / `std::move`d | move ctors, perfect forwarding |

A `const T&` parameter can bind a temporary and extends its lifetime to the reference's scope. Reference vs pointer: a reference is morally a `T* const` that auto-dereferences and forbids null — but unlike a pointer it cannot live in a resizable container (use [[pointers]] or `std::reference_wrapper`). See [[const-pointers-pointer-to-const]] for the const-correctness rules.

## Example

Passing by `const&` avoids a copy of a heavy object; returning `T&` from `operator[]` enables `v[i] = x`:

```cpp
double total(const std::vector<double>& v) {   // no copy of the vector
  double s = 0;
  for (double d : v) s += d;                    // by value: cheap doubles
  return s;
}
int& at(std::vector<int>& v, size_t i) { return v[i]; }
at(v, 3) = 99;                                  // writes into v
```

A common refactor: change a slow `for (auto x : pairs)` to `for (const auto& x : pairs)` to stop copying each element — see [[range-based-for-loop]].

## Pitfalls

- **Dangling reference**: returning a reference to a local, or binding `const T&` to a temporary stored beyond the full-expression, leaves an alias to dead memory — UB. See [[dangling-pointers-memory-leaks]].
- **`auto x = expr;` drops the reference** and copies. Use `auto&` / `const auto&` to keep an alias — see [[auto-and-type-inference]].
- **Reference members make a class non-assignable** (the alias can't rebind). Prefer a pointer member if you need to reseat or copy.
- A named rvalue reference is itself an lvalue — you must `std::move` it again to forward its rvalue-ness.

## See also

- [[pointers]]
- [[move-semantics-rvalue-references]]
- [[pass-by-value-reference-pointer]]
