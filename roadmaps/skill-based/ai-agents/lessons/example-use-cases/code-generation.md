---
title: Code Generation
track: ai-agents
group: Example Use Cases
tags: [ai-agents, code-generation]
prerequisites: [agent-loop, code-execution-repl]
see-also: [file-system-access, integration-testing-for-flows]
---

# Code Generation

A code-generation agent writes and edits code in a real repo, then *runs the tests and compiler* to verify itself — closing the loop instead of emitting a one-shot snippet.

## Why it matters

Autocomplete suggests a line; a coding *agent* (Claude Code, Cursor, Aider, SWE-agent) takes a task like "add pagination to the users endpoint" and edits the right files, runs the suite, and fixes its own failures. The leap in capability comes entirely from the feedback loop: a failing test or stack trace is a precise [[observation-reflection|observation]] the model can act on, turning code generation from "hope it compiles" into measurable convergence. This is the highest-value agent use case today and the one with the cleanest reward signal — tests pass or they don't.

## How it works

The agent runs a plan → edit → run → read-errors loop over [[file-system-access|file]] and [[code-execution-repl|shell]] tools.

- **Locate, don't dump.** It greps/reads only the relevant files; pasting the whole repo blows the [[context-windows|window]] and buries the signal.
- **Edit as a diff.** Tools apply targeted patches (old→new string, or unified diff), not full-file rewrites, so changes are reviewable and cheap.
- **Verify every change.** Run `test`/`build`/`lint`; the exit code and stderr feed back as the observation.
- **Self-repair.** On failure the model reads the traceback, patches, re-runs — looping until green or a step cap.

| Tool | Purpose | Feedback |
|---|---|---|
| read_file / grep | locate code | file contents |
| apply_patch | edit a diff | applied / reject |
| run_tests / build | verify | pass-fail + stderr |
| run_lint | style/types | diagnostics |

## Example

A red-green self-repair turn:

```
task: "make parse_date accept ISO 8601"
  grep parse_date → utils/date.py
  apply_patch(date.py: add fromisoformat branch)
  run_tests → FAIL test_date.py::test_iso ValueError 'Z'
  read error → strptime can't parse trailing 'Z'
  apply_patch(strip 'Z' → +00:00)
  run_tests → 14 passed
```

The first patch was wrong; the agent fixed it from the failing assertion alone — no human re-prompt.

## Pitfalls

- **No test gate = confident breakage.** A patch that "looks right" but fails CI is worse than nothing; never report success without a green run.
- **Whole-file rewrites.** Regenerating a 500-line file to change 3 lines drops comments, reorders imports, and explodes the diff — patch surgically.
- **Sandbox escape.** `run` on arbitrary model-generated shell is RCE; isolate the workspace and gate network/destructive commands.
- **Context bloat.** Reading entire directories starves the window; retrieve files on demand and summarize long outputs.

## See also

- [[file-system-access]]
- [[integration-testing-for-flows]]
