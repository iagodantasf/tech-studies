---
title: GitHub Actions Integration
track: claude-code
group: Workflows & automation
tags: [claude-code, github-actions]
prerequisites: [headless-ci-usage, git-pr-workflows]
see-also: [git-pr-workflows, security-safe-tool-use, cost-context-optimization]
---

# GitHub Actions Integration

The `anthropics/claude-code-action` GitHub Action that runs Claude Code inside a workflow, letting `@claude` mentions and CI events trigger an agent that reads, edits, and comments on code.

## Why it matters

It turns the agent into a teammate that lives in the PR: tag `@claude fix the failing test` in a comment and it opens a branch, edits files, pushes, and replies — or run it on every PR to auto-review. The integration handles the GitHub plumbing (token, checkout, commit, comment) so you don't hand-roll the headless glue from [[headless-ci-usage]].

## How it works

Add a workflow that reacts to issue/PR comment events and calls the action. Two auth shapes:

| Auth | Setup | Use when |
|---|---|---|
| Anthropic API | `anthropic_api_key` secret | direct API billing |
| Bedrock / Vertex | OIDC + `use_bedrock`/`use_vertex` | cloud-hosted models |

- A `prompt` input runs a fixed task (good for scheduled review); omit it and the action responds to `@claude` mentions in the triggering comment.
- The job needs `permissions: { contents: write, pull-requests: write }` so the agent can push commits and post comments; without write scope it can only read.
- Tool access is bounded by `claude_args` (e.g. `--allowedTools`, `--max-turns`), passed straight through to the CLI — the same allow/deny discipline as any headless run.
- Gate it behind `if: contains(github.event.comment.body, '@claude')` and a teammate-only actor check so outside contributors can't trigger paid runs on your token.

## Example

```yaml
name: claude
on:
  issue_comment:
    types: [created]
jobs:
  claude:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions: { contents: write, pull-requests: write, issues: write }
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          claude_args: "--allowedTools Read,Edit,Bash(npm test:*) --max-turns 15"
```

A comment like "@claude make the flaky retry test deterministic" now spins up the agent with read/edit and a scoped `npm test`.

## Pitfalls

- **Open trigger = token abuse.** Any commenter firing the action spends *your* key and can run tools; restrict by actor/association, not just the mention string.
- **Missing write permissions.** Default `GITHUB_TOKEN` is read-only on forks and often repo-wide; without explicit `contents: write` the agent silently can't push.
- **Unbounded turns/budget.** A vague task with no `--max-turns` (or budget) can loop until the job times out — cap both.
- **Fork PRs lack secrets.** `pull_request` from a fork can't see `secrets`; use `pull_request_target` carefully or restrict to same-repo branches.

## See also

- [[git-pr-workflows]]
- [[security-safe-tool-use]]
- [[cost-context-optimization]]
