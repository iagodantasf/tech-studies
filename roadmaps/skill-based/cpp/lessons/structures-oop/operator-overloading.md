---
title: Operator Overloading
track: cpp
group: Structures & OOP
tags: [cpp, operators]
prerequisites: [classes-objects, operators]
see-also: [copy-move-constructors, friend-functions-classes, this-pointer]
---

# Operator Overloading

Operator overloading gives built-in syntax (`+`, `==`, `[]`, `<<`) custom meaning for your types, so user-defined types read like the primitives they model.

## Why it matters

It is what makes `std::string a = b + c;`, `cout << x`, `m[key]`, and iterator `*it`/`++it` work — the STL's whole interface is operators. Done well it makes numeric, container, and smart-pointer types transparent; done badly it hides expensive copies or surprising semantics behind innocent-looking symbols. C++20's `operator<=>` ("spaceship") collapses six comparison operators into one.

## How it works

Most operators may be members or free functions; choose **member** when the left operand is your type and you need access to internals, **free** (often `friend`) when the left operand isn't yours — e.g. `ostream& operator<<(ostream&, const T&)` ([[friend-functions-classes]]).

| Operator | Conventional form | Returns |
|---|---|---|
| `a + b` | free; implement via `+=` | by value |
| `a += b` | member | `T&` (`*this`) |
| `a == b` | free or `= default` (C++20) | `bool` |
| `a <=> b` | member, often `= default` | ordering |
| `*p`, `p->` | member | `T&` / `T*` |

- Cannot overload `::`, `.`, `.*`, `?:`, `sizeof`, or invent new symbols.
- `++x` (prefix) returns `T&`; `x++` (postfix) takes a dummy `int` and returns the old value by copy — favor prefix.
- C++20: a defaulted `operator<=>` plus `operator==` auto-generates `<`, `>`, `<=`, `>=`.

## Example

```cpp
struct V2 {
  double x, y;
  V2& operator+=(const V2& o) { x += o.x; y += o.y; return *this; }
  auto operator<=>(const V2&) const = default;   // all 6 comparisons
};
V2 operator+(V2 a, const V2& b) { return a += b; } // reuse +=, by value
```

Implementing `+` in terms of `+=` avoids duplicated logic and gives the canonical by-value result.

## Pitfalls

- **Returning by reference from `+`** dangles (the result is a temporary); arithmetic operators return by value.
- **Asymmetric conversions**: a member `operator+` won't allow `2 + obj`; a free function lets both operands convert.
- Overloading `&&`, `||`, or `,` **loses short-circuit / sequencing** — almost always a bug.
- Forgetting `return *this;` from compound-assignment operators breaks chaining (`(a += b) += c`).

## See also

- [[copy-move-constructors]]
- [[friend-functions-classes]]
- [[this-pointer]]
