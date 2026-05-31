---
title: Custom Slash Commands
track: claude-code
group: Slash commands
tags: [claude-code, prompt-reuse]
prerequisites: [built-in-slash-commands]
see-also: [command-arguments-arguments, namespaced-project-commands, frontmatter-allowed-tools]
---

# Custom Slash Commands

A custom slash command is a Markdown file whose body becomes a reusable prompt template, invoked by its filename as `/name`.

## Why it matters

Teams accumulate prompts they retype daily — "review this diff for security issues", "write a conventional-commit message", "update the changelog". Hard-coding them as files makes them versioned, shareable, and one keystroke away, so the prompt that works lives in git instead of in someone's head. Combined with arguments ([[command-arguments-arguments]]) and a tool allowlist ([[frontmatter-allowed-tools]]), a command becomes a tiny, reviewable automation — closer to a script than a snippet.

## How it works

Drop a `.md` file in a commands directory; the **basename** (sans `.md`) is the command name and the **file body** is the prompt injected when you run it.

| Location | Scope | Shown as |
|---|---|---|
| `.claude/commands/` | project (committed, shared) | `(project)` |
| `~/.claude/commands/` | personal (all your repos) | `(user)` |

- No restart needed — files are picked up live; `/help` lists them alongside built-ins.
- Optional YAML frontmatter sets `description`, `argument-hint`, `allowed-tools`, `model` (see [[frontmatter-allowed-tools]]).
- The body is *just a prompt*: write the instructions you'd otherwise type. It is sent to the model, which then plans and calls tools normally.
- Two power features inside the body: a line beginning `!` runs a shell command and inlines its **output**; a `@path` reference pulls a **file** into context. `$ARGUMENTS` / `$1` splice in invocation args.
- Subdirectories create namespaces (see [[namespaced-project-commands]]).

## Example

`.claude/commands/changelog.md`:

```markdown
---
description: Draft a CHANGELOG entry from staged changes
allowed-tools: Bash(git diff:*)
---
Summarize the staged diff below into a Keep-a-Changelog entry
under "## [Unreleased]". Group as Added/Changed/Fixed.

Staged diff:
!`git diff --cached`
```

Running `/changelog` executes `git diff --cached`, feeds the real diff to the model, and gets back a formatted entry — no copy-paste.

## Pitfalls

- **It runs as a prompt, not deterministic code.** The model still interprets it; phrasing matters, and output varies run to run.
- **`!` commands execute on your shell.** A command file is executable intent — review shared ones, and scope `allowed-tools` so they don't prompt mid-run.
- **Filename = command name.** Spaces or odd chars in the filename make a clumsy command; use kebab-case basenames.
- **Stale committed commands.** A `(project)` command outlives its author; an out-of-date prompt silently misleads teammates — treat them like code in review.

## See also

- [[command-arguments-arguments]]
- [[namespaced-project-commands]]
- [[frontmatter-allowed-tools]]
