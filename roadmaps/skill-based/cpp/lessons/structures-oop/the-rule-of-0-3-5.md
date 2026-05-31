---
title: The Rule of 0 / 3 / 5
track: cpp
group: Structures & OOP
tags: [cpp, special-members]
prerequisites: [constructors-destructors, copy-move-constructors]
see-also: [raii, smart-pointers-unique-ptr-shared-ptr-weak-ptr, copy-vs-move]
---

# The Rule of 0 / 3 / 5

A guideline for the five special member functions: define **all** of them or **none** — and ideally none, by letting RAII members manage resources for you.

## Why it matters

Half-defining the special members is one of the most common sources of double-frees, leaks, and silent copies in C++. The rule is a checklist that keeps copy, move, and destruction *consistent*, so a type that owns a resource is correct under every operation — assignment, return-by-value, container reallocation — instead of just the cases you happened to test.

## How it works

The five special members are the destructor, copy ctor, copy assign, move ctor, and move assign.

| Rule | When | What to do |
|---|---|---|
| Rule of 0 | type owns no raw resource | declare *none*; let members' RAII handle it |
| Rule of 3 | pre-C++11 owning type | define dtor + copy ctor + copy assign |
| Rule of 5 | modern owning type | the 3 *plus* move ctor + move assign |

- **Declaring any one** of the five changes what the compiler auto-generates: a user-declared destructor or copy op **suppresses the implicit moves**, so the type silently falls back to copying ([[copy-move-constructors]]).
- **Rule of 0 is the goal**: wrap each raw resource in a [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]] or RAII type, then your class needs no special members and stays correct by composition ([[raii]]).
- **Copy-and-swap** implements both assignments safely (strong exception guarantee, self-assignment safe) from the copy/move ctor plus a `swap`.

## Example

The Rule of 0 in practice — `unique_ptr` supplies all five operations correctly:

```cpp
class Widget {                  // owns a heap resource, yet declares nothing
  std::unique_ptr<Impl> impl_;  // move-only member drives the whole type
  std::vector<int>      data_;
};                              // dtor frees impl_ + data_; moves work; copy is deleted
```

Because `unique_ptr` is move-only, `Widget` is automatically move-only too — no hand-written destructor, no double-free risk.

## Pitfalls

- **Rule of 3, missing the 2 moves**: defining a destructor on a pre-move type means returns and inserts *copy* instead of move — correct but slow, with no warning.
- A user-declared destructor (even `= default`) **disables implicit moves** — `=default` them explicitly if you want moves back.
- Implementing copy assignment without **self-assignment** safety (`if (this != &o)`) or copy-and-swap can free-then-read on `x = x`.
- Mixing a raw owning pointer with `= default` special members gives a shallow copy and a guaranteed double-free.

## See also

- [[raii]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[copy-vs-move]]
