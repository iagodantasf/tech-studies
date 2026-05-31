---
title: Radix Sort
track: datastructures-and-algorithms
group: Sorting algorithms
tags: [datastructures-and-algorithms, sorting]
prerequisites: [array, bit-manipulation]
see-also: [quick-sort, merge-sort, common-runtimes]
---

# Radix Sort

A non-comparison sort that orders fixed-width keys digit by digit using a stable bucketing pass per digit, breaking the O(n log n) comparison-sort barrier.

## Why it matters

Comparison sorts like [[sorting]] and [[sorting]] need Ω(n log n) comparisons. When keys are integers, fixed-length strings, or bytes, radix sort runs in **O(d·(n + b))** for `d` digits and base `b` — effectively O(n) when `d` is small and fixed. That is why it backs fast integer/string sorting, suffix-array construction, and column sorts in analytics engines where keys are bounded-width.

## How it works

**LSD (least-significant-digit)** radix sort makes one stable pass per digit, from the lowest digit up. The stability of each pass is what preserves the ordering established by earlier (lower) digits.

| Variant | Pass order | Stability needed | Note |
|---|---|---|---|
| LSD | low → high digit | yes (critical) | simplest; great for fixed width |
| MSD | high → low digit | per-bucket | recursive; handles variable length |

```text
for digit d = 0 .. D-1:          # LSD, base b
  count[0..b-1] = 0
  for x in a: count[(x >> d*k) & mask] += 1   # k bits per digit
  prefix-sum count into start offsets
  for x in a (in order): out[ offset[digit(x)]++ ] = x   # stable
  a = out
```

- Each pass is a **counting sort** on one digit: O(n + b). Total O(d·(n + b)).
- Choosing base `b = 2^k` makes digit extraction a shift+mask — see [[bit-manipulation]]; a common choice is 8-bit digits (b = 256), so 32-bit ints need d = 4 passes.
- **Stable and not in-place**: it needs an O(n) output buffer plus an O(b) count array.

## Example

Sort `[170, 45, 75, 90, 2, 802, 24, 66]` by base-10 LSD. Ones digit → `[170, 90, 2, 802, 24, 45, 75, 66]`; tens digit → `[2, 802, 24, 45, 66, 170, 75, 90]`; hundreds digit → `[2, 24, 45, 66, 75, 90, 170, 802]`. Three passes (max key has 3 digits), each a stable bucket sort, with no key-vs-key comparison performed.

## Pitfalls

- **Negatives and floats break naive byte order.** Two's-complement negatives sort after positives; flip the sign bit (and for IEEE floats, flip all bits of negatives) before bucketing — see [[floating-point-representation]].
- **A non-stable inner pass corrupts everything.** LSD only works if each digit pass is stable; using an unstable sort silently scrambles ties from prior digits.
- **Huge base wastes memory and cache.** `b` too large (e.g. 2^16) blows the count array and thrashes cache; tune digit width to the data.
- **Not a general comparator sort** — it needs fixed-width, well-defined keys; for arbitrary `compare()` use [[sorting]]/[[sorting]].

## See also

- [[sorting]]
- [[sorting]]
- [[common-runtimes]]
