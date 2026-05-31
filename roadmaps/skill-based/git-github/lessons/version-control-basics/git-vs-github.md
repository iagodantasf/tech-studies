---
title: Git vs GitHub
track: git-github
group: Version control basics
tags: [git-github, fundamentals]
prerequisites: [what-is-git]
see-also: [what-is-a-remote, creating-a-github-account-and-repository]
---

# Git vs GitHub

Git is the open-source version control *tool* that runs on your machine; GitHub is a commercial *hosting platform* (one of several) that stores Git repositories in the cloud and layers collaboration features on top.

## Why it matters

Conflating the two leads to confused mental models: people think they "need GitHub to use Git" (false — `git init` works fully offline) or that GitHub *is* version control (it isn't; it hosts it). Knowing the boundary tells you which features are portable (anything `git ...`) versus locked to a vendor ([[pull-requests|Pull Requests]], Actions). You can self-host with bare Git over SSH and never touch any platform.

## How it works

| | Git | GitHub |
|---|---|---|
| Type | CLI tool / protocol | hosted web platform |
| Runs | locally, offline | in the cloud |
| Made by | Linus Torvalds, 2005 | GitHub Inc. (Microsoft, 2018) |
| Provides | commits, branches, merges | hosting + PRs, issues, CI |
| Alternatives | Mercurial, Fossil | GitLab, Bitbucket, Gitea |

GitHub is a [[what-is-a-remote|remote]]: you push your local Git history to it. Its value-add is everything Git itself doesn't define — a web UI, access control, [[github-issues|Issues]], [[pull-requests|Pull Requests]] for review, [[github-actions-and-ci-cd|Actions]] for CI/CD, and [[branch-protection-rules|branch protection]]. None of that is part of Git; the PR concept does not exist in core Git at all.

## Example

The same repository, two layers:

```
git init                              # pure Git, local
git commit -m "feat: parser"          # pure Git, local
git remote add origin git@github.com:me/app.git
git push -u origin main               # Git speaks to GitHub the remote
# Opening a Pull Request, requesting review → GitHub-only feature
```

Move to GitLab tomorrow: every `git` command is identical; only the PR/Actions tooling changes.

## Pitfalls

- **"GitHub is down, I can't commit"** — false; commit locally and push later, GitHub is only the remote.
- **Vendor lock-in via platform features** — Issues, Projects, and Actions config don't travel with `git clone`; only the repo does.
- **Assuming PR = a Git concept** — it's a GitHub/GitLab abstraction over a branch [[merging-branches-git-merge|merge]].
- **Pushing secrets to a public repo** — Git tracks them; GitHub then exposes them to the world and to scrapers within seconds.

## See also

- [[what-is-a-remote]]
- [[creating-a-github-account-and-repository]]
