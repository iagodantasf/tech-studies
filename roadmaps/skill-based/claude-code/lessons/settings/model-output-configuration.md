---
title: Model & Output Configuration
track: claude-code
group: Settings
tags: [claude-code, models]
prerequisites: [choosing-a-model]
see-also: [choosing-a-model, environment-variables, one-shot-print-mode-p]
---

# Model & Output Configuration

How to pin which model a session uses and shape what the CLI emits — text, JSON, or streamed events — across interactive and headless runs.

## Why it matters

Two independent knobs decide cost and integrability. *Model* config sets which Claude handles the work and which cheaper model does background tasks — the main lever on [[cost-context-optimization|spend]]. *Output* config decides whether the CLI prints prose for a human or structured JSON a script can parse — the difference between a toy `-p` call and a real [[building-headless-agents|headless agent]] whose result you can act on programmatically.

## How it works

Model resolves through the precedence chain; output format is chosen per invocation, mostly for [[one-shot-print-mode-p|print mode]].

| Setting | Where | Effect |
|---|---|---|
| Main model | `--model`, `ANTHROPIC_MODEL`, settings `model` | reasoning engine |
| Background model | `ANTHROPIC_SMALL_FAST_MODEL` | subagent / cheap work |
| Output format | `--output-format text\|json\|stream-json` | shape of `-p` output |
| Input format | `--input-format text\|stream-json` | shape of `-p` input |

- Model precedence high→low: **`--model` flag → `ANTHROPIC_MODEL` → `settings.json` model** (see [[environment-variables]]); switch live with `/model`, check with `/status`.
- Prefer a tier alias (`opus`, `sonnet`, `haiku`) over a dated ID so you don't silently fall behind a retired version.
- `--output-format json` returns one object with the result plus metadata (cost, token usage, session id); `stream-json` emits newline-delimited events as they happen — what you parse in [[programmatic-sessions-streaming]].
- Output format only applies to `-p`/print mode; interactive sessions always render for a human.
- A small/fast background model + a strong main model is the built-in cost/quality split for [[the-task-tool-parallelism|subagents]].

## Example

Headless run that emits machine-readable output for a downstream step:

```bash
claude -p "list TODO comments as JSON" \
  --model sonnet \
  --output-format json | jq '.total_cost_usd, .result'
```

The `json` envelope lets the caller read both the answer (`.result`) and the spend (`.total_cost_usd`); switching to `stream-json` would surface tool calls live instead of one final blob.

## Pitfalls

- **`stream-json` for input needs the matching flag.** Feeding event JSON on stdin without `--input-format stream-json` makes the CLI treat it as a literal prompt.
- **Expecting JSON in interactive mode.** `--output-format json` is a no-op without `-p`; you'll still see rendered text.
- **Hard-coded model ID rots.** A pinned dated string can point at a superseded model — prefer the alias or update deliberately.
- **Parsing prose.** Scripting against `text` output is brittle; use `json`/`stream-json` and read fields, not regex on prose.

## See also

- [[choosing-a-model]]
- [[environment-variables]]
- [[one-shot-print-mode-p]]
