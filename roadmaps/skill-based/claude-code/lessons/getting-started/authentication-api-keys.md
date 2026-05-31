---
title: Authentication & API Keys
track: claude-code
group: Getting started
tags: [claude-code, auth]
prerequisites: [installation-setup]
see-also: [pricing-token-usage, environment-variables, managed-enterprise-policy-settings]
---

# Authentication & API Keys

Authentication tells Claude Code *whose* account to bill and which provider to call — a Claude subscription, an Anthropic API key, or a cloud provider like Bedrock or Vertex.

## Why it matters

Auth determines both your bill and your data path. A Pro/Max **subscription** login bundles Claude Code into a flat monthly price; an **API key** bills per token (see [[pricing-token-usage]]) and suits CI and headless jobs where no human can complete a browser login. Enterprises often must route through their own cloud (Bedrock/Vertex) for compliance, so Claude Code supports all three rather than locking you to one.

## How it works

| Method | How you set it | Best for |
|---|---|---|
| Subscription (Pro/Max) | `claude` -> browser OAuth login | individual interactive use |
| Anthropic API key | `ANTHROPIC_API_KEY` env var | CI, scripts, headless |
| Amazon Bedrock | `CLAUDE_CODE_USE_BEDROCK=1` + AWS creds | AWS-hosted orgs |
| Google Vertex AI | `CLAUDE_CODE_USE_VERTEX=1` + GCP creds | GCP-hosted orgs |

- `claude` with no key launches the **OAuth flow**: it opens a browser, you log in to your Claude account, and a token is cached under `~/.claude/`.
- An exported `ANTHROPIC_API_KEY` is picked up automatically and skips the browser — the standard pattern for [[headless-ci-usage|CI]].
- `/login` and `/logout` switch accounts mid-tool; `/status` shows the active auth and model.
- Precedence and provider switches are driven by [[environment-variables]]; admins can pin or forbid methods via [[managed-enterprise-policy-settings]].

## Example

Local dev uses the subscription; CI uses a key injected as a secret:

```bash
# Local: one-time interactive login, token cached
claude            # browser opens, log in once

# CI (GitHub Actions): no browser available
export ANTHROPIC_API_KEY="${{ secrets.ANTHROPIC_API_KEY }}"
claude -p "run the linter and summarize failures"
```

Same binary, two auth paths — the key lets the headless run skip OAuth entirely.

## Pitfalls

- **Committing the key.** `ANTHROPIC_API_KEY` is a billable secret; never bake it into a Dockerfile or commit a `.env` — use the CI secret store.
- **Assuming subscription auth works in CI.** OAuth needs a browser; non-interactive runners must use an API key (or Bedrock/Vertex creds).
- **Mixing billing models silently.** With both a subscription login *and* an exported key present, requests may bill the key per token — check `/status` if costs surprise you.
- **Provider flags without creds.** Setting `CLAUDE_CODE_USE_BEDROCK=1` but lacking valid AWS credentials fails at first request, not at launch.

## See also

- [[pricing-token-usage]]
- [[environment-variables]]
- [[managed-enterprise-policy-settings]]
