---
title: Creating a GitHub account and repository
track: git-github
group: GitHub basics
tags: [git-github, github-setup]
prerequisites: [git-vs-github, initializing-a-repository-git-init]
see-also: [readme-license-and-repository-structure, https-vs-ssh-authentication]
---

# Creating a GitHub account and repository

The first concrete step on GitHub: register an account, then create a remote repository that hosts your commits and enables collaboration on top of plain [[what-is-git|Git]].

## Why it matters

A GitHub account is your identity for every push, [[pull-requests|PR]], and review — the commit author email must match a verified account email or the commit shows as "unknown" and won't count toward your contribution graph. The repository is the unit GitHub secures, bills, and grants access on; getting visibility and initialization right at creation avoids leaked secrets and awkward history rewrites later.

## How it works

Account creation needs a username, email, and password; 2FA is **mandatory for all contributors since 2023**. A repo can be made via the web UI, the [[github-cli-gh|gh CLI]], or the REST API.

| Decision at creation | Options | Note |
|---|---|---|
| Visibility | public / private | private is free with limited Actions minutes |
| Initialize | README, .gitignore, LICENSE | skip if pushing an existing repo |
| Default branch | `main` | renamed from `master` in 2020 |

- Create empty (no README) when you already have local commits to push; create initialized when starting fresh on the web.
- `gh repo create acme/api --private --source=. --push` creates the remote and pushes your existing local repo in one step.
- The account email is what links commits to you — add and verify every email you commit with under Settings to Emails.

## Example

```
# Existing local project, brand-new GitHub repo, one command:
$ gh repo create acme/api --private --source=. --remote=origin --push
✓ Created repository acme/api on GitHub
✓ Added remote git@github.com:acme/api.git
✓ Pushed commits to git@github.com:acme/api.git
```

## Pitfalls

- **Initializing with a README then pushing existing history** — the remote already has a commit, so `git push` is rejected as non-fast-forward; create empty or reconcile with `--rebase`.
- **Unverified / mismatched commit email** — commits show as not yours and skip the contribution graph; use the GitHub `noreply` email to avoid leaking a real address.
- **Public-by-accident** — creating public and pushing secrets means rotating them even after deletion; they persist in clones and caches.

## See also

- [[readme-license-and-repository-structure]]
- [[github-cli-gh]]
