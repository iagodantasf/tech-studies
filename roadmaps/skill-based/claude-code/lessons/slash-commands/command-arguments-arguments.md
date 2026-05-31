---
title: Command Arguments ($ARGUMENTS)
track: claude-code
group: Slash commands
tags: [claude-code, prompt-reuse]
prerequisites: [custom-slash-commands]
see-also: [frontmatter-allowed-tools, namespaced-project-commands, built-in-slash-commands]
---

# Command Arguments ($ARGUMENTS)

Argument placeholders let a custom slash command accept input at call time, so one template parameterizes over an issue number, a filename, a flag — turning a static prompt into a reusable function.

## Why it matters

A command with no inputs can only ever do one fixed thing. The moment you want `/fix-issue 1234` or `/review src/auth.ts`, you need to thread the caller's words into the prompt body. Argument substitution is what makes commands compose like shell scripts rather than read like bookmarks — the same `fix-issue` template works for every ticket, and positional args ([[custom-slash-commands]]) let you build small, structured interfaces.

## How it works

Inside a command file, placeholders are textually replaced before the prompt is sent to the model:

| Placeholder | Expands to |
|---|---|
| `$ARGUMENTS` | everything typed after the command name, verbatim |
| `$1`, `$2`, … | individual whitespace-split positional args |

- `/deploy staging v2` with body using `$1` `$2` → `$1`=`staging`, `$2`=`v2`; `$ARGUMENTS`=`staging v2`.
- Substitution is **plain string interpolation** — there is no type checking, escaping, or required-arg enforcement. A missing `$2` expands to empty.
- Args combine with `!`-shell and `@`-file features: e.g. `!`git show $1`` runs against the arg, or `@$1` reads the file the caller named.
- Use `argument-hint` in frontmatter (see [[frontmatter-allowed-tools]]) to show expected args in the `/` menu, e.g. `argument-hint: <issue-number>`.

## Example

`.claude/commands/fix-issue.md`:

```markdown
---
argument-hint: <issue-number>
allowed-tools: Bash(gh issue view:*)
---
Fix GitHub issue #$1. First read it:
!`gh issue view $1`
Then locate the cause, propose a patch, and add a regression test.
```

Invoked as `/fix-issue 412`: `$1` becomes `412`, `gh issue view 412` runs and its output is inlined, and the model works the real ticket.

## Pitfalls

- **No required-arg guard.** Omit the arg and `$1` silently becomes empty — the model may improvise on a blank; validate intent in the prompt wording.
- **Whitespace splitting is naive.** `$1` is split on spaces, so a quoted multi-word arg still splits; for free-form text prefer `$ARGUMENTS`.
- **Unsanitized into shell.** `$1` interpolated into a `!`command is injected raw — a hostile or sloppy arg can alter the command; scope `allowed-tools` and don't pipe args into destructive shells.
- **`$ARGUMENTS` vs `$1` confusion.** `$ARGUMENTS` is the whole string including later positionals; mixing both in one template double-includes text.

## See also

- [[frontmatter-allowed-tools]]
- [[namespaced-project-commands]]
- [[built-in-slash-commands]]
