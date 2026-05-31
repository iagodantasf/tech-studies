---
title: CLAUDE.md Project Memory
track: claude-code
group: Project configuration
tags: [claude-code, memory]
prerequisites: [what-is-claude-code]
see-also: [nested-imported-memory-files, user-vs-project-vs-local-memory, claudeignore-file-scoping]
---

# CLAUDE.md Project Memory

`CLAUDE.md` is a plain-markdown file Claude Code auto-loads into every session's system context, giving the agent durable project knowledge it never has to rediscover.

## Why it matters

Without persistent memory the agent re-learns your conventions on every run: it greps for the build command, guesses the test runner, and re-proposes patterns your team already rejected. `CLAUDE.md` front-loads that knowledge once — build/test commands, directory layout, style rules, "do not touch" zones — so the model spends its [[time-and-space-complexity|context budget]] on the task, not on orientation. It is the single highest-leverage configuration file in the tool, and because it's committed to git it makes agent behavior reproducible across a whole team.

## How it works

On startup Claude walks **up** from the launch directory to the filesystem root, loading every `CLAUDE.md` it finds, then merges in the user-global one. All loaded files are concatenated into the system prompt — they cost real input tokens on every turn.

| Location | Scope | Committed? |
|---|---|---|
| `./CLAUDE.md` (repo root) | shared team memory | yes |
| `./CLAUDE.local.md` | personal, this repo | no (gitignore it) |
| `~/.claude/CLAUDE.md` | every project, this user | n/a |
| `<subdir>/CLAUDE.md` | that subtree only | usually |

- `# Memory` headings and bullet lists are conventional; the model reads it as prose, so structure for *a reader*, not a parser.
- `/init` scaffolds a starter `CLAUDE.md` by scanning the repo.
- The `#` shortcut at the REPL prompt appends a line to memory mid-session — e.g. `# always run ruff before committing`.
- `/memory` opens the active memory files in your editor to inspect or prune them.
- Subtree precedence: deeper files load *after* shallower ones, so a package-level `CLAUDE.md` can refine the root. See [[user-vs-project-vs-local-memory]] for the full hierarchy and [[nested-imported-memory-files]] for `@path` imports.

## Example

A concise, high-signal root `CLAUDE.md`:

```markdown
# Project: payments-api
- Build: `make build`  · Test: `pytest -q`  · Lint: `ruff check`
- Source in `src/`; never edit generated files in `src/proto/`.
- All money is integer cents (`int`), never floats — see ADR-014.
- Conventional Commits; PRs target `develop`, not `main`.
```

Four lines like this routinely save dozens of exploratory tool calls per session, because the agent already knows how to build, test, and what *not* to touch.

## Pitfalls

- **Bloat.** Every line is in-context on every turn; a 600-line `CLAUDE.md` quietly taxes latency and cost. Keep it tight and link out.
- **Stale instructions.** Memory the team forgot to update actively misleads the agent — treat it like code and review it in PRs.
- **Committing secrets or machine paths.** Personal/absolute-path notes belong in `CLAUDE.local.md`, not the shared file.
- **Treating it as enforcement.** It's guidance the model usually follows, not a hard gate — for guarantees use [[allow-deny-rules]] or [[hooks-overview-lifecycle]].

## See also

- [[nested-imported-memory-files]]
- [[user-vs-project-vs-local-memory]]
- [[claudeignore-file-scoping]]
