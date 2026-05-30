---
title: Binary Search
roadmap: computer-science
node: "Algorithms"
status: done
confidence: 4
tags: [cs, algorithms, searching]
created: 2026-05-30
updated: 2026-05-30
sources:
  - https://roadmap.sh/computer-science
---

# Binary Search

## TL;DR
On a **sorted** array, repeatedly halve the search range. **O(log n)** time, O(1) space. Most bugs are off-by-one in the boundary update and overflow in the midpoint.

## Notes
- **Invariant**: the target, if present, is always within `[lo, hi]`.
- Compute mid as `lo + (hi - lo) / 2` — not `(lo + hi) / 2`, which can overflow in fixed-width ints.
- Two common shapes:
  - *Inclusive* `[lo, hi]` with `while lo <= hi`.
  - *Half-open* `[lo, hi)` with `while lo < hi` — fewer off-by-ones; great for "lower bound" / first-true problems.
- Generalizes to **"binary search on the answer"**: any monotonic predicate `f(x)` (false…false, true…true) can be searched for its first `true`.

## Try it
- Runnable Rust impl + tests: `playgrounds/rust/binary-search` → `cargo run -p binary-search` / `cargo test -p binary-search`.

## Open questions
- Branchless / SIMD binary search — when does it actually win over the naive version?

## See also
- [[hash-tables]]
