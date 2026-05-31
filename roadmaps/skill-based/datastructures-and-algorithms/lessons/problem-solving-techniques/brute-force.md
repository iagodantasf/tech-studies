---
title: Brute Force
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [control-structures, big-o-notation]
see-also: [backtracking, two-pointers, dynamic-programming]
---

# Brute Force

Enumerate every candidate solution and test each one — the baseline strategy that is always correct, often the right *first* answer, and the yardstick every optimization is measured against.

## Why it matters

Brute force is the honest starting point: write the O(n²) or O(2ⁿ) version that obviously works, confirm it against the spec, then optimize only where the input size demands it. In interviews it earns partial credit and exposes the structure you later exploit with [[two-pointers]], [[sliding-window]], or [[dynamic-programming]]. In production it is the *reference oracle* you diff a clever solution against in tests. Knowing the brute-force cost also tells you whether optimizing is even worth it — for n ≤ 20, an O(2ⁿ) scan finishes instantly.

## How it works

Generate the full candidate space with nested loops or recursion, evaluate each, keep the best/valid ones. The shape of the space sets the cost:

| Candidate space | Typical size | Example task |
|---|---|---|
| all pairs | O(n²) | two-sum, closest pair |
| all triples | O(n³) | 3-sum, max triangle |
| all subsets | O(2ⁿ) | subset-sum, power set |
| all permutations | O(n!) | TSP, anagram search |

```text
best = NONE
for cand in all_candidates(input):   # nested loops or recursion
    if valid(cand):
        best = better(best, cand)
return best
```

- Map each problem to one row above; the size tells you the rough wall-clock instantly.
- A rough budget: ~10⁸ simple operations per second, so O(n²) is fine to n≈10⁴, O(2ⁿ) to n≈25, O(n!) to n≈11.

## Example

Two-sum on `[2, 7, 11, 15]`, target 9. Brute force tries every pair: `(2,7)=9` hit at indices `(0,1)` after 1 of the 6 candidate pairs. The O(n²) double loop is trivially correct; only when n grows do you swap it for the O(n) [[hash-tables]] version. The brute-force result is what you'd assert against in a unit test for the optimized one.

## Pitfalls

- **Optimizing before measuring.** For small or one-shot inputs the brute force is simpler, less buggy, and fast enough — clever code is wasted risk.
- **Exponential blowup sneaks up.** O(2ⁿ) looks fine at n=20 (10⁶) but is hopeless at n=60 (10¹⁸); always check the largest input bound.
- **Re-scanning instead of pruning.** Pure enumeration that ignores early-exit becomes [[backtracking]] the moment you add a feasibility cutoff — recognize when a cheap prune collapses the space.
- **Double-counting or off-by-one in pair loops.** Start the inner loop at `i+1` to avoid `(i,i)` and counting each pair twice.

## See also

- [[backtracking]]
- [[two-pointers]]
- [[dynamic-programming]]
