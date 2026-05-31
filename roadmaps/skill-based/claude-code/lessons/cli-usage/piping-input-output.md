---
title: Piping Input & Output
track: claude-code
group: CLI usage
tags: [claude-code, unix-pipes]
prerequisites: [one-shot-print-mode-p]
see-also: [cli-flags-options, headless-ci-usage, building-headless-agents]
---

# Piping Input & Output

Claude Code behaves like a standard Unix filter: pipe data in on stdin, capture its answer on stdout, and chain it with `grep`, `jq`, `git`, and friends.

## Why it matters

The power of the shell is composition. Because `claude -p` reads stdin and writes stdout, you can drop a model into existing pipelines — summarise logs, triage a diff, transform a file — without bespoke tooling. This is what separates Claude Code from a chat box: it slots into the same plumbing as [[operating-systems|every other CLI]].

## How it works

- **stdin is the input.** Piped content becomes the prompt context: `cat err.log | claude -p "what failed?"`. A trailing `-p "<text>"` *plus* piped stdin combines both (instruction + data).
- **stdout is the answer.** Redirect or pipe onward: `… | claude -p "…" > out.md`.
- Use `--output-format json` for structured capture and parse with `jq` (`.result`, `.total_cost_usd`, `.session_id`); use `stream-json` to process events live.
- stderr carries diagnostics/errors, kept separate from the answer so `2>/dev/null` won't corrupt parsed output.
- For multi-turn streaming pipelines, `--input-format stream-json --output-format stream-json` lets a parent process drive a live conversation (the basis of [[building-headless-agents]]).

```text
producer ─┬─► claude -p ─► consumer
 stdin    │     stdout
 (data)   │     (answer / JSON)
```

## Example

```bash
# Triage the last failing CI run: feed logs in, get a ranked cause list out
gh run view --log-failed \
  | claude -p "List the top 3 likely root causes, most likely first" \
           --output-format json --allowedTools "" \
  | jq -r '.result'
```

The logs arrive on stdin; `claude` reasons over them; `jq` pulls the prose out of the JSON envelope for the next step or a Slack post.

## Pitfalls

- **Huge stdin.** Piping a multi-MB log blows the context window and cost — pre-filter with `tail`/`grep` first.
- **Mixing prose output into parsers.** Default `text` output isn't a contract; switch to JSON before piping to `jq`/`awk`.
- **Lost exit codes.** In a pipeline only the last command's status survives by default — set `pipefail` (`set -o pipefail`) to catch a `claude` failure mid-pipe.
- **TTY-only features.** With piped stdout the trust dialog and interactive approvals vanish; gate tools with [[allow-deny-rules]] up front.

## See also

- [[cli-flags-options]]
- [[headless-ci-usage]]
- [[building-headless-agents]]
