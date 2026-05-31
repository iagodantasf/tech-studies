---
title: Personal access tokens and SSH keys
track: git-github
group: GitHub advanced
tags: [git-github, authentication]
prerequisites: [https-vs-ssh-authentication]
see-also: [github-cli-gh, dependabot-and-security-alerts]
---

# Personal access tokens and SSH keys

The two credential types you register with GitHub: **personal access tokens (PATs)** authenticate HTTPS/API calls, while **SSH keys** authenticate the SSH transport — both prove *you* are acting, not your password.

## Why it matters

GitHub removed password auth for Git in **August 2021**, so one of these is mandatory to push. Tokens also gate the API and [[github-cli-gh|gh]]; leaked ones are a top breach vector, which is why scoping and expiry matter. Picking the right credential per context (laptop, CI, a server pulling one repo) is core operational hygiene tied to [[https-vs-ssh-authentication|HTTPS vs SSH]].

## How it works

A PAT is a bearer string sent as the HTTPS password; an SSH key is an asymmetric pair where the public half is registered and the private half signs a challenge (see [[cryptography-basics]]).

| Credential | Best for | Scope model | Expiry |
|---|---|---|---|
| Fine-grained PAT | API, single-repo CI | per-repo + per-permission | required, ≤ 1 year |
| Classic PAT | legacy/broad scopes | coarse `repo`, `workflow` | optional (avoid "never") |
| SSH key (user) | day-to-day push/pull | full account access | none (rotate manually) |
| Deploy key | one server ↔ one repo | that repo, read or write | none |

- **Fine-grained PATs** (GA 2023) scope to chosen repos and minimal permissions and *must* expire — strongly preferred over classic. A read-only single-repo token limits blast radius if leaked.
- **`ed25519` over `rsa`** — `ssh-keygen -t ed25519` makes a smaller, faster, modern key; 2048-bit RSA is the dated fallback.
- **Deploy keys** bind one key to one repo (great for a CI box) instead of granting a human's whole account.
- **Secret scanning** — GitHub auto-detects committed tokens and can trigger push protection; partners may auto-revoke. Store secrets in a manager, never in code.

## Example

```
# Fine-grained PAT, used as the HTTPS password
$ git clone https://github.com/acme/api.git
Username: iagodantasf
Password: github_pat_11ABC...        # the token, not your account password

# SSH key (preferred for daily use)
$ ssh-keygen -t ed25519 -C "iago@acme.com"   # → ~/.ssh/id_ed25519[.pub]
$ gh ssh-key add ~/.ssh/id_ed25519.pub        # register the public half
```

## Pitfalls

- **`never`-expiring classic PAT with `repo` scope** — one leaked string = permanent full account access; this is the worst common setup. Use fine-grained + expiry.
- **Committing a token** — secret scanning flags it, but assume it's compromised the instant it's pushed; revoke and rotate, don't just delete the commit.
- **Pasting your account password at the HTTPS prompt** — fails since 2021; supply a PAT instead.
- **Private key shared across machines** — copying `id_ed25519` around multiplies exposure; generate one key per device and add each.

## See also

- [[github-cli-gh]]
- [[dependabot-and-security-alerts]]
