---
title: Common Runtimes
track: datastructures-and-algorithms
group: Common runtimes
tags: [datastructures-and-algorithms, complexity]
prerequisites: [big-o-notation, how-to-calculate-complexity]
see-also: [constant, logarithmic, linear, polynomial, exponential, factorial]
---

# Common Runtimes

The handful of growth-rate classes — O(1), O(log n), O(n), O(n log n), O(n²), O(2ⁿ), O(n!) — that almost every algorithm's [[asymptotic-notation]] cost collapses into.

## Why it matters

When you estimate cost or read a complexity table, you are pattern-matching against this short list, not deriving from scratch. Knowing the ladder lets you reject a design before coding it: an O(n²) scan over 10⁶ rows is ~10¹² ops (minutes), while O(n log n) is ~2×10⁷ (milliseconds). The gap between adjacent classes dwarfs any constant factor, so the *class* is the first thing to get right — micro-optimizing within the wrong one is wasted effort.

## How it works

Order from cheapest to most expensive, with a feel for how each scales as `n` doubles:

| Class | Name | Doubling n does... | Typical source |
|---|---|---|---|
| O(1) | [[common-runtimes]] | nothing | array index, hash lookup |
| O(log n) | [[common-runtimes]] | +1 step | [[searching]], balanced-tree descend |
| O(n) | [[common-runtimes]] | doubles | single scan, [[searching]] |
| O(n log n) | linearithmic | a bit more than doubles | [[sorting]], comparison sorts |
| O(n²) | quadratic ([[common-runtimes]]) | ×4 | nested loops, all-pairs |
| O(2ⁿ) | [[common-runtimes]] | squares | subsets, naive recursion |
| O(n!) | [[common-runtimes]] | ×(n+1) | permutations, brute-force TSP |

- Only the **dominant term** survives: `3n² + 1000n + 50` is O(n²) — see [[time-and-space-complexity]].
- O(n log n) is the comparison-sort lower bound; below O(n) you cannot even read all input once.
- The polynomial/exponential boundary is the practical "tractable vs not" line ([[complexity-classes]]).

## Example

Concrete op counts at `n = 1,000`, assuming ~10⁸ simple ops/sec:

| Class | Ops at n=1000 | Wall time |
|---|---|---|
| O(log n) | ~10 | instant |
| O(n) | 10³ | instant |
| O(n log n) | ~10⁴ | instant |
| O(n²) | 10⁶ | ~10 ms |
| O(2ⁿ) | 10³⁰¹ | heat death |

The jump from n² to 2ⁿ at the *same n* spans 295 orders of magnitude — why "it's only n=1000" is meaningless without the class.

## Pitfalls

- **Constants and lower terms are not the answer here.** O(100n) and O(n) are the same class; reviewers want the class, then constants only within it.
- **Two different sizes hide as one `n`.** Graph work is O(V + E), string-pair work O(n·m) — collapsing them to O(n²) loses the real shape.
- **Amortized ≠ worst case.** A dynamic [[arrays-and-dynamic-arrays]] push is O(1) amortized but O(n) on the resize; state which you mean.
- **log base is irrelevant** in O(log n) — base change is a constant factor — but it matters for exact step counts when you tabulate them.

## See also

- [[asymptotic-notation]]
- [[time-and-space-complexity]]
