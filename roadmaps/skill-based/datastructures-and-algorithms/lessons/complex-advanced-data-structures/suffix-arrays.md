---
title: Suffix Arrays
track: datastructures-and-algorithms
group: Complex / advanced data structures
tags: [datastructures-and-algorithms, strings]
prerequisites: [string, sorting, binary-search]
see-also: [suffix-trees, binary-search, common-runtimes]
---

# Suffix Arrays

A suffix array is the sorted order of all suffixes of a string, stored as an array of their starting indices — a compact, cache-friendly substitute for a [[suffix-trees|suffix tree]] that enables fast substring search.

## Why it matters

It answers "does pattern P occur, and where?" in O(m log n) via [[searching]], and with a paired LCP array supports longest-repeated-substring, distinct-substring counts, and is the core index inside Burrows–Wheeler / bzip2 and the FM-index used by genome aligners (BWA, Bowtie). Versus a [[suffix-trees|suffix tree]] it uses ~4 bytes per character instead of ~20+ and has far better locality, so it is what production text indexes actually ship.

## How it works

For string `S` of length n, the suffix array `SA` is a permutation of `0..n-1` such that suffix `S[SA[0]:]` < `S[SA[1]:]` < … lexicographically. The companion **LCP array** stores the longest common prefix between adjacent sorted suffixes.

| Build method | Time | Note |
|---|---|---|
| sort suffixes naively | O(n² log n) | compares full strings |
| prefix-doubling (rank by 2ᵏ) | O(n log n) | the practical default |
| DC3 / SA-IS | O(n) | linear, used in libraries |

```text
search(P):  binary-search SA for the range of suffixes
            whose first |P| chars == P    # O(m log n)
            every index in that SA range is an occurrence of P
```

- LCP is built in O(n) from SA via **Kasai's algorithm**; together SA+LCP replace most suffix-tree queries.
- Occurrences of a pattern form a **contiguous block** in SA — count = block width, found by two binary searches.
- Append a sentinel `$` smaller than all characters so no suffix is a prefix of another.

## Example

`S = "banana"`, suffixes and their start indices sorted:

| Rank | Suffix | Start |
|---|---|---|
| 0 | a | 5 |
| 1 | ana | 3 |
| 2 | anana | 1 |
| 3 | banana | 0 |
| 4 | na | 4 |
| 5 | nana | 2 |

So `SA = [5,3,1,0,4,2]`. Searching `P = "ana"` binary-searches to ranks 1–2 → occurrences at indices 3 and 1. Two matches, found without scanning the whole string.

## Pitfalls

- **Naive O(n² log n) build** times out past ~10⁴ characters; use prefix-doubling (O(n log n)) or SA-IS (O(n)) for real input.
- **Comparing variable-length suffixes by value** is O(n) each — rank-based comparison on fixed 2ᵏ blocks is what makes doubling fast.
- **Forgetting the LCP array.** SA alone cannot do longest-repeated-substring; you need LCP, and Kasai's order is non-obvious (iterate by original index, not SA order).
- **No sentinel** breaks the "no suffix is a prefix of another" assumption and complicates comparisons at string end.

## See also

- [[suffix-trees]]
- [[searching]]
- [[common-runtimes]]
