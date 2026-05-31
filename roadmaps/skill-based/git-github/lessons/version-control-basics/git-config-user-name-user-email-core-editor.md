---
title: git config (user.name, user.email, core.editor)
track: git-github
group: Version control basics
tags: [git-github, configuration]
prerequisites: [installing-and-configuring-git]
see-also: [committing-git-commit, getting-help-git-help-man-h]
---

# git config (user.name, user.email, core.editor)

`git config` is the front end to Git's layered key/value settings; three keys matter most up front — `user.name` and `user.email` (commit identity) and `core.editor` (the editor Git opens for messages).

## Why it matters

`user.name`/`user.email` are stamped permanently into every [[committing-git-commit|commit]] you author and cannot be changed later without rewriting history. The email is also how [[git-vs-github|GitHub]] links commits to your account — a mismatched address means your commits show as an unknown author with no avatar. `core.editor` decides what opens when you run `git commit` with no `-m`; an unset value can drop you into vim unexpectedly.

## How it works

Settings live in INI files across three scopes; the most specific wins:

| Scope | Flag | File | Wins |
|---|---|---|---|
| system | `--system` | `/etc/gitconfig` | lowest |
| global | `--global` | `~/.gitconfig` | per-user |
| local | (default) | `.git/config` | highest |

Common operations:

```
git config --global user.name  "Ada Lovelace"
git config --global user.email "ada@users.noreply.github.com"   # privacy
git config --global core.editor "code --wait"                   # VS Code
git config --get user.email                                     # read one
git config --list --show-origin                                 # all + source
git config --global --unset core.editor                         # remove
```

Use GitHub's `…@users.noreply.github.com` address to keep your real email out of public history while still attributing correctly. The `--wait` flag is essential for GUI editors — without it Git thinks the editor closed instantly and aborts. See [[installing-and-configuring-git]] for the full first-run set.

## Example

Per-project identity override (work vs personal) without touching globals:

```
~/work/api $ git config user.email "ada@corp.com"     # local scope
~/work/api $ git config --get user.email              → ada@corp.com
~/oss/lib $ git config --get user.email               → ada@users.noreply.github.com
```

`core.editor "code --wait"` then makes `git commit` (no `-m`) open VS Code; saving and closing the tab finalizes the message.

## Pitfalls

- **GUI editor without `--wait`** — Git sees an instant exit and commits an empty/aborted message.
- **Committing with the wrong email** — already-made commits keep it; only [[amending-commits-git-commit-amend|--amend]]/rebase can fix, and that rewrites hashes.
- **Setting identity local-only on one repo** — every other repo still uses the system default; prefer `--global` as the baseline.
- **`$EDITOR` vs `core.editor` confusion** — Git prefers `core.editor`, then `GIT_EDITOR`, then `$VISUAL`/`$EDITOR`; set the one you expect.

## See also

- [[committing-git-commit]]
- [[getting-help-git-help-man-h]]
