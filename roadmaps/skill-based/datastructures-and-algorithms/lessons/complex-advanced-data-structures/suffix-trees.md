---
title: Suffix Trees
track: datastructures-and-algorithms
group: Complex / advanced data structures
tags: [datastructures-and-algorithms, strings]
prerequisites: [string, tries, trees]
see-also: [suffix-arrays, tries, common-runtimes]
---

# Suffix Trees

A suffix tree is a compressed [[tries]] of all suffixes of a string, where every path from the root spells a substring — letting you answer "is P a substring?" in O(m), independent of text length.

## Why it matters

Once built, a suffix tree turns a whole family of string problems into simple tree walks: substring membership in O(m), longest repeated substring, longest common substring of two strings, and counting distinct substrings. It is the theoretical gold standard for string indexing and the conceptual parent of the more practical [[suffix-arrays|suffix array]]. Knowing it explains *why* suffix arrays + LCP can emulate the same queries.

## How it works

Take all n suffixes, insert into a [[tries]], then **compress** every chain of single-child nodes into one edge labeled by a substring range `[i, j]` (stored as two integers, not copied text). With a sentinel `$`, every suffix ends at a distinct leaf, so the tree has exactly n leaves and < 2n nodes.

| Property | Value |
|---|---|
| Nodes | ≤ 2n (n leaves + < n internal) |
| Edge label | index range, O(1) space |
| Substring query `P` | O(m) — walk edges |
| Build (Ukkonen) | O(n) online |

```text
contains(P):  walk from root, matching P against edge labels
              char by char; if you fall off the tree, P is absent;
              if P is consumed, P is a substring   # O(|P|)
```

- **Ukkonen's algorithm** builds it in O(n) online (one character at a time) using suffix links — notoriously intricate to implement.
- Each **internal node** marks a branching point = a substring that occurs ≥ 2 times; the deepest such node is the longest repeated substring.
- Edges store `(start, end)` offsets into the original string, so total space is O(n) integers despite representing O(n²) substring characters.

## Example

`S = "banana$"`. The tree branches on shared prefixes: edges for `a`, `na`, `banana$` leave the root; the `a`-path and `na`-path each branch again because "ana"/"nana" repeat. The deepest internal node spells **"ana"** — the longest repeated substring, read straight off the structure. Querying `contains("nan")` walks `n → a → n` and succeeds in 3 steps regardless of how long `S` is.

## Pitfalls

- **Storing edge labels as copied strings** makes it O(n²) space; always store `(start, end)` index pairs into the source.
- **Implementing Ukkonen from scratch under time pressure** is a trap — suffix links and the "active point" are subtle; in interviews/contests a [[suffix-arrays|suffix array]] + LCP is usually the right call.
- **No sentinel** lets one suffix be a prefix of another, so it ends at an internal node instead of a leaf and breaks the "n leaves" invariant.
- **Memory blowup on large alphabets**: per-node child maps cost O(|Σ|); hash-map children or a suffix array control the constant.

## See also

- [[suffix-arrays]]
- [[tries]]
- [[common-runtimes]]
