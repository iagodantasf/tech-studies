---
title: Programming paradigms
track: computer-science
group: Foundations
tags: [cs, foundations, paradigms]
prerequisites: []
see-also: [pseudo-code]
---

# Programming paradigms

A programming paradigm is a style of structuring programs — a set of ideas about how computation
should be expressed. The big three are **procedural**, **object-oriented**, and **functional**.

## Why it matters

Languages bake assumptions into their design, and the paradigm is the deepest of those assumptions.
Knowing the paradigms lets you read unfamiliar code, choose the right tool, and recognize that
"a class with one method" or "a tangle of nested loops" might be the same problem expressed in
different styles. Most modern languages are *multi-paradigm*, so the skill is mixing them
deliberately rather than by accident.

## How it works

- **Procedural / imperative** — the program is a sequence of statements that change state. You tell
  the machine *how* to do something, step by step. C and Go lean this way.
  ```
  total = 0
  for x in items: total += x
  ```
- **Object-oriented (OOP)** — state and the behavior that operates on it are bundled into objects.
  Core ideas: encapsulation, inheritance, polymorphism. Java, C#, Ruby.
  ```
  cart.add(item); cart.total()
  ```
- **Functional (FP)** — computation is the evaluation of pure functions; data is immutable and you
  avoid side effects. Functions are values you can pass around. Haskell is pure FP; JavaScript,
  Python, and Rust borrow heavily from it.
  ```
  total = reduce(add, items, 0)
  ```

Two cross-cutting distinctions:

- **Imperative vs declarative** — *how* (loops, mutation) vs *what* (SQL, regex, React's UI).
- **Pure vs side-effecting** — whether a function's only effect is its return value.

## Example

The `max` routine in [[pseudo-code]] is procedural (a loop mutating `best`). The same logic is
functional as `reduce(max, A)` — no visible loop, no mutation. Same result, different paradigm.

## Pitfalls

- **Treating a paradigm as a religion** — forcing deep inheritance hierarchies or point-free FP where
  a plain loop would be clearer.
- **Hidden state in "functional" code** — a function that reads a global or mutates an argument is
  not pure, and you lose the reasoning benefits.
- **Confusing OOP with classes** — OOP is about message-passing and encapsulation; using `class` as a
  namespace for static helpers isn't really object-oriented.

## See also

- [[pseudo-code]]
