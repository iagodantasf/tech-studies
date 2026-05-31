---
title: Language Syntax
track: datastructures-and-algorithms
group: Language & foundations
tags: [datastructures-and-algorithms, tooling]
prerequisites: [pick-a-language]
see-also: [control-structures, functions, basic-data-structures]
---

# Language Syntax

The minimal vocabulary — declarations, literals, operators, indexing — that you must type without thinking so the editor never becomes the bottleneck during a timed problem.

## Why it matters

Syntax recall is the difference between transcribing an algorithm you already see and stalling on "how do I slice this again?" The handful of constructs below cover ~95% of what any DSA solution needs; the rest you can look up. Getting integer semantics and slicing exactly right also kills a whole class of silent wrong-answer bugs that no compiler will catch for you.

## How it works

The DSA-relevant syntax reduces to a small core. Pin down the exact behavior in your chosen language:

| Concept | Python | C++ | Watch for |
|---|---|---|---|
| Integer division | `7 // 2 == 3` | `7 / 2 == 3` | C++ truncates toward 0; Python floors |
| Negative mod | `-7 % 3 == 2` | `-7 % 3 == -1` | sign differs across languages |
| Subarray slice | `a[2:5]` | `a.substr(2,3)` | half-open vs offset+length |
| Swap | `a, b = b, a` | `swap(a, b)` | tuple-unpack vs library call |
| Int max | `float('inf')` | `INT_MAX` | C++ `INT_MAX + 1` overflows (UB) |

- **Slicing is half-open** `[lo, hi)` in most languages: `a[2:5]` yields 3 elements (indices 2, 3, 4). This convention is why `hi - lo` is the length and why off-by-one bugs cluster at boundaries.
- **Negative indexing** (`a[-1]` for the last element) exists in Python/Ruby but not C/C++/Java — porting code across languages breaks here.
- Use language-native multiple assignment for swaps and two-pointer updates; it is both shorter and avoids a temp-variable bug.

## Example

Reverse an array in place using only core syntax:

```python
lo, hi = 0, len(a) - 1
while lo < hi:
    a[lo], a[hi] = a[hi], a[lo]   # simultaneous swap, no temp
    lo, hi = lo + 1, hi - 1
```

The same loop in C++ needs `std::swap(a[lo], a[hi])` and explicit `++lo; --hi;`.

## Pitfalls

- **Integer division and modulo on negatives differ by language.** `-7 % 3` is `2` in Python but `-1` in C++/Java/Go — this breaks hashing and circular-buffer index math.
- **Fixed-width integer overflow is silent.** `INT_MAX + 1` in C++/Java wraps (or is UB); a sum of large values needs `long`/`int64`. Python integers are unbounded, so this bug only appears after porting.
- **Slice endpoints are exclusive.** Reading `a[lo:hi]` as inclusive double-counts or skips the boundary element.
- **Chained comparisons** like `0 <= i < n` mean what you expect in Python but are a bug in C/C++ (parsed as `(0 <= i) < n`).

## See also

- [[control-structures]]
- [[functions]]
- [[basic-data-structures]]
