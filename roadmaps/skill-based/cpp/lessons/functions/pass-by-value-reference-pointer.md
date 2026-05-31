---
title: Pass by Value / Reference / Pointer
track: cpp
group: Functions
tags: [cpp, parameter-passing]
prerequisites: [parameters-and-arguments, references]
see-also: [move-semantics-rvalue-references, std-span]
---

# Pass by Value / Reference / Pointer

The three ways to hand data to a function — copy it, alias it, or pass its address — each pick a different trade among cost, mutability, and nullability.

## Why it matters

This is the single most common micro-decision in C++ and it has real performance teeth: passing a `std::vector<int>` of 10k elements by value copies ~40 KB and may allocate, while by `const&` copies a pointer. The choice also encodes contract: a reference says "this must exist", a pointer says "this may be null", a value says "I get my own copy you can't see." Getting it wrong leaks performance or invites dangling/null bugs.

## How it works

| Mode | Syntax | Copies? | Null? | Rebind? | Use when |
|---|---|---|---|---|---|
| Value | `f(T x)` | yes | n/a | n/a | small/trivial types, or you need an owned copy |
| const ref | `f(const T& x)` | no | no | no | large read-only inputs |
| ref | `f(T& x)` | no | no | no | in/out parameter, must exist |
| pointer | `f(T* x)` | no (ptr) | yes | yes | optional, or array/C interop |

- Rule of thumb: pass **by value** when `sizeof(T) <= ~2 words` and trivially copyable (e.g. `int`, `std::string_view`); otherwise `const&`.
- To *consume* an argument, take it **by value and `std::move`** into storage, or add a `T&&` overload — see [[move-semantics-rvalue-references]].
- For "view into a contiguous range" prefer [[std-span]] or `std::string_view` over `(ptr, len)` pairs.

## Example

```cpp
void scale(std::vector<double>& v, double k) {   // by ref: mutate in place
  for (double& x : v) x *= k;
}
double sum(const std::vector<double>& v) {       // const ref: read, no copy
  double s = 0; for (double x : v) s += x; return s;
}
```

Calling `sum` on a 1M-element vector copies 8 bytes (a reference), not 8 MB.

## Pitfalls

- **`const&` to a temporary that you stash** dangles: `const auto& r = make_vec();` is fine, but returning `r` or saving it past the full-expression is UB.
- **Pass-by-value "pessimization"**: taking `std::string` by value just to read it forces a copy at every call site.
- **Pointer parameters invite null-deref**; if the thing must exist, use a reference and let the type system enforce it.
- A **`T&` (non-const) parameter cannot bind an rvalue** — `f(x+1)` won't compile, which is often what you want.

## See also

- [[move-semantics-rvalue-references]]
- [[std-span]]
