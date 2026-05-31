---
title: Ignoring files (.gitignore)
track: git-github
group: Git fundamentals
tags: [git-github, gitignore]
prerequisites: [tracking-changes-git-add]
see-also: [checking-status-git-status, removing-and-moving-files-git-rm-git-mv, personal-access-tokens-and-ssh-keys]
---

# Ignoring files (.gitignore)

`.gitignore` lists path patterns that Git should leave **untracked** — build output, dependencies, local config, and secrets that must never enter history.

## Why it matters

It keeps the repo to source-of-truth files only, stops [[tracking-changes-git-add|git add .]] from sweeping in `node_modules/` or a `.env`, and is the first line of defense against leaking credentials. A good ignore file makes [[checking-status-git-status|git status]] readable instead of drowned in generated noise.

## How it works

Patterns are matched against paths relative to the file's location. Multiple ignore sources are consulted, later/closer rules can override earlier ones.

| Pattern | Matches |
|---|---|
| `build/` | A directory named `build` (and all contents) |
| `*.log` | Any `.log` file at any depth |
| `/secret.txt` | `secret.txt` only at repo root |
| `!keep.log` | Re-include an otherwise-ignored file |
| `**/tmp` | `tmp` at any directory level |

- **Precedence** — last matching pattern wins; a deeper `.gitignore` or a `!` negation can override a broad rule, *but* you cannot un-ignore a file if its parent **directory** is ignored.
- **Scopes** — repo `.gitignore` (committed, shared), `.git/info/exclude` (local, not shared), and `core.excludesFile` (global, e.g. OS cruft like `.DS_Store`).
- **Only affects untracked files** — ignore rules are checked when Git considers tracking a file; they have no effect on files already committed.

## Example

```
# .gitignore
node_modules/
dist/
*.env
!example.env        # but keep the template

git status -s        # .env no longer shows as ??
git check-ignore -v secret.env
# .gitignore:3:*.env    secret.env   <- which rule matched, useful for debugging
```

## Pitfalls

- **Ignoring an already-tracked file does nothing** — you must `git rm --cached <file>` first (see [[removing-and-moving-files-git-rm-git-mv|git rm]]) so it becomes untracked, then the ignore takes effect.
- **Can't negate inside an ignored dir** — `foo/` then `!foo/keep.txt` fails; Git never descends into an excluded directory. Ignore contents (`foo/*`) instead.
- **Committing a secret, then ignoring it** — the secret is already in history; you must purge it (`filter-repo`) and rotate the credential — `.gitignore` does not remove past commits.
- **Trailing-space and comment surprises** — a line starting `#` is a comment (escape as `\#`); trailing spaces are significant unless backslash-escaped.

## See also

- [[checking-status-git-status]]
- [[removing-and-moving-files-git-rm-git-mv]]
