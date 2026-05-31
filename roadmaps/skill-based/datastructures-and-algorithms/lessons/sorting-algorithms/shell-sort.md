---
title: Shell Sort
track: datastructures-and-algorithms
group: Sorting algorithms
tags: [datastructures-and-algorithms, sorting]
prerequisites: [insertion-sort, array]
see-also: [insertion-sort, quick-sort, common-runtimes]
---

# Shell Sort

A gap-based generalization of [[sorting]] that first sorts elements far apart, then shrinks the gap to 1, so a final near-sorted pass runs almost linearly.

## Why it matters

Plain [[sorting]] moves elements one slot at a time, so a small value at the end costs O(n) shifts — fatal on reverse-sorted input. Shell sort lets elements jump `gap` positions per move, killing many inversions cheaply before the gap reaches 1. It is in-place, has tiny code and no recursion, and stays competitive for mid-size arrays (a few thousand) and embedded code where [[sorting]]'s recursion or [[sorting]]'s O(n) buffer are unwanted.

## How it works

Run an insertion sort over each `gap`-spaced subsequence, then shrink `gap` toward 1. The **gap sequence** sets the whole performance profile:

| Sequence | Formula | Worst case |
|---|---|---|
| Shell (1959) | n/2, n/4, … , 1 | O(n²) |
| Knuth | 1, 4, 13, … (3k+1) | O(n^1.5) |
| Ciura (empirical) | 1, 4, 10, 23, 57, 132, … | best measured |

```text
for gap in gaps_descending:
  for i in gap..n:
    tmp = a[i]; j = i
    while j >= gap and a[j-gap] > tmp:
      a[j] = a[j-gap]; j -= gap
    a[j] = tmp
```

- The last pass (gap = 1) is a full insertion sort, but by then the array is nearly sorted, so it does ~O(n) work.
- It is **in-place** (O(1) extra space) and **not stable** — equal keys can leap past each other across gaps.
- Exact complexity is unsettled; it depends entirely on the gap sequence (see [[common-runtimes]]).

## Example

Sort `[62, 83, 18, 53, 7, 17, 95, 28]` (n = 8) with Shell gaps 4, 2, 1. Gap 4 compares pairs (0,4),(1,5),(2,6),(3,7): `62↔7`, `83↔17`, `18↔95`, `53↔28` → `[7, 17, 18, 28, 62, 83, 95, 53]`. Already the big values moved left in one pass. Gap 2, then gap 1, finish with only a handful of short shifts instead of the ~28 a plain insertion sort would do.

## Pitfalls

- **A bad gap sequence kills it.** Shell's original n/2 halving still hits O(n²) on adversarial input; use Knuth (3k+1) or Ciura.
- **Not stable** — never use it when equal records must keep input order; prefer [[sorting]].
- **Easy off-by-one in the gap loop:** the inner guard must be `j >= gap`, not `j > 0`, or you read `a[j-gap]` out of bounds.
- **Don't expect O(n log n).** For large n it loses to [[sorting]]/[[sorting]]; its niche is small-to-medium, simple, in-place sorting.

## See also

- [[sorting]]
- [[sorting]]
- [[common-runtimes]]
