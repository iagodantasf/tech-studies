---
title: Copy / Move Constructors
track: cpp
group: Structures & OOP
tags: [cpp, move-semantics]
prerequisites: [constructors-destructors, move-semantics-rvalue-references]
see-also: [the-rule-of-0-3-5, copy-vs-move, operator-overloading]
---

# Copy / Move Constructors

The copy constructor builds an object as a duplicate of another (`T(const T&)`); the move constructor steals a soon-to-die object's resources (`T(T&&)`) instead of copying them.

## Why it matters

Moves are why returning a `std::vector` or `std::string` by value is cheap — ownership of the heap buffer transfers in a few pointer assignments instead of a deep copy of every element. Defining these correctly (or, better, not defining them and letting `= default` work) decides whether your type is fast, exception-safe, and free of double-frees — see [[move-semantics-rvalue-references]] and [[copy-vs-move]].

## How it works

Overload resolution binds lvalues to `const T&` (copy) and rvalues — temporaries, `std::move(x)` — to `T&&` (move).

| Operation | Signature | Cost on a vector of N |
|---|---|---|
| Copy | `T(const T&)` | O(N) deep copy |
| Move | `T(T&&) noexcept` | O(1) pointer steal |

- A move ctor must leave the source in a **valid but unspecified** state (typically null/empty) so its destructor is safe.
- Mark move operations **`noexcept`**: `std::vector` reallocation only *moves* elements if their move ctor is `noexcept`, else it copies — a silent O(N) perf cliff.
- Declaring a destructor or copy op **suppresses** the implicit move; the compiler then *copies* where you expected a move ([[the-rule-of-0-3-5]]).
- A named rvalue reference parameter is an **lvalue** — you must `std::move` it onward, including into base subobjects.

## Example

```cpp
class Buf {
  int* p_; size_t n_;
public:
  Buf(Buf&& o) noexcept : p_(o.p_), n_(o.n_) { // steal
    o.p_ = nullptr; o.n_ = 0;                  // leave source safe
  }
  Buf(const Buf& o) : p_(new int[o.n_]), n_(o.n_) {
    std::copy(o.p_, o.p_ + n_, p_);            // deep copy
  }
};
```

Omitting `o.p_ = nullptr` would double-free when both destructors run.

## Pitfalls

- **Missing `noexcept`** on the move ctor demotes `vector` growth to copies — measurable slowdown, no error.
- **Forgetting to null the source** after a steal causes a double-free at destruction.
- Declaring `~T()` (even `= default`) quietly disables the implicit move ctor; you fall back to copies.
- **Self-move** (`x = std::move(x)`) must not corrupt the object; guard or use copy-and-swap in assignment.

## See also

- [[the-rule-of-0-3-5]]
- [[copy-vs-move]]
- [[move-semantics-rvalue-references]]
