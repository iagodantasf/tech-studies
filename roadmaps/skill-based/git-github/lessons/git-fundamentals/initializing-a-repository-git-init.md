---
title: Initializing a repository (git init)
track: git-github
group: Git fundamentals
tags: [git-github, repository-setup]
prerequisites: [what-is-git]
see-also: [the-working-directory-staging-area-and-repository, cloning-git-clone, git-config-user-name-user-email-core-editor]
---

# Initializing a repository (git init)

`git init` turns an ordinary directory into a Git repository by creating the hidden `.git/` folder that holds the entire object database and configuration.

## Why it matters

Every local Git workflow starts here: without `.git/` there is no history, no [[the-working-directory-staging-area-and-repository|staging area]], and no branches. It is the alternative to [[cloning-git-clone|git clone]] when you are starting fresh rather than copying an existing project, and it is idempotent — safe to re-run to repair a missing config without touching your files.

## How it works

`git init` writes a `.git/` directory in the current folder and does not stage or commit anything; your files stay untracked until you [[tracking-changes-git-add|git add]] them.

- **No initial commit** — `HEAD` points at an *unborn* branch (`refs/heads/main`) that has zero commits until your first [[committing-git-commit|commit]].
- **Default branch name** — set globally once with `git config --global init.defaultBranch main`, or per-init with `git init -b main` (Git ≥ 2.28).
- **Bare repos** — `git init --bare` creates a `.git`-less repo with no working tree, used as a *push target* on servers.

| Path inside `.git/` | Holds |
|---|---|
| `HEAD` | Current branch ref (e.g. `ref: refs/heads/main`) |
| `objects/` | All blobs, trees, commits (content-addressed) |
| `refs/` | Branch and tag pointers |
| `config` | Repo-local settings |

## Example

```
mkdir billing && cd billing
git init -b main          # Initialized empty Git repository in .../billing/.git/
git status                # On branch main / No commits yet
echo "node_modules/" > .gitignore
git add .gitignore
git commit -m "chore: initial commit"   # first commit makes 'main' real
```

## Pitfalls

- **`git init` in the wrong directory** — running it in `$HOME` accidentally makes your whole home folder a repo; delete the stray `.git/` to undo.
- **Nested repos** — initializing inside an existing repo creates a sub-repo that the parent ignores (it becomes an embedded repo / would-be [[submodules-and-monorepos|submodule]]), usually a mistake.
- **Expecting files to be tracked** — `git init` tracks nothing; a fresh repo plus no `git add` means `git log` errors with *"does not have any commits yet"*.

## See also

- [[the-working-directory-staging-area-and-repository]]
- [[cloning-git-clone]]
