---
title: Adding and managing remotes (git remote)
track: git-github
group: Remote repositories
tags: [git-github, remotes]
prerequisites: [what-is-a-remote]
see-also: [fetching-git-fetch, forking-a-repository]
---

# Adding and managing remotes (git remote)

`git remote` is the command to list, add, rename, re-URL, and remove the named [[what-is-a-remote|remotes]] stored in `.git/config`.

## Why it matters

Every multi-copy workflow needs more than one remote sooner or later: a [[forking-a-repository|fork]] adds `upstream` alongside `origin`, a migration repoints `origin` to a new host, and a deploy setup pushes to a second remote. Managing remotes is also how you switch a repo between [[https-vs-ssh-authentication|HTTPS and SSH]] without re-cloning.

## How it works

The subcommands edit config only; they never move objects (that is [[fetching-git-fetch|fetch]]/[[pushing-git-push|push]]).

| Command | Effect |
|---|---|
| `git remote -v` | list remotes with fetch/push URLs |
| `git remote add <name> <url>` | create a new remote |
| `git remote rename old new` | rename (also moves `refs/remotes/old/*`) |
| `git remote remove <name>` | delete remote + its tracking refs |
| `git remote set-url <name> <url>` | change fetch URL |
| `git remote set-url --push <name> <url>` | change push-only URL |
| `git remote show <name>` | verbose status (needs network) |
| `git remote prune <name>` | drop tracking refs for deleted branches |

- **`origin`** is conventional (set by [[cloning-git-clone|clone]]) but not special; `upstream` is the convention for the original repo you forked.
- **Asymmetric URLs** — `set-url --push` lets you fetch over HTTPS but push over SSH.
- **Pruning** — `git remote prune` (or `git fetch --prune`) removes stale `origin/*` refs whose branches were deleted upstream.

## Example

```
$ git clone git@github.com:me/api.git        # origin = my fork
$ git remote add upstream git@github.com:acme/api.git
$ git remote -v
origin    git@github.com:me/api.git   (fetch/push)
upstream  git@github.com:acme/api.git (fetch/push)
$ git fetch upstream                         # now upstream/main exists
$ git rebase upstream/main                   # sync fork onto canonical
```

## Pitfalls

- **`set-url` vs `add`** — `add` on an existing name errors (`remote ... already exists`); use `set-url` to change.
- **Renaming and stale refspecs** — old custom refspecs in config still reference the old name after `rename`; check `.git/config`.
- **Forgetting to prune** — deleted upstream branches linger as `origin/*` and pollute `git branch -r` and tab-completion.
- **Pushing to `upstream` by accident** — you usually lack write access; push to `origin` and open a [[pull-requests|PR]].

## See also

- [[fetching-git-fetch]]
- [[forking-a-repository]]
