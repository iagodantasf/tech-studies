---
title: Frontmatter & Allowed Tools
track: claude-code
group: Slash commands
tags: [claude-code, permissions]
prerequisites: [custom-slash-commands]
see-also: [command-arguments-arguments, allow-deny-rules, choosing-a-model]
---

# Frontmatter & Allowed Tools

A custom command's YAML frontmatter configures its metadata and — via `allowed-tools` — pre-authorizes a tight set of tool calls, so the command can run its shell/file steps without pausing for approval.

## Why it matters

By default any Bash or Edit a command triggers stops for your `y/n` (see [[allow-deny-rules]]), which defeats a "one-keystroke" workflow. Scoping `allowed-tools` to exactly the commands the template needs — `Bash(git diff:*)` and nothing else — lets it execute unattended *and* keeps it from doing anything outside that narrow grant. The rest of the frontmatter (`description`, `argument-hint`, `model`) is what makes a command discoverable and pin its cost.

## How it works

Frontmatter is an optional YAML block at the top of the `.md` file. Recognized keys:

| Key | Purpose |
|---|---|
| `description` | one-line summary shown in the `/` menu |
| `argument-hint` | placeholder text, e.g. `<issue-number>` (see [[command-arguments-arguments]]) |
| `allowed-tools` | tools this command may use without prompting |
| `model` | force a model for this command (see [[choosing-a-model]]) |

- `allowed-tools` uses the same rule grammar as settings/permissions: `Tool` or `Tool(scope:pattern)`, e.g. `Bash(npm test:*)`, `Read`, `Edit`.
- The grant is **command-scoped and additive** for that run — it widens what runs silently *inside this command*, layered on your session permission mode; it does not loosen global rules elsewhere.
- It is an *allow*-list: a `!`shell line or model tool call matching a pattern runs un-prompted; anything not matched still falls back to a normal approval prompt.
- Tighter patterns are safer: `Bash(git add:*)` permits only `git add …`, not arbitrary `git`.

## Example

`.claude/commands/commit.md`:

```markdown
---
description: Stage all and write a conventional commit
argument-hint: [scope]
allowed-tools: Bash(git add:*), Bash(git commit:*), Bash(git diff:*)
model: claude-haiku-4-5
---
Review the diff, stage changes, and commit with a Conventional
Commit subject (scope: $1).
!`git diff HEAD`
```

`/commit api` runs `git diff` / `git add` / `git commit` silently on cheap Haiku — but if the model tried `git push`, that's outside the allowlist and would prompt.

## Pitfalls

- **Over-broad grants.** `allowed-tools: Bash(*)` (or bare `Bash`) auto-approves *any* shell command — a foot-gun in a committed, shared file; scope every pattern.
- **It can't override a deny.** A global deny rule still blocks the call; `allowed-tools` only widens within what permissions permit.
- **YAML strictness.** A missing `---`, bad indent, or unquoted special char makes the whole block fail to parse; the command then runs with *no* frontmatter and no grants.
- **`model` surprises cost/behavior.** Pinning Opus on a high-frequency command quietly inflates spend; match the model to the job.

## See also

- [[command-arguments-arguments]]
- [[allow-deny-rules]]
- [[choosing-a-model]]
