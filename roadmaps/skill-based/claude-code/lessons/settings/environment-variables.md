---
title: Environment Variables
track: claude-code
group: Settings
tags: [claude-code, settings]
prerequisites: [settings-json-hierarchy]
see-also: [settings-json-hierarchy, authentication-api-keys, model-output-configuration]
---

# Environment Variables

Process-level variables that configure Claude Code's auth, model, endpoint, and limits — the layer that wires the CLI into CI, proxies, and Bedrock/Vertex.

## Why it matters

Env vars are how you configure Claude Code where a committed file can't reach: a secret API key in CI, an enterprise proxy, or routing the whole CLI through Amazon Bedrock. They're also the cleanest knob for [[headless-ci-usage]] — set `ANTHROPIC_API_KEY` once in the runner and every `-p` invocation authenticates without interactive login. Knowing the precise names avoids guesswork and "why is it still hitting the public API" surprises.

## How it works

Set them in your shell, CI secrets, or the `env` block of [[settings-json-hierarchy]] (which injects them into the session and into [[built-in-tools-read-edit-bash-etc|Bash]] tool calls). Key variables:

| Variable | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` | API key for direct Anthropic auth |
| `ANTHROPIC_MODEL` | default main model (tier alias or ID) |
| `ANTHROPIC_SMALL_FAST_MODEL` | model for background/subagent work |
| `ANTHROPIC_BASE_URL` | override API endpoint (proxy/gateway) |
| `CLAUDE_CODE_USE_BEDROCK` | route via Amazon Bedrock |
| `CLAUDE_CODE_USE_VERTEX` | route via Google Vertex AI |
| `MAX_THINKING_TOKENS` | cap extended-thinking budget |
| `DISABLE_TELEMETRY` | opt out of usage telemetry |

- Precedence: an explicit `--model` flag beats `ANTHROPIC_MODEL` beats a `settings.json` `model`; env generally overrides the config file but loses to a CLI flag.
- `apiKeyHelper` in settings can shell out to fetch a key dynamically (rotating creds) instead of a static `ANTHROPIC_API_KEY`.
- Bedrock/Vertex flags switch the provider; you then authenticate with that cloud's normal credential chain (e.g. `AWS_*`), not an Anthropic key.
- The `env` block in settings is committed if it's in the project file — so reference secrets, never inline them.

## Example

A CI runner driving headless Claude Code through a self-hosted gateway:

```bash
export ANTHROPIC_BASE_URL="https://llm-gateway.corp.internal"
export ANTHROPIC_API_KEY="$VAULT_CLAUDE_KEY"   # injected secret
export ANTHROPIC_MODEL="sonnet"
export DISABLE_TELEMETRY=1

claude -p "run the linter and summarize failures" --output-format json
```

No interactive login, traffic stays on the corporate gateway, and the model is pinned for reproducibility.

## Pitfalls

- **Committing a key.** `ANTHROPIC_API_KEY` in a project `settings.json` `env` block leaks to git; use CI secrets or `apiKeyHelper`.
- **Stale shell precedence.** An exported `ANTHROPIC_MODEL` silently overrides your `settings.json` model — `/status` shows what's actually active.
- **Bedrock flag without cloud creds.** Setting `CLAUDE_CODE_USE_BEDROCK=1` but missing `AWS_*` credentials fails auth confusingly.
- **Assuming env beats flags.** `--model` on the command line wins over the env var, not the other way around.

## See also

- [[settings-json-hierarchy]]
- [[authentication-api-keys]]
- [[model-output-configuration]]
