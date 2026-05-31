---
title: Git & PR Workflows
track: claude-code
group: Workflows & automation
tags: [claude-code, git]
prerequisites: [built-in-tools-read-edit-bash-etc, allow-deny-rules]
see-also: [github-actions-integration, headless-ci-usage, security-safe-tool-use]
---

# Git & PR Workflows

Using Claude Code as a git operator — staging, committing, branching, and opening PRs through `Bash` and the `gh` CLI, with permission rules that keep the dangerous verbs gated.

## Why it matters

Most real sessions end in a commit or a PR, and the agent is good at the tedious parts: writing a faithful commit message from the diff, splitting a sprawling change into reviewable commits, or drafting a PR body that actually describes the change. The risk is concentrated in a few commands (`push`, `reset --hard`, `commit`), so the value is letting the safe 90% flow while fencing the irreversible 10%.

## How it works

Git is just `Bash`, so it obeys [[allow-deny-rules]]. A typical project policy:

| Command class | Policy | Why |
|---|---|---|
| `git status/diff/log/add` | allow | read-only or trivially reversible |
| `git commit` | ask | the message is the artifact; eyeball it |
| `git push` | ask / deny | publishes; hardest to undo |
| `git reset --hard`, `clean -fd` | deny | destroys uncommitted work |

- Claude writes commit messages from the staged diff; pair it with a project convention (Conventional Commits) in `CLAUDE.md` so output is consistent.
- PRs go through `gh pr create --title ... --body ...`; allow `Bash(gh pr:*)` and `Bash(gh issue:*)` to let the agent open and comment without opening shell wholesale.
- On the default branch, instruct it (via memory) to branch first — `git switch -c feat/x` — so work never lands directly on `main`.
- For headless commit-message generation, pipe the diff into [[one-shot-print-mode-p]] with no tools; for full PR flows, grant the scoped git/`gh` commands.

## Example

```bash
# Project .claude/settings.json snippet
{ "permissions": {
    "allow": ["Bash(git status)", "Bash(git diff:*)", "Bash(git add:*)", "Bash(gh pr view:*)"],
    "ask":   ["Bash(git commit:*)", "Bash(git push:*)", "Bash(gh pr create:*)"],
    "deny":  ["Bash(git reset --hard:*)", "Bash(git clean:*)", "Bash(git push --force:*)"] } }
```

Now "stage the auth fix, commit it, and open a PR" runs `add` silently, pauses on `commit` and `pr create` for your nod, and can never force-push or hard-reset.

## Pitfalls

- **Bash prefix matching is not parsing.** `Bash(git:*)` won't stop `git push` hidden behind `&&` or a subshell; deny the specific destructive verbs and keep raw `Bash` gated.
- **Committing secrets/junk.** A blanket `git add -A` can sweep in `.env` or build output; deny reads of secret paths and prefer scoped `git add <path>`.
- **Force-push footguns.** `--force` overwrites remote history; deny it outright and use `--force-with-lease` manually if ever needed.
- **Co-author / convention drift.** Without a memory rule, message style wanders — pin the format and any required trailers in `CLAUDE.md`.

## See also

- [[github-actions-integration]]
- [[headless-ci-usage]]
- [[security-safe-tool-use]]
