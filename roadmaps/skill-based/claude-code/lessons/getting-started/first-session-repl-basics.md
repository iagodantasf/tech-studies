---
title: First Session & REPL Basics
track: claude-code
group: Getting started
tags: [claude-code, repl]
prerequisites: [installation-setup, authentication-api-keys]
see-also: [interactive-mode, managing-context-clear-compact, keyboard-shortcuts-vim-mode]
---

# First Session & REPL Basics

A Claude Code session is an interactive REPL in your terminal where you type natural-language requests, watch tool calls, approve actions, and steer a multi-turn conversation about your repo.

## Why it matters

The REPL is where you actually drive the agent, and a few primitives — slash commands, approval prompts, `@` file mentions, interrupt — separate a smooth session from a frustrating one. Knowing them turns "type and pray" into a controllable loop: you stay in the conversation, redirect mid-task, and keep the context window healthy instead of restarting from scratch.

## How it works

Run `claude` to enter the REPL. You type a request, Claude responds and may call tools; for anything mutating (Edit, Bash) it pauses for approval unless permissions allow it (see [[permission-modes]]).

| Input | Effect |
|---|---|
| plain text | a request / message to Claude |
| `/command` | a slash command — REPL control |
| `@path/to/file` | mention a file to pull it into context |
| `Esc` | interrupt Claude mid-response or mid-tool |
| `Ctrl+C` / `Ctrl+D` | cancel input / exit the session |

- Conversation is **stateful**: each turn sees the prior turns until you `/clear` or the window fills.
- Useful [[built-in-slash-commands]]: `/help`, `/status`, `/clear` (wipe context), `/compact` (summarize to reclaim room) — see [[managing-context-clear-compact]].
- `Esc` twice (or `/rewind`-style) lets you back out of a wrong direction without killing the session.
- A long answer can be **interrupted** with `Esc` to add a correction — you don't have to wait for it to finish.
- Multi-line input and an optional vim editing mode exist for composing bigger prompts — see [[keyboard-shortcuts-vim-mode]].

## Example

```text
$ claude
> add input validation to the signup handler and run the tests
  ⏺ Grep "signup" … Read src/auth/signup.ts
  ⏺ Edit src/auth/signup.ts  [approve? y]
  ⏺ Bash: npm test            [approve? y]
  … 2 failing → Edit → re-run → green
> /compact         # summarize this thread, free up context
> now add a test for the empty-email case
```

One continuous conversation: it built on the earlier edits because the session kept that history.

## Pitfalls

- **Letting context bloat.** A 200-message thread degrades and gets slow; `/clear` between unrelated tasks and `/compact` within a long one.
- **Walking away during approvals.** In default mode Claude blocks waiting for your `y`; an unattended session can stall for hours on the first Bash prompt.
- **Forgetting `@` exists.** Describing a file in prose when you could `@`-mention it wastes tokens and risks Claude grepping for the wrong one.
- **`Ctrl+C` to fix a typo.** It cancels the turn; use `Esc` to interrupt and steer while keeping the conversation alive.

## See also

- [[interactive-mode]]
- [[managing-context-clear-compact]]
- [[keyboard-shortcuts-vim-mode]]
