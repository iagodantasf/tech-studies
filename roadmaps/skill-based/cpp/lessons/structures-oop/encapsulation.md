---
title: Encapsulation
track: cpp
group: Structures & OOP
tags: [cpp, encapsulation]
prerequisites: [access-specifiers, classes-objects]
see-also: [friend-functions-classes, constructors-destructors, the-rule-of-0-3-5]
---

# Encapsulation

Encapsulation bundles data with the operations that act on it and hides the representation behind a controlled interface, so external code depends on *behavior*, not *layout*.

## Why it matters

It is what lets a class guarantee its invariants: if a `Temperature`'s kelvin field is `private` and the only mutators reject negatives, "no negative kelvin" becomes a property the compiler helps enforce, not a comment. It also preserves change freedom — you can swap a `std::vector` for a flat hash map internally without touching a single caller, the foundation of stable APIs and ABI in libraries.

## How it works

Encapsulation is enforced through [[access-specifiers]]: `private` data, a `public` method interface, and `const`-correct accessors.

- **Invariants** are conditions a valid object always satisfies; constructors establish them and only member functions (which you control) can change state ([[constructors-destructors]]).
- Prefer **behavior-rich methods** over getter/setter pairs — exposing `set_x`/`get_x` for every field is "anemic" and leaks the representation just as plain `public` data would.
- The **pImpl idiom** (pointer to an implementation struct) hides *all* members behind an opaque pointer, giving a stable ABI and faster recompiles by breaking the header dependency.
- Encapsulation is per-class and intentional holes use [[friend-functions-classes]]; it is access control, **not** a security boundary.

## Example

A class can validate on every mutation because no other code can reach the field:

```cpp
class Percent {
  int v_;                          // invariant: 0 <= v_ <= 100
public:
  explicit Percent(int v) { set(v); }
  void set(int v) { v_ = std::clamp(v, 0, 100); }  // enforced here
  int  value() const { return v_; }
};
```

Making `v_` public would let any code write `p.v_ = 999`, destroying the invariant the rest of the class relies on.

## Pitfalls

- **Anemic getters/setters** for every field encapsulate nothing — callers still couple to the field set; expose intent-level operations instead.
- Returning a **non-const reference/pointer to a private member** (`std::vector<int>& data()`) hands out a back door that bypasses your invariants.
- `const` is *shallow*: a `const` method can still mutate the pointee of a member pointer, silently breaking logical constness.
- Overusing `friend` or `protected` data re-opens the encapsulation you built; grant access narrowly.

## See also

- [[friend-functions-classes]]
- [[constructors-destructors]]
- [[the-rule-of-0-3-5]]
