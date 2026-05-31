---
title: Edabit
track: datastructures-and-algorithms
group: Practice
tags: [datastructures-and-algorithms, practice]
prerequisites: [platforms-to-practice]
see-also: [leetcode, language-syntax, functions]
---

# Edabit

A beginner-friendly challenge site of thousands of small, bite-sized exercises with visible unit tests — built to drill language fluency, not interview algorithms.

## Why it matters

Before [[two-pointers]] or [[dynamic-programming]] mean anything, you need fingers that type loops, conditionals, and [[functions]] without friction. Edabit fills that earlier rung: very short problems graded by *visible* tests, so the feedback loop is seconds and the cognitive load is on syntax, not strategy. It is the on-ramp that makes a harder judge like [[leetcode]] productive instead of demoralizing.

## How it works

Each challenge gives a function signature, examples, and a public test suite you can read before submitting. Difficulty is labeled and the pacing is deliberately gentle:

| Tier | Typical task | Trains |
|---|---|---|
| Very Easy / Easy | Return sum, reverse a string | [[language-syntax]], basic [[functions]] |
| Medium | Filter/transform a list, simple parsing | Iteration, edge cases |
| Hard / Expert | Light algorithmic logic | Bridges toward real DS&A |

- **Tests are visible**, so failures point at the exact failing input — ideal for learning a new language's standard library.
- **Scope is small.** Most problems are a single function with no advanced [[complex-data-structures|data structures]]; do not expect graph or DP depth here.
- **Use it as a syntax forge** when picking up a new language ([[pick-a-language]]), then graduate to a hidden-test judge for interview patterns.

## Example

A typical Easy item — note the spec lives in plain examples, not formal constraints:

```text
# Given a string, return it with vowels removed.
disemvowel("simple test")  -> "smpl tst"
disemvowel("HELLO")        -> "HLL"

def disemvowel(s):
    return "".join(c for c in s if c.lower() not in "aeiou")
```

The visible tests confirm casing and empty-string handling instantly; the focus is wielding the language, not devising an algorithm.

## Pitfalls

- **Not interview prep.** Edabit tops out well below the Medium-difficulty algorithm questions companies ask; treat it as a warm-up, then move to [[leetcode]].
- **Visible tests can mislead.** It is easy to hard-code against the shown cases; solve for the general rule, not the examples.
- **Plateau risk.** Staying on Easy tiers builds typing speed but no problem-solving depth — climb out once syntax is automatic.
- **No complexity signal.** Unlike percentile-graded judges, it never flags a slow solution, so it teaches nothing about [[asymptotic-notation]].

## See also

- [[platforms-to-practice]]
- [[leetcode]]
- [[functions]]
