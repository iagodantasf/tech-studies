---
title: Image & File Input
track: claude-code
group: CLI usage
tags: [claude-code, multimodal]
prerequisites: [first-session-repl-basics]
see-also: [interactive-mode, piping-input-output, claudeignore-file-scoping]
---

# Image & File Input

Claude Code can take files and images as input — attach a path with `@`, paste a screenshot, or let the agent Read files itself — feeding non-prompt context to a multimodal model.

## Why it matters

A lot of debugging context isn't text you can type: a failing-UI screenshot, an error dialog, an architecture diagram, a design mock to implement. Image input lets the agent *see* what you see; file attachment pins exact context up front instead of hoping its Grep finds the right file. This turns "here's a picture of the bug" into an actionable session.

## How it works

- **`@` path completion** in the REPL attaches a file as context: `explain @src/db/pool.go`. It tab-completes paths and inserts the reference inline.
- **Images** (PNG/JPG/etc.) can be **pasted** directly into the prompt (`Ctrl+V`; macOS Terminal often needs `Cmd+V`), **dragged** onto the window, or referenced by `@path/to/shot.png`. The model reads them visually — UI, diagrams, stack-trace screenshots.
- **Agent-initiated reads:** you often don't attach anything — a prompt like "why does checkout fail?" lets Claude use its **Read** tool ([[built-in-tools-read-edit-bash-etc]]) to open files it finds via Grep/Glob.
- **`--file file_id:path`** downloads a remote file resource at startup; **stdin piping** ([[piping-input-output]]) feeds file *contents* in headless runs.

| Method | Best for | Mode |
|---|---|---|
| `@path` | pinning a known file | interactive |
| paste / drag image | screenshots, diagrams | interactive |
| Read tool (auto) | letting the agent find files | both |
| stdin pipe | file contents in scripts | headless |

## Example

```text
> here's the broken layout  [paste screenshot of misaligned navbar]
  the CSS is in @web/styles/nav.css — make it match the mock
  …Claude reads the image + the file, proposes a flex fix, you approve…
```

The screenshot supplies the visual bug; `@web/styles/nav.css` pins the exact file so no Grep guesswork is needed.

## Pitfalls

- **Terminal paste quirks.** Not every terminal forwards image paste; if it fails, drag the file or use `@path` to a saved screenshot instead.
- **Huge files via `@`.** Attaching a giant file dumps it all into context — point at the relevant file, or let the agent Read selectively.
- **Ignored-but-attached.** `@`-ing a path under [[claudeignore-file-scoping|.claudeignore]] can still surprise you; ignore rules shape auto-discovery, not explicit attachments.
- **Low-res screenshots.** Tiny or compressed images make text/UI unreadable to the model — capture at legible resolution.

## See also

- [[interactive-mode]]
- [[piping-input-output]]
- [[claudeignore-file-scoping]]
