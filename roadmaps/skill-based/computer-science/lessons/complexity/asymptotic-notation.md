---
title: Asymptotic notation (Big-O, Θ, Ω)
track: computer-science
group: Complexity
tags: [cs, complexity, big-o]
prerequisites: []
see-also: [time-and-space-complexity, sorting, searching]
---

# Asymptotic notation (Big-O, Θ, Ω)

Asymptotic notation describes how a function **grows as the input `n` gets large**, ignoring
constants and lower-order terms so you can compare algorithms by shape, not by hardware.

## Why it matters

Wall-clock time depends on the machine, the language, and the compiler — none of which tell you
whether an algorithm *scales*. Asymptotics strip that noise away: `O(n log n)` beats `O(n^2)` on big
inputs no matter whose laptop runs it. It is the shared vocabulary for every claim about
[[sorting]], [[searching]], and data-structure cost.

## How it works

Three bounds describe a function `T(n)`:

- **Big-O (`O`) — upper bound.** `T(n) = O(g(n))` if eventually `T(n) ≤ c·g(n)`. "Grows no faster
  than." This is the usual worst-case statement.
- **Big-Omega (`Ω`) — lower bound.** `T(n) = Ω(g(n))` if eventually `T(n) ≥ c·g(n)`. "Grows no
  slower than."
- **Big-Theta (`Θ`) — tight bound.** `T(n) = Θ(g(n))` when it is both `O(g(n))` and `Ω(g(n))`.

Two rules do most of the work: **drop constants** (`3n` is `O(n)`) and **keep the dominant term**
(`n^2 + n` is `O(n^2)`). The common growth ladder, slowest-growing first:

| Class | Name | Example |
|---|---|---|
| `O(1)` | constant | hash lookup |
| `O(log n)` | logarithmic | binary [[searching]] |
| `O(n)` | linear | scan an array |
| `O(n log n)` | linearithmic | merge [[sorting]] |
| `O(n^2)` | quadratic | nested loops |
| `O(2^n)` | exponential | brute-force subsets |

Note the distinction from **best/average/worst case**: those pick *which input* you measure; `O`/`Θ`/`Ω`
bound *how a chosen measure grows*. They are orthogonal — you can give a worst-case `Θ`.

## Example

```
# T(n) = n^2 + 3n + 5  →  drop 3n and 5, drop the coefficient
# dominant term is n^2  →  T(n) = Θ(n^2)
for i in 0 … n-1:        # outer loop runs n times
    for j in 0 … n-1:    # inner loop runs n times
        visit(i, j)      # n * n = n^2 total work
```

## Pitfalls

- **Treating `O` as "exactly".** `O` is an upper bound; an `O(n^2)` algorithm is also `O(n^3)`. Use
  `Θ` when you mean tight.
- **Forgetting constants matter in practice.** For small `n`, an `O(n^2)` method can beat an
  `O(n log n)` one with a huge constant. Asymptotics describe the *limit*.
- **Ignoring the variable.** `O(V + E)` on a graph has two inputs; collapsing them hides the real
  cost.

## See also

- [[time-and-space-complexity]]
- [[sorting]]
- [[searching]]
