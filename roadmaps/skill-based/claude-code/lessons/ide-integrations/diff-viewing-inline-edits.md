---
title: Diff Viewing & Inline Edits
track: claude-code
group: IDE integrations
tags: [claude-code, diffs]
prerequisites: [built-in-tools-read-edit-bash-etc]
see-also: [vs-code-extension, jetbrains-integration, terminal-vs-ide-workflow]
---

# Diff Viewing & Inline Edits

How Claude Code renders proposed `Edit`/`Write` changes as reviewable diffs — in the IDE's native viewer or the terminal — before anything touches disk.

## Why it matters

Every file mutation is a *proposal* you approve, and the diff is your last checkpoint before code lands. Seeing it in the IDE's real diff viewer (syntax-highlighted, scrollable, editable) instead of a cramped terminal patch is the single biggest review-quality win of the IDE integrations. It also closes a subtle trust gap: you can hand-edit the proposed side, and Claude is told you changed it rather than silently assuming the file matches its draft.

## How it works

When an [[built-in-tools-read-edit-bash-etc]] `Edit`/`Write` fires, Claude Code shows the original vs proposed content and waits for a permission decision (unless [[auto-accept-bypass-modes]] is on). Where it renders is controlled by one config knob, not per-IDE:

- Run `/config` and set the diff tool to **`auto`** (use the connected IDE's viewer) or **`terminal`** (keep it inline in the terminal).
- In VS Code the panel shows a **side-by-side** comparison with a permission prompt; you may edit the proposed side directly before accepting.
- In JetBrains the change opens in the IDE's diff viewer when a session is connected (see [[jetbrains-integration]]).
- The IDE diff is driven by the local `ide` MCP server — the same channel that shares your selection and diagnostics.

Decisions on a shown diff:

| Action | Result |
|---|---|
| Accept | edit written to disk |
| Reject | edit discarded, file untouched |
| Edit then accept | your modified version is written; Claude is told it differs |
| Tell Claude instead | redirect with a follow-up instruction |

Beyond a single diff, the VS Code extension adds **checkpoints**: hover any message to rewind.

## Example

Claude proposes renaming a symbol across `service.ts`. With diff tool `auto` in VS Code, a side-by-side opens. You notice it missed a call site, so you type the fix into the proposed pane and accept — Claude records that you modified its draft. Two messages later you decide the whole approach was wrong: hover that earlier message, pick "Rewind code to here", and the files revert while the conversation stays intact (a "Fork conversation and rewind code" option also branches the chat).

## Pitfalls

- **Diffs stuck in the terminal.** From an external terminal you must `/ide` first; and if the diff tool is `terminal`, set it to `auto` via `/config`.
- **Hand-edits silently lost.** Editing the proposed side only counts if you then **accept** that diff — rejecting throws away your tweak too.
- **Rewind isn't full undo.** Checkpoints track Claude's file edits, not your manual terminal commands or external changes; review [[managing-context-clear-compact]] limits before relying on it.
- **Auto-accept skips the review.** With `acceptEdits`/bypass on, diffs apply without a prompt — fine for trusted loops, dangerous on untrusted code.

## See also

- [[vs-code-extension]]
- [[jetbrains-integration]]
- [[terminal-vs-ide-workflow]]
