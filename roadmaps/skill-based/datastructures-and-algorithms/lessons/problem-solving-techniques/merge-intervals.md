---
title: Merge Intervals
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [array, sorting-algorithms]
see-also: [sorting-algorithms, heap, greedy-algorithms]
---

# Merge Intervals

Sort intervals by start, then sweep once, fusing any that overlap with the interval you are currently building — the canonical O(n log n) pattern for range-overlap problems.

## Why it matters

Intervals model calendar events, IP/CIDR ranges, genome segments, reserved time slots, and version ranges. The recurring questions — merge overlapping bookings, insert a new event, find free gaps, count rooms needed, detect any conflict — all reduce to scanning sorted intervals. The sort dominates at O(n log n); the sweep itself is O(n). Recognizing "intervals + overlap" instantly suggests sort-then-sweep rather than an O(n²) all-pairs comparison.

## How it works

Sort by start. Walk the list keeping one `current` interval; the next interval either overlaps (extend) or is disjoint (emit and restart).

| Relation of next `[s,e]` to current `[cs,ce]` | Condition | Action |
|---|---|---|
| overlapping | `s <= ce` | `ce = max(ce, e)` |
| adjacent (touching) | `s == ce` | merge if "closed" intervals |
| disjoint | `s > ce` | emit `current`, set `current = [s,e]` |

```text
sort intervals by start
out = []; cur = intervals[0]
for s, e in intervals[1:]:
    if s <= cur.end:                 # overlap -> absorb
        cur.end = max(cur.end, e)
    else:                            # gap -> close and open new
        out.append(cur); cur = [s, e]
out.append(cur)
return out
```

- One pass after sorting; each interval is examined once → O(n) sweep.
- For "minimum rooms" use a min-[[heaps-and-priority-queues]] of end times (or a +1/−1 sweep line on sorted endpoints) instead of merging.

## Example

`[[1,3], [2,6], [8,10], [15,18]]`, already sorted. `cur=[1,3]`; next `[2,6]` has `2 ≤ 3` → extend to `[1,6]`. Next `[8,10]`: `8 > 6` → emit `[1,6]`, `cur=[8,10]`. Next `[15,18]`: `15 > 10` → emit `[8,10]`, `cur=[15,18]`. Result `[[1,6], [8,10], [15,18]]` — three intervals from four.

## Pitfalls

- **Sorting by end instead of start** breaks the merge invariant; sort by **start** (ties by end). The end-sort is for the *different* activity-selection [[greedy-algorithms]] problem.
- **`<` vs `<=` on the overlap test.** Decide whether touching intervals like `[1,2]` and `[2,3]` count as overlapping (closed) or not (half-open) and stay consistent.
- **Mutating the input array's interval objects** while sweeping aliases your output; copy `cur` before extending.
- **Forgetting the final emit.** The last `cur` is still open when the loop ends — append it or you drop the trailing interval.

## See also

- [[sorting]]
- [[heaps-and-priority-queues]]
- [[greedy-algorithms]]
