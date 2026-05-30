---
title: Pseudo code
track: computer-science
group: Foundations
tags: [cs, foundations]
prerequisites: []
see-also: [programming-paradigms]
---

# Pseudo code

Pseudo code is an informal, language-agnostic way to describe an algorithm using plain structured
statements instead of the syntax of any one programming language.

## Why it matters

It lets you reason about *what* an algorithm does before committing to *how* a specific language
expresses it. It's the lingua franca of textbooks, interviews, and design discussions: a Python
programmer and a Rust programmer can read the same pseudo code and agree on the logic. Writing
pseudo code first also separates two hard things — getting the algorithm right, and getting the
syntax right — so you tackle them one at a time.

## How it works

There is no single standard, but good pseudo code shares a few conventions:

- **Sequence** — one statement per line, top to bottom.
- **Assignment** — `total ← 0` (or `total = 0`).
- **Selection** — `if … then … else … end if`.
- **Iteration** — `for i ← 0 to n-1` / `while condition`.
- **Subroutines** — `function name(args) … return value`.
- **Indentation marks blocks**, like Python.

Example — find the maximum of a list:

```
function max(A):
    best ← A[0]
    for i ← 1 to length(A) - 1:
        if A[i] > best:
            best ← A[i]
    return best
```

The goal is to be precise enough to translate mechanically into code, but free of language noise
(no semicolons, imports, or memory management).

## Example

Most lessons in this track open with pseudo code before any concrete implementation —
[[searching]] states binary search as an invariant-driven loop in pseudo code first, then links a
runnable Rust version in `playgrounds/rust/binary-search`.

## Pitfalls

- **Too vague** — "sort the list" hides the very thing you're trying to describe. Spell out the steps.
- **Too concrete** — if it has full Java syntax, it's just Java. Drop the ceremony.
- **Ambiguous indexing** — be explicit about 0- vs 1-based and inclusive vs exclusive bounds; this is
  where off-by-one bugs are born.

## See also

- [[programming-paradigms]]
