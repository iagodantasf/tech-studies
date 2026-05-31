---
title: Random Shuffle
track: datastructures-and-algorithms
group: Sorting algorithms
tags: [datastructures-and-algorithms, randomization]
prerequisites: [array]
see-also: [quick-sort, number-theory-basics, common-runtimes]
---

# Random Shuffle

The inverse of sorting: producing a uniformly random permutation of an array in O(n) using the Fisher-Yates (Knuth) algorithm.

## Why it matters

Shuffling is the correctness-critical core of card games, A/B test assignment, randomized [[sorting]] pivots, train/test splits, and reservoir sampling. Done right it is O(n) and gives each of the n! orderings exactly equal probability; done wrong (the common naive version) it skews toward certain permutations, which silently biases simulations and experiments. The bar here is *uniformity*, and most homemade shuffles fail it.

## How it works

Fisher-Yates walks from the last index down, swapping each element with a random one **at or before** it. Element `i` is chosen from `[0, i]` — the already-shuffled tail is never touched again.

```text
for i = n-1 downto 1:
  j = uniform_int(0, i)     # inclusive both ends
  swap(a[i], a[j])
```

| Property | Value |
|---|---|
| Time / space | O(n) / O(1), in place |
| Outcomes | each of n! perms, probability 1/n! |
| RNG draws | n−1 bounded integers |

- The range `[0, i]` must be **inclusive of `i`** (an element may stay put); using `[0, i-1]` or `[0, n-1]` destroys uniformity.
- Correctness needs an **unbiased** bounded integer: `rand() % (i+1)` introduces modulo bias unless `RAND_MAX+1` is a multiple of `i+1` — see [[number-theory-basics]].
- Sorting by a random key (`sort` with `random()` comparator) is **not** a valid shuffle: it is O(n log n) and provably non-uniform.

## Example

Shuffle `[A, B, C, D]` (n = 4), 3 draws. i=3, j∈[0,3]=1 → swap → `[A, D, C, B]`. i=2, j∈[0,2]=2 → swap with self → `[A, D, C, B]`. i=1, j∈[0,1]=0 → swap → `[D, A, C, B]`. Each of the 4! = 24 orderings is equally likely; over many runs every position holds each letter exactly 1/4 of the time.

## Pitfalls

- **Wrong range = biased output.** The classic bug picks `j` from `[0, n-1]` every iteration; that yields n^n equally likely *paths* over n! outcomes, which cannot divide evenly — some perms get over-represented.
- **Modulo bias.** `rand() % k` favors small remainders when the RNG range is not a multiple of `k`; use rejection sampling or a range-aware RNG.
- **Sort-by-random is not uniform** (and depends on the sort/comparator) — a documented source of real shuffle bugs.
- **Weak/seeded RNG leaks.** A predictable PRNG (or fixed seed) makes "random" decks or tokens guessable; use a CSPRNG for security-relevant shuffles — see [[cryptography-basics]].

## See also

- [[sorting]]
- [[number-theory-basics]]
- [[common-runtimes]]
