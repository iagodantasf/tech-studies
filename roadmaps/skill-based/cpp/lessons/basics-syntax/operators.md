---
title: Operators
track: cpp
group: Basics / Syntax
tags: [cpp, operators]
prerequisites: [data-types]
see-also: [operator-overloading, bit-manipulation]
---

# Operators

Operators are built-in symbolic functions — arithmetic, relational, logical, bitwise, assignment — governed by fixed precedence, associativity, and (since C++17) defined evaluation order.

## Why it matters

Precedence and evaluation-order surprises cause real bugs: `a & b == c` parses as `a & (b == c)` because `==` binds tighter than `&`. Short-circuit evaluation of `&&`/`||` is a load-bearing idiom (`p && p->ok()` guards a null deref). And the three-way `<=>` operator (C++20) collapses the six comparison operators you used to hand-write into one.

## How it works

Each operator has a precedence level and an associativity. A few high-leverage facts:

- **`&&` / `||` short-circuit**: the right operand is *not* evaluated if the left decides the result. There's a sequence point between them.
- **Bitwise** (`& | ^ ~ << >>`) operate per-bit — see [[bit-manipulation]]. Lower precedence than comparison, so parenthesize.
- **Ternary** `c ? a : b` is the only ternary operator and yields a value.
- **`<=>`** (spaceship, C++20) returns an ordering; `== != < <= > >=` can be auto-generated from it.

| Operators | Assoc | Note |
|---|---|---|
| `::` | L→R | tightest |
| `* / %` | L→R | above `+ -` |
| `<< >>` | L→R | below `+ -` |
| `& ^ \|` | L→R | below `== !=` |
| `&& \|\|` | L→R | short-circuits |
| `= += ?:` | R→L | loosest |

User types add behavior via [[operator-overloading]].

## Example

```cpp
int flags = READ | WRITE;          // OK: | result feeds =
if (flags & WRITE == 0) {}         // BUG: parses as flags & (WRITE==0)
if ((flags & WRITE) == 0) {}       // correct

bool ok = ptr && ptr->valid();     // short-circuit guards the deref
auto r = (a <=> b);                // std::strong_ordering in C++20
```

## Pitfalls

- **Bitwise vs comparison precedence**: always parenthesize `(x & MASK) == y`.
- **Modifying a value twice between sequence points** — `i = i++ + 1;` was UB pre-C++17 and still confusing; avoid.
- **Integer division truncates**: `5 / 2 == 2`; `5 % -3` is implementation-leaning — know your signs.
- **`<<` is overloaded** for both shifting and stream output ([[input-output-iostream]]); `std::cout << a << b` chains via L→R associativity.

## See also

- [[operator-overloading]]
- [[bit-manipulation]]
