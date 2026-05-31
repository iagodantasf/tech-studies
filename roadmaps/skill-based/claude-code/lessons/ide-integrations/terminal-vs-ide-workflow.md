---
title: Terminal vs IDE Workflow
track: claude-code
group: IDE integrations
tags: [claude-code, workflow]
prerequisites: [installation-setup]
see-also: [vs-code-extension, jetbrains-integration, diff-viewing-inline-edits]
---

# Terminal vs IDE Workflow

How to choose between running Claude Code as a pure terminal CLI versus connecting it to an editor, and what the IDE link actually adds.

## Why it matters

Claude Code is fundamentally a CLI; the IDE integrations are a *connection* layered on top, not a separate product. Picking the right mode decides whether edits show as real diffs, whether your cursor selection is auto-shared, and which features you get. Pick wrong and you either lose the niceties (raw terminal, no diff viewer) or hit the GUI's gaps (no `!` bash shortcut, no tab completion, only a subset of slash commands).

## How it works

There are three shapes, and the connection ("is an IDE attached?") is orthogonal to the surface (terminal vs GUI panel):

| Mode | Diffs | Selection auto-shared | CLI-only features |
|---|---|---|---|
| Bare terminal (no IDE) | in-terminal | no | all |
| CLI in IDE's integrated terminal | IDE viewer (if `auto`) | yes | all |
| VS Code GUI panel | IDE viewer | yes | subset only |

- Run `claude` inside an IDE's **integrated terminal** and it auto-connects — diffs, diagnostics, and selection sharing turn on with no extra step.
- From an **external terminal**, run `/ide` to attach to a running editor.
- The connection is brokered by a local `ide` MCP server bound to `127.0.0.1` on a random port, with a per-session token under `~/.claude/ide/` (mode `0600`). It exposes `mcp__ide__getDiagnostics` (and, for notebooks, `mcp__ide__executeCode`) to the model.
- The VS Code GUI panel and CLI **share one history**: bounce between them with `claude --resume`. See [[vs-code-extension]] and [[jetbrains-integration]].

## Example

A senior dev's common loop: keep the editor open for review, drive from the integrated terminal.

```text
1. open repo in VS Code / IntelliJ
2. Ctrl+` -> claude          (auto-connects; diffs land in the editor)
3. select a function, Option+K (Cmd+Option+K in JetBrains) -> @file#L10-20
4. ask; review the side-by-side diff; accept
5. need !npm test inline or full /commands -> already in the terminal, use them
```

If you'd started `claude` in a separate iTerm window, step 2 becomes `/ide` to get the diffs into the editor.

## Pitfalls

- **Assuming the GUI panel is the whole product.** It's a curated subset; `!`, tab completion, and some `/` commands only exist in the CLI — drop to the integrated terminal for them.
- **External terminal, no diffs.** Forgetting `/ide` leaves edits rendering in the terminal; the editor never lights up.
- **Wrong directory breaks the link.** Launch `claude` from the IDE project root so its file set matches the editor's.
- **Two surfaces, divergent expectations.** Resuming the same session in CLI vs panel is fine (shared history), but features differ — don't assume a panel-only convenience exists in the CLI or vice versa.

## See also

- [[vs-code-extension]]
- [[jetbrains-integration]]
- [[diff-viewing-inline-edits]]
