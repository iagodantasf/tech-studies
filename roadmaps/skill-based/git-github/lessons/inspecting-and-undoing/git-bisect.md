---
title: git bisect
track: git-github
group: Inspecting and undoing
tags: [git-github, debugging]
prerequisites: [viewing-history-git-log, what-is-a-branch]
see-also: [git-blame, reverting-commits-git-revert]
---

# git bisect

`git bisect` binary-searches your commit history to find the exact commit that introduced a bug, testing O(log n) commits instead of all of them.

## Why it matters

When a regression appeared "sometime in the last 300 commits" and you can't read them all, bisect is the tool. It pinpoints the *first bad commit* in ~log2(n) steps — about 9 tests across 500 commits — and with a script it runs fully unattended. Knowing the culprit commit turns a vague "it broke recently" into a precise diff, author, and PR to [[reverting-commits-git-revert|revert]] or fix.

## How it works

You mark one known-**bad** and one known-**good** commit; Git checks out the midpoint, you test and label it, and it halves the remaining range each round until one commit is left.

| Command | Meaning |
|---|---|
| `git bisect start` | begin a session |
| `git bisect bad [<rev>]` | this commit (default HEAD) has the bug |
| `git bisect good <rev>` | this older commit was fine |
| `git bisect skip` | can't test this commit (won't build) |
| `git bisect reset` | end, return to original HEAD |

- **Math** — `n` commits in range ⇒ at most `⌈log2(n)⌉ + 1` tests; 1000 commits is ~11 steps.
- **Automation** — `git bisect run ./test.sh`: the script's *exit code* drives it. `0` = good, `1–124` (except 125) = bad, `125` = skip/untestable. Git converges with zero manual input.
- **Result** — Git reports `<sha> is the first bad commit` and shows that commit. Don't forget `git bisect reset` (or `git bisect log` to replay) afterward.

## Example

```
$ git bisect start
$ git bisect bad                 # HEAD is broken
$ git bisect good v1.4           # this release worked
Bisecting: 127 revisions left to test after this (roughly 7 steps)
$ git bisect run cargo test --quiet auth::login
...
e9d1c0a is the first bad commit
$ git bisect reset
```

## Pitfalls

- **good/bad reversed** — bisect *assumes* the property is monotonic (good → … → bad). Swapping them sends it the wrong direction and names an innocent commit.
- **Flaky tests poison the search** — one wrong label mislabels half the range; make the test deterministic, or `skip` instead of guessing.
- **Exit code 125 vs 1** — in `bisect run`, a script that returns 125 means "skip"; returning 1 for a build failure wrongly marks the commit bad.
- **Forgetting `reset`** — you're left on a detached old commit; new work there is easy to lose. Pair bisect with a clean tree (no [[stashing-changes-git-stash|stashed]] mess between checkouts).

## See also

- [[git-blame]]
- [[reverting-commits-git-revert]]
