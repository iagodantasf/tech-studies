---
title: Complex Data Structures
track: datastructures-and-algorithms
group: Complex / advanced data structures
tags: [datastructures-and-algorithms, data-structures]
prerequisites: [array, binary-trees, hash-tables]
see-also: [disjoint-set-union-find, fenwick-trees, segment-trees, suffix-arrays]
---

# Complex Data Structures

The specialized structures — union-find, Fenwick/segment trees, balanced trees, tries, suffix structures — that turn an O(n) per-query problem into O(log n) or O(α(n)) by precomputing structure over the data.

## Why it matters

Once a problem asks "answer many queries over a changing collection," a flat [[arrays-and-dynamic-arrays]] or [[hash-tables]] forces O(n) per query and the total blows up. These structures pay an O(n) or O(n log n) build cost once, then serve each query in sub-linear time. They are the backbone of databases (B-tree [[indexing]]), version control (Merkle/[[suffix-trees]]), networking routers ([[tries]]), and nearly every hard competitive problem. Picking the right one is a modeling skill, not memorization.

## How it works

The choice is driven by the *query type*, not the data. Match the access pattern to the structure:

| Need | Structure | Query | Build |
|---|---|---|---|
| Connectivity / merging sets | [[disjoint-set-union-find]] | ~O(α(n)) | O(n) |
| Prefix sum + point update | [[fenwick-trees]] | O(log n) | O(n) |
| Range query + range update | [[segment-trees]] | O(log n) | O(n) |
| Ordered keys, balanced | [[avl-trees]], [[red-black-trees]] | O(log n) | O(n log n) |
| Prefix / dictionary lookup | [[tries]] | O(L) | O(ΣL) |
| Substring / pattern search | [[suffix-arrays]], [[suffix-trees]] | O(m log n)/O(m) | O(n)–O(n log n) |

- Most reduce a problem to a **tree over index ranges or value ranges**, so a query touches O(log n) nodes instead of n elements.
- The recurring trade is **build cost vs query cost**: amortize the build only when queries are many.
- Static data unlocks cheaper variants (sorted [[arrays-and-dynamic-arrays]] + [[searching]] beats a tree when nothing changes).

## Example

10⁶ "is u connected to v?" queries on a graph with edges added over time. A BFS/[[graph-algorithms]] per query is ~10⁶ × 10⁶ = 10¹² ops — minutes to hours. [[disjoint-set-union-find]] answers each in near-constant time: ~10⁶ × 5 ≈ 5×10⁶ ops, milliseconds. Same problem, six orders of magnitude, purely from structure choice.

## Pitfalls

- **Reaching for a heavy structure when sorted-array + [[searching]] suffices.** If data is static, you often do not need a tree at all.
- **Ignoring the constant factor.** A [[segment-trees|segment tree]] has ~4n nodes and pointer/recursion overhead; a [[fenwick-trees|Fenwick tree]] is ~10× simpler and faster when it fits the problem.
- **Building per query instead of once.** The O(n) build must be hoisted out of the query loop or the asymptotic win evaporates.
- **Wrong structure for the update kind.** Fenwick handles point updates trivially but range updates need a trick; default to segment trees when both ranges move.

## See also

- [[disjoint-set-union-find]]
- [[segment-trees]]
- [[fenwick-trees]]
