---
title: Namespaced & Project Commands
track: claude-code
group: Slash commands
tags: [claude-code, prompt-reuse]
prerequisites: [custom-slash-commands]
see-also: [command-arguments-arguments, frontmatter-allowed-tools, user-vs-project-vs-local-memory]
---

# Namespaced & Project Commands

Where a command file lives sets two things: its **scope** (project vs personal) and its **namespace** (the subdirectory it sits in), which together organize and disambiguate a growing command set.

## Why it matters

A real repo accumulates dozens of commands; flat naming collides and a wall of `/foo` `/bar` is unbrowsable. Subdirectory namespaces group them (`/test:unit`, `/db:migrate`) so the `/` menu reads like a CLI with subcommands. Scope, meanwhile, decides what travels: project commands ship in git for the whole team, personal commands stay in your home dir across every repo — the same project/personal split you see for memory ([[user-vs-project-vs-local-memory]]).

## How it works

Two roots, mirrored layout; the directory path *under* `commands/` becomes a colon-joined namespace prefix:

| File path | Command | Scope |
|---|---|---|
| `.claude/commands/deploy.md` | `/deploy` | project |
| `.claude/commands/db/migrate.md` | `/db:migrate` | project |
| `~/.claude/commands/scratch.md` | `/scratch` | personal |
| `~/.claude/commands/git/wip.md` | `/git:wip` | personal |

- The `/` menu tags each entry `(project)` or `(user)` so you can see where a command comes from.
- Namespacing is purely organizational — it does **not** restrict what the command can do; tools are governed by `allowed-tools` ([[frontmatter-allowed-tools]]) and global [[permission-modes]].
- Project commands are committed, so a teammate cloning the repo gets your `/db:migrate` for free — encode team workflows here, not in a wiki.
- A project and a personal command can share a name; they appear as distinct, scoped entries.

## Example

```text
project/
  .claude/commands/
    review.md            -> /review-pr   (project)
    test/unit.md         -> /test:unit   (project)
    test/e2e.md          -> /test:e2e    (project)
```

Typing `/test:` filters the menu to the two test commands — discoverable, grouped, and shared with everyone who clones the repo.

## Pitfalls

- **Namespace ≠ permission boundary.** A `/db:` command isn't sandboxed to the database; its power comes from `allowed-tools`, not its folder.
- **Deep nesting hurts.** `commands/a/b/c/cmd.md` → `/a:b:c:cmd` is unwieldy; one level of namespace is usually enough.
- **Committing personal scratch.** Putting throwaway commands in `.claude/commands/` pushes them to teammates — keep those in `~/.claude/commands/`.
- **Name drift across scopes.** A project and personal command of the same name both show in the menu; ambiguity invites running the wrong one.

## See also

- [[command-arguments-arguments]]
- [[frontmatter-allowed-tools]]
- [[user-vs-project-vs-local-memory]]
