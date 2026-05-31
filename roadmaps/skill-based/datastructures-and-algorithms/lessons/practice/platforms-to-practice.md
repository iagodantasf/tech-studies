---
title: Platforms to Practice
track: datastructures-and-algorithms
group: Practice
tags: [datastructures-and-algorithms, practice]
prerequisites: []
see-also: [leetcode, edabit, big-o-notation]
---

# Platforms to Practice

Online judges that auto-grade your code against hidden tests, so you build pattern recognition and verified correctness instead of guessing whether a solution works.

## Why it matters

Reading about [[two-pointers]] or [[dynamic-programming]] does not transfer to recall under a 45-minute interview clock; deliberate, graded reps do. A judge removes the two excuses that kill self-study — "I think this is right" and "I'll handle edge cases later" — by running your code against adversarial inputs (empty, max-size, overflow, duplicates) and timing it. The goal is not puzzle count but a small, well-chosen rotation drilled until the underlying pattern is automatic.

## How it works

Pick a platform by what you are training for, then drill a curated list rather than browsing randomly:

| Platform | Best for | Grading | Free tier |
|---|---|---|---|
| [[leetcode]] | Interview DS&A patterns | Hidden tests + runtime/mem percentile | Large; some "premium" locked |
| [[edabit]] | Syntax fluency, beginners | Visible unit tests | Fully free |
| HackerRank | Role/skill certs, screens | Hidden tests | Free |
| Codeforces | Competitive, contests + rating | Full system tests post-contest | Free |
| Project Euler | Math-heavy [[number-theory-basics]] | Single numeric answer | Free |

- **Match difficulty to a ladder, not ego.** Spend most reps one notch below your ceiling so you finish and reinforce; reserve hard problems for stretch sessions.
- **Use editorials deliberately.** Time-box (e.g. 30 min); if stuck, read only the *idea*, close it, and re-implement from a blank file.
- **Track the pattern, not the problem.** Tag each solved item by technique ([[sliding-window]], [[merge-intervals]], [[backtracking]]) so review surfaces gaps.

## Example

A 6-week interview ramp using a judge's topic filter, ~5 problems/day:

```text
Wk1-2  arrays/strings: two-pointers, sliding-window, prefix sums
Wk3    hashing + stacks/queues; start trees (BFS/DFS)
Wk4    graphs: topo-sort, union-find, shortest-path
Wk5    DP 1D->2D; backtracking
Wk6    mixed mock sets, timed, no editorial
```

Re-solve every problem you needed a hint on after 7 days; if you still stall, it is a true gap, not a memory lapse.

## Pitfalls

- **Grinding count over patterns.** 500 random solves teach less than 150 grouped by technique with spaced review.
- **Memorizing solutions** passes the judge but fails a follow-up question; always re-implement cold.
- **Ignoring the complexity readout.** A green check at the wrong [[asymptotic-notation]] still fails real interviews — read the runtime/percentile.
- **Platform mismatch.** Codeforces speed-rating habits do not map cleanly to the design-heavy questions some companies ask.

## See also

- [[leetcode]]
- [[edabit]]
- [[asymptotic-notation]]
