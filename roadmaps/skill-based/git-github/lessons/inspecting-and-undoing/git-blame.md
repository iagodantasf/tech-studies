---
title: git blame
track: git-github
group: Inspecting and undoing
tags: [git-github, inspecting]
prerequisites: [viewing-history-git-log]
see-also: [git-show, git-bisect]
---

# git blame

`git blame <file>` annotates every line of a file with the commit, author, and date that last changed it — the "who wrote this line, and when?" lookup.

## Why it matters

Before touching unfamiliar code you need its provenance: which commit (and PR/ticket) introduced a line, who to ask, and whether a "weird" check guards a real edge case. Blame turns a single line into a thread you can pull — commit message, author, and date — making it indispensable for debugging, archaeology, and writing a [[git-bisect|bisect]]-style narrative of a regression.

## How it works

For each line Git walks history backward and stops at the commit where that line reached its current form, printing `^?sha (author date line#) content`. A leading `^` marks a line from the very first (boundary) commit.

| Flag | Effect |
|---|---|
| `-L 40,60` | blame only lines 40–60 (or `-L :funcName:file`) |
| `-w` | ignore whitespace-only changes when assigning blame |
| `-C` / `-M` | detect lines copied/moved from other files or within the file |
| `-e` | show author email instead of name |
| `<rev>` | blame the file as of a past revision, e.g. `git blame HEAD~5 -- f` |

- **Skipping noise commits** — a pure reformat or rename will claim every line. `git blame --ignore-rev <sha>` (or a `.git-blame-ignore-revs` file) skips listed commits so blame points at the real author.
- **`-C -C -C`** — escalating `-C` widens copy detection (same commit → any committed file), great for tracking code that moved during a refactor.
- Hosts (GitHub) render blame in the UI and let you "view blame prior to this change" to step back through rewrites.

## Example

```
$ git blame -L 12,14 -w src/auth.py
a1b2c3d (Ada 2025-09-02 12) def verify(token):
e4f5a6b (Ben 2026-01-18 13)     if token is None:        # <- added in PR #812
a1b2c3d (Ada 2025-09-02 14)         raise AuthError()
```

## Pitfalls

- **Blame ≠ blame** — it shows the *last* touch, not the original author; a whitespace or move commit can mask real history. Use `-w`, `-M/-C`, and `--ignore-rev`.
- **Deleted lines are invisible** — blame only annotates lines that still exist; to find when a line was *removed*, use `git log -S<text>` (the pickaxe) instead.
- **Reformatting blame storms** — without an ignore-revs file, a Prettier/gofmt pass makes one commit own the whole file.
- **It's per-line, not semantic** — moving a function shows the move commit unless `-M`/`-C` is on; blame can't tell you *why*, only *which commit* — read the [[git-show|commit]] for that.

## See also

- [[git-show]]
- [[git-bisect]]
