---
title: Sliding Window
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [array, two-pointers]
see-also: [two-pointers, hash-tables, string]
---

# Sliding Window

Maintain a contiguous range `[left, right]` over an array or string, expanding and contracting its ends so every element enters and leaves at most once — turning O(n·k) or O(n²) subarray scans into O(n).

## Why it matters

Any "best/longest/shortest contiguous subarray or substring satisfying a condition" problem is a window: max-sum subarray of size k, longest substring without repeats, smallest subarray ≥ target, longest substring with at-most-k distinct chars, permutation-in-string. Recomputing each window from scratch is O(n·k); sliding reuses the previous window's work for O(n) total. It pairs naturally with a [[hash-tables]] or counter to track what is currently inside the window.

## How it works

Two regimes, picked by whether the width is given:

| Window type | Width | Contract rule |
|---|---|---|
| Fixed | given `k` | drop `a[left]` when `right-left+1 > k` |
| Dynamic | unknown | shrink from `left` while a constraint is violated |

```text
left = 0; agg = 0; best = 0          # dynamic, "longest valid"
for right in range(n):
    agg += a[right]                  # element enters window
    while invalid(agg):              # constraint broken?
        agg -= a[left]; left += 1    # element leaves from the left
    best = max(best, right - left + 1)
return best
```

- Amortized O(n): `right` advances n times, `left` advances at most n times total, so 2n moves.
- Keep an incremental summary (running sum, a count map) so updating on enter/leave is O(1), not a re-scan.

## Example

Longest substring without repeating chars in `"abcabcbb"`. Track last-seen index per char. The window grows `a,b,c` (len 3); at the second `a` (index 3) the duplicate sits at index 0, so jump `left` to 1; continue `b,c` window `bca` then `cab`/`abc`, never exceeding length 3. Answer: 3, in one O(n) pass instead of checking all O(n²) substrings.

## Pitfalls

- **Shrinking with `if` instead of `while`** in dynamic windows — one removal may not restore validity; loop until the constraint holds again.
- **Forgetting to update the aggregate on *both* enter and leave**, leaving a stale sum/count that corrupts every later decision.
- **Fixed-window off-by-one:** the width is `right - left + 1`; record the answer only once `right >= k-1`.
- **Non-contiguous problems don't fit.** If elements can be skipped (subsequence, not subarray), a window is wrong — reach for [[two-pointers]] on sorted data or [[dynamic-programming]].

## See also

- [[two-pointers]]
- [[hash-tables]]
- [[string]]
