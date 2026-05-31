---
title: GitHub Actions and CI/CD
track: git-github
group: GitHub advanced
tags: [git-github, ci-cd]
prerequisites: [pull-requests, branch-protection-rules]
see-also: [github-cli-gh, releases-and-packages]
---

# GitHub Actions and CI/CD

GitHub Actions is GitHub's built-in automation engine: YAML **workflows** in `.github/workflows/` run **jobs** of **steps** on events like push, PR, schedule, or manual dispatch.

## Why it matters

It is where "every PR must pass tests" becomes enforceable — wire a workflow into [[branch-protection-rules|branch protection]] as a required check and unreviewed-or-failing code can't merge. It also drives CD: build, sign, publish, and deploy on a tag or to `main`. Being co-located with the repo (no external CI to provision) makes it the default for most GitHub projects.

## How it works

A workflow is a tree: `on:` (triggers) → `jobs:` (run in parallel by default) → `steps:` (sequential, reuse actions via `uses:` or run shell via `run:`).

| Concept | Scope | Notes |
|---|---|---|
| Workflow | one `.yml` file | one or more triggers in `on:` |
| Job | runs on one runner | parallel unless `needs:` orders them |
| Step | one command/action | `uses: actions/checkout@v4` etc. |
| Runner | VM/container | `ubuntu-latest` = 4 vCPU / 16 GB |

- **Cost** — public repos run free; private repos bill by minute, and non-Linux is weighted: Linux x1, Windows x2, macOS x10. A 5-min macOS job costs 50 minutes of quota.
- **Secrets** — `${{ secrets.NAME }}` is masked in logs; never echo them. Use [[personal-access-tokens-and-ssh-keys|tokens]] or OIDC for cloud auth.
- **`GITHUB_TOKEN`** — an auto-minted per-run token; set `permissions:` to least privilege (default is read-only on newer repos).
- **Cache & matrix** — `actions/cache` keyed by a lockfile hash skips reinstalls; a `strategy.matrix` fans one job across versions/OSes.

## Example

```yaml
name: ci
on: { pull_request: {}, push: { branches: [main] } }
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix: { node: [18, 20, 22] }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: ${{ matrix.node }}, cache: npm }
      - run: npm ci && npm test
```

This runs three parallel jobs (Node 18/20/22); marking `test` required blocks merge until all pass.

## Pitfalls

- **`pull_request_target` with checkout of the PR head** — runs untrusted fork code *with* repo secrets; a classic exfiltration hole. Prefer `pull_request` (no secrets on forks).
- **Unpinned tags** — `uses: foo/bar@v2` follows a moving tag; a compromised release runs in your pipeline. Pin to a full commit SHA for supply-chain safety.
- **Over-broad `permissions`** — leaving `GITHUB_TOKEN` with `write` lets a malicious step push or open PRs; scope per workflow.
- **Forgetting `concurrency`** — rapid pushes pile up redundant runs; add a `concurrency` group with `cancel-in-progress: true`.

## See also

- [[github-cli-gh]]
- [[releases-and-packages]]
