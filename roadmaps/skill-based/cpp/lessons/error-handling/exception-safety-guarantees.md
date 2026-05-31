---
title: Exception Safety Guarantees
track: cpp
group: Error Handling
tags: [cpp, exception-safety]
prerequisites: [exceptions-try-catch-throw, raii]
see-also: [exceptions-try-catch-throw, noexcept, the-rule-of-0-3-5, raii]
---

# Exception Safety Guarantees

A four-level contract (Abrahams guarantees) describing what invariants a function preserves if an exception escapes it.

## Why it matters

Without a stated guarantee, a function that throws halfway through can leave an object in a torn, unusable state — half-inserted, double-freed, or leaking. The STL documents these levels per operation, and they drive real API design: `vector::push_back` gives the **strong** guarantee, which is *why* a growing vector requires move constructors to be [[noexcept]] (otherwise it must copy). Knowing the levels lets you reason about whether a partially-completed operation is recoverable.

## How it works

The four levels, weakest to strongest:

| Guarantee | Promise on throw |
|---|---|
| No-throw | never throws (`noexcept`); always succeeds |
| Strong | commit-or-rollback: state is exactly as before |
| Basic | no leaks, all invariants hold, but state may change |
| None | anything — leaks, corruption, UB |

- **Basic** is the *minimum* acceptable bar: nothing leaks and the object is still destructible/assignable, just with an unspecified value.
- **Strong** is usually achieved with **copy-and-swap**: do the risky work on a copy, then swap with a `noexcept` swap as the single commit point ([[the-rule-of-0-3-5]]).
- The strong guarantee can be *expensive* (a full copy) and sometimes impossible for multi-object transactions — basic is often the pragmatic choice.
- [[raii]] gives you the basic guarantee almost for free: scoped owners release on unwind, so "no leak" holds automatically.

## Example

Copy-and-swap delivers the strong guarantee — assignment either fully succeeds or leaves the target untouched:

```cpp
Widget& operator=(Widget rhs) {   // rhs is a copy; if copying throws,
  swap(*this, rhs);               // *this is untouched (nothing changed yet)
  return *this;                   // swap is noexcept => the commit can't fail
}                                 // old state dies in rhs's destructor
```

If the copy of `rhs` throws, we never reached `swap`, so `*this` is byte-for-byte its original value: textbook rollback.

## Pitfalls

- **A throwing move breaks `vector` reallocation's strong guarantee.** `vector` uses `move_if_noexcept`: if your move ctor isn't `noexcept`, it *copies* on grow — silently halving performance.
- **"Strong" composed of two strong steps isn't strong** — if step 2 throws after step 1 committed, you have a partial transaction. Sequence so the throwing work happens *before* any visible mutation.
- **Mutating arguments before the throw point** (e.g. clearing output, advancing an iterator) downgrades you to basic or worse; do lookups/allocations first.
- **A throwing swap or destructor** destroys the whole scheme — both must be `noexcept`.

## See also

- [[exceptions-try-catch-throw]]
- [[noexcept]]
- [[the-rule-of-0-3-5]]
