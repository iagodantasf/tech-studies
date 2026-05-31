---
title: Installing and configuring Git
track: git-github
group: Version control basics
tags: [git-github, setup]
prerequisites: [what-is-git]
see-also: [git-config-user-name-user-email-core-editor, https-vs-ssh-authentication]
---

# Installing and configuring Git

Getting a working Git install plus the minimum global configuration — identity, line endings, and auth — so your first commit is correct and reproducible.

## Why it matters

A misconfigured install produces commits attributed to `root@hostname`, mangled line endings that show every file as changed, and credential prompts on every push. Five minutes of one-time global setup prevents weeks of noisy diffs and "who is this author?" confusion across every repo on the machine. Identity in particular ([[git-config-user-name-user-email-core-editor|user.name/user.email]]) is baked immutably into each commit.

## How it works

Install per platform, then verify:

| OS | Install | Verify |
|---|---|---|
| macOS | `brew install git` (or Xcode CLT) | `git --version` |
| Debian/Ubuntu | `apt install git` | `git --version` |
| Windows | Git for Windows installer | bundles Git Bash |

Modern Git ships in 2.4x+; check with `git --version`. Then set the essential globals (stored in `~/.gitconfig`):

```
git config --global user.name  "Ada Lovelace"
git config --global user.email "ada@example.com"
git config --global init.defaultBranch main     # not "master"
git config --global core.autocrlf input         # mac/linux; "true" on Windows
git config --global pull.rebase false           # be explicit, avoid warnings
```

Config is layered: **system** (`/etc/gitconfig`) < **global** (`~/.gitconfig`, `--global`) < **local** (`.git/config`, default in a repo). Nearer scopes win. See [[git-config-user-name-user-email-core-editor]] for the per-key detail and `git config --list --show-origin` to see where each value comes from.

## Example

Fresh laptop, end to end:

```
brew install git && git --version            → git version 2.45.2
git config --global user.name "Ada Lovelace"
git config --global user.email "ada@example.com"
git config --global core.autocrlf input
git config --get user.email                  → ada@example.com
```

Per-repo override for a work email: inside the repo, `git config user.email "ada@work.com"` writes to local scope only.

## Pitfalls

- **Forgetting identity before the first commit** — it lands as `unknown`/`root`; fix retroactively with [[amending-commits-git-commit-amend|--amend]] or rebase.
- **Wrong `core.autocrlf`** — `true` on macOS/Linux corrupts files; use `input` there, `true` on Windows.
- **Editing `~/.gitconfig` by hand and breaking syntax** — prefer `git config` commands; a malformed file makes every command error.
- **Leaving `init.defaultBranch` as master** — mismatches GitHub's `main` and breaks `push -u origin main`.

## See also

- [[git-config-user-name-user-email-core-editor]]
- [[https-vs-ssh-authentication]]
