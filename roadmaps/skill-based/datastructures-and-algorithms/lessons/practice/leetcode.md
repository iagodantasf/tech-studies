---
title: LeetCode
track: datastructures-and-algorithms
group: Practice
tags: [datastructures-and-algorithms, practice]
prerequisites: [platforms-to-practice]
see-also: [edabit, big-o-notation, common-runtimes]
---

# LeetCode

The de facto online judge for software-interview prep, with ~3000+ problems tagged by data structure, technique, and the companies that have asked them.

## Why it matters

Most large-tech coding rounds draw from the same pattern set LeetCode catalogs, so its tag taxonomy doubles as a study map: solve a few of each tag and you have covered the realistic question surface. Beyond raw problems it grades runtime and memory against a percentile distribution, which forces you to confront [[asymptotic-notation]] in practice — a brute force that passes still shows you the slow-percentile, signaling a better approach exists.

## How it works

The judge compiles your function, runs it against hidden test cases, and reports verdict plus a runtime/memory percentile. Use the structure, not just the problem feed:

| Feature | What to use it for |
|---|---|
| Topic tags | Drill one pattern at a time (e.g. all sliding-window) |
| Difficulty | Easy = syntax, Medium = interview bread-and-butter, Hard = stretch |
| Editorial + solutions | The optimal idea and alternative approaches |
| Company tags (premium) | Bias practice toward a target's recent set |
| Contests | Timed, ranked, simulates pressure |

- **Medium is the target tier.** Real interviews skew Medium; Easy builds fluency, Hard is mostly stretch and niche.
- **Read the constraints first** — `n <= 10^5` rules out O(n²) and hints the intended [[common-runtimes|runtime]]; `n <= 20` invites [[backtracking]] or bitmask.
- **Curated lists beat browsing.** "Top Interview 150" or NeetCode's grouping cover the canonical patterns; finish a list before going wide.
- A passing slow percentile means **correct but suboptimal** — open the editorial for the intended complexity even when you got a green check.

## Example

Reading constraints to pick the approach before writing any code:

```text
"Two Sum"  n <= 10^4, return indices of pair summing to target
  brute force: O(n^2) nested loop  -> passes here, but...
  hash map:    one pass, value->index, O(n) time / O(n) space  -> intended
```

The judge accepts both; the O(n) hash solution lands in a far better runtime percentile and is the version an interviewer expects — see [[hash-tables]].

## Pitfalls

- **Premium FOMO.** The free tier already covers every core pattern; company tags are a nicety, not a requirement.
- **Percentile chasing** with micro-optimizations wastes time once you hit the right complexity class; correct + optimal big-O is the bar.
- **Copy-run-forget.** Pasting a solution to clear the verdict builds nothing; re-solve from blank after 7 days.
- **Hard-problem rabbit holes** early on crush momentum; bank Mediums first, where the interview signal actually lives.

## See also

- [[platforms-to-practice]]
- [[asymptotic-notation]]
- [[hash-tables]]
