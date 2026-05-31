---
title: File System Access
track: ai-agents
group: Tools an Agent Can Use
tags: [ai-agents, file-system]
prerequisites: [acting-tool-invocation]
see-also: [code-execution-repl, git-and-terminal-usage]
---

# File System Access

Tools that let an agent read, write, list, and search files on disk — the primitive behind coding agents and any workflow that produces or consumes documents.

## Why it matters

Files are how agents *persist work* and *operate on real artifacts*. A coding agent like this one lives on read/write/edit/glob/grep over a repo; a report generator writes a PDF; a data agent reads a dropped CSV. Files also serve as cheap [[long-term-memory]] outside the [[context-windows]] — scratchpads, notes, and intermediate outputs the model can re-read instead of holding everything in tokens.

## How it works

The tool exposes a small verb set, each scoped to a permitted root. The killer detail is **partial reads/edits**: never load a 10k-line file whole.

- **Core verbs** — `read(path, offset, limit)`, `write(path, content)`, `edit(path, old, new)`, `list(dir)`, `glob(pattern)`, `grep(regex)`. `glob` and `grep` keep the model from reading dozens of files to find one line.
- **Targeted edits** — string-replace or line-range edits beat rewriting whole files: fewer output tokens, less chance of clobbering unrelated code.
- **Sandbox the root** — confine to a project dir; resolve and reject any path escaping it (see Pitfalls). Enforce read-only vs read-write per tool.
- **Stat before read** — check size first; refuse or chunk files over a threshold so a binary or huge log never explodes context.

| Verb | Returns | Note |
|---|---|---|
| read | text slice | use offset/limit, not whole file |
| edit | success/diff | old-string must match uniquely |
| glob | path list | find files by name fast |
| grep | matching lines | find content without reading all |

## Example

```
grep("def parse_", "src/")        → src/io.py:42, src/io.py:88
read("src/io.py", offset=40, n=12)→ the two functions, 12 lines
edit("src/io.py",
     old="sep=','", new="sep=';'")→ one-line surgical change
```

The agent located, inspected, and edited code touching only ~12 lines of context.

## Pitfalls

- **Path traversal.** `../../etc/passwd` or a symlink escapes the sandbox; always resolve to an absolute real path and verify it's under the allowed root.
- **Non-unique edit targets.** A string-replace edit that matches multiple spots edits the wrong one — require a unique anchor or fail loudly.
- **Reading binaries/huge files** wastes the whole context window or returns garbage; gate on size and type.
- **Lost writes** — concurrent edits or no read-before-write overwrite changes; read current content first, and pair with [[git-and-terminal-usage]] for recoverability.

## See also

- [[code-execution-repl]]
- [[git-and-terminal-usage]]
