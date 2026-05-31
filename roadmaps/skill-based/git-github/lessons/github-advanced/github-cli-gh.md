---
title: GitHub CLI (gh)
track: git-github
group: GitHub advanced
tags: [git-github, tooling]
prerequisites: [pull-requests, personal-access-tokens-and-ssh-keys]
see-also: [github-actions-and-ci-cd, github-issues]
---

# GitHub CLI (gh)

`gh` is GitHub's official command-line tool: it drives the GitHub *platform* — PRs, issues, releases, Actions, the API — from the terminal, complementing `git` which only drives the repo.

## Why it matters

It collapses the open-browser-click-buttons loop into one command, which is what makes PR-driven work scriptable and CI-friendly. `gh pr create`, `gh pr checkout 142`, `gh run watch` keep you in the terminal; `gh api` is a thin authenticated wrapper over the REST/GraphQL API for anything without a dedicated subcommand. It is preinstalled on GitHub-hosted [[github-actions-and-ci-cd|Actions]] runners.

## How it works

`gh` authenticates once and stores a token, then maps subcommands to API calls; it infers the repo from the current clone's `origin`.

| Command | Does |
|---|---|
| `gh auth login` | OAuth device flow; saves token |
| `gh pr create --fill` | open a PR from current branch |
| `gh pr checkout 142` | fetch PR #142 into a local branch |
| `gh issue list -l bug` | list issues by label |
| `gh run watch` | live-tail a workflow run |
| `gh api repos/{owner}/{repo}` | raw API call (auto-auth) |

- **PRs & issues** — `gh pr create`/`checkout`/`merge` cover the [[pull-requests|PR]] lifecycle, while `gh issue` manages [[github-issues]], all from the branch you're on.
- **Auth** — `gh auth login` runs a browser OAuth flow and mints a token with the scopes you pick; CI uses `GH_TOKEN`/`GITHUB_TOKEN` from the environment instead (no interactive login).
- **Scriptable output** — `--json <fields>` emits structured JSON; pipe through `--jq '.[].number'` (built-in jq) for shell loops. Far sturdier than scraping text.
- **Extensions** — `gh extension install owner/gh-foo` adds third-party subcommands; `gh alias set` saves shortcuts.
- **Token reuse** — `gh auth token` prints the stored token, handy as a credential helper for `git` over HTTPS.

## Example

```
$ gh pr create --base main --title "Add rate limiter" --fill
https://github.com/acme/api/pull/142
$ gh pr checks 142 --watch        # block until CI is green/red
$ gh pr merge 142 --squash --delete-branch
$ gh api -X PATCH repos/acme/api --field default_branch=main
```

## Pitfalls

- **Confusing `gh` with `git`** — `gh` won't commit or push code; it acts on GitHub objects. They are separate tools that share a repo context.
- **`GH_TOKEN` vs `GITHUB_TOKEN` in Actions** — the default `GITHUB_TOKEN` can't trigger other workflows or cross repos; export a PAT as `GH_TOKEN` when you need broader scope.
- **Wrong repo inferred** — outside a clone, or with multiple remotes, `gh` guesses wrong; pass `-R owner/repo` explicitly.
- **Parsing human output** — default tables aren't a stable contract; always use `--json`/`--jq` in scripts.

## See also

- [[github-actions-and-ci-cd]]
- [[github-issues]]
