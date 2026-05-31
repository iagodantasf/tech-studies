---
title: Interactive Mode
track: claude-code
group: CLI usage
tags: [claude-code, repl]
prerequisites: [first-session-repl-basics]
see-also: [one-shot-print-mode-p, keyboard-shortcuts-vim-mode, managing-context-clear-compact]
---

# Interactive Mode

Interactive mode is the default `claude` REPL: a persistent terminal session that keeps conversation history, tool state, and context window alive across many turns.

## Why it matters

Most real work is iterative — you read a diff, refine the ask, approve a Bash call, course-correct. A one-shot call ([[one-shot-print-mode-p]]) throws all of that away each invocation. Interactive mode keeps the *same* context window and permission grants warm, so the agent remembers what it just edited and you amortise the cost of loading the codebase into context across a whole task instead of paying it per prompt.

## How it works

Running `claude` with no `-p` opens the REPL bound to your launch directory. Inside it:

- Plain text is a prompt; a line starting with `/` is a slash command (see [[built-in-slash-commands]]); `@` triggers file path completion to attach files.
- Submit with `Enter`; insert a literal newline with `\` + `Enter` or `Option/Alt+Enter`. `Esc` interrupts the agent mid-turn without killing the session.
- Each Bash/Edit tool call pauses for approval unless pre-granted via [[permission-modes]]; `Shift+Tab` cycles permission modes (e.g. into [[plan-mode]] or accept-edits).
- A live status line shows the model, token/context usage, and cost; `/cost` and `/context` print details.

| Action | Key / command |
|---|---|
| Interrupt current turn | `Esc` |
| Cancel / clear input line | `Ctrl+C` (twice to quit) |
| Edit prior message | `Esc` twice, then arrows |
| Cycle permission mode | `Shift+Tab` |
| Reset context | `/clear` (see [[managing-context-clear-compact]]) |

## Example

```bash
cd ~/code/api && claude          # REPL opens, scoped to ./api
> find where rate limiting is enforced
  …Claude greps, Reads middleware/ratelimit.go, summarises…
> now add a 429 test for it
  …proposes Edit, asks to run `go test ./...` — you approve…
> Esc                            # you change your mind mid-run
> actually use table-driven tests
```

The second and third prompts reuse the context loaded by the first — no re-grepping the repo.

## Pitfalls

- **Context creep.** Long sessions silently fill the window; watch `/context` and use `/compact` or `/clear` before it auto-compacts at an awkward point.
- **`Ctrl+C` muscle memory.** One `Ctrl+C` clears the input line, not the agent — use `Esc` to actually stop a running turn.
- **Forgetting the cwd boundary.** The REPL only reaches its launch subtree; `--add-dir` is required to touch sibling repos.
- **Treating it like chat.** It executes tools on your real shell — review each approval; don't blind-approve in a loop.

## See also

- [[one-shot-print-mode-p]]
- [[keyboard-shortcuts-vim-mode]]
- [[managing-context-clear-compact]]
