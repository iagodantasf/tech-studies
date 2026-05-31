---
title: HTTPS vs SSH authentication
track: git-github
group: Remote repositories
tags: [git-github, authentication]
prerequisites: [what-is-a-remote, cloning-git-clone]
see-also: [personal-access-tokens-and-ssh-keys, adding-and-managing-remotes-git-remote]
---

# HTTPS vs SSH authentication

The two transports Git uses to reach a hosted [[what-is-a-remote|remote]]: **HTTPS** (URL like `https://github.com/acme/api.git`, authenticated with a token) and **SSH** (`git@github.com:acme/api.git`, authenticated with a key pair).

## Why it matters

The choice decides how you prove identity on every [[fetching-git-fetch|fetch]]/[[pushing-git-push|push]], how it behaves behind corporate firewalls, and how it works in CI. Picking the wrong one is the source of *"Authentication failed"* (HTTPS with no token) and *"Permission denied (publickey)"* (SSH with no key) — two of the most common onboarding blockers.

## How it works

HTTPS rides port 443 and sends a credential per request; SSH opens an authenticated tunnel on port 22 using public-key crypto (see [[cryptography-basics]]). The remote URL prefix selects the transport.

| Aspect | HTTPS | SSH |
|---|---|---|
| URL form | `https://host/org/repo.git` | `git@host:org/repo.git` |
| Port | 443 (firewall-friendly) | 22 (often blocked at work) |
| Credential | token / PAT (passwords removed 2021) | private key in `~/.ssh/` |
| Storage | credential helper / keychain | ssh-agent |
| CI usage | inject token as secret | deploy key |

- **HTTPS** caches the token via a credential helper (`osxkeychain`, `manager`); GitHub removed password auth in **August 2021**, so the "password" is now a PAT.
- **SSH** uses a key pair (`ed25519` preferred over `rsa`); the public key is registered on the host, the private key stays local and may be passphrase-protected via ssh-agent.
- Switch transports anytime with `git remote set-url` — no re-clone needed.

## Example

```
# SSH setup
$ ssh-keygen -t ed25519 -C "iago@acme.com"      # creates ~/.ssh/id_ed25519
$ pbcopy < ~/.ssh/id_ed25519.pub                # paste into GitHub keys
$ ssh -T git@github.com
Hi iagodantasf! You've successfully authenticated...
# Convert an HTTPS clone to SSH
$ git remote set-url origin git@github.com:acme/api.git
```

## Pitfalls

- **HTTPS with your account password** — fails since 2021; generate a [[personal-access-tokens-and-ssh-keys|PAT]] (or use the GitHub CLI / credential manager) instead.
- **`Permission denied (publickey)`** — key not added to ssh-agent or not registered on the host; test with `ssh -T git@github.com`.
- **Wrong-account key** — multiple GitHub accounts on one machine need a `~/.ssh/config` `Host` alias; otherwise the first key wins.
- **SSH port blocked** — corporate networks block 22; use HTTPS, or SSH-over-443 via `ssh.github.com`.

## See also

- [[personal-access-tokens-and-ssh-keys]]
- [[adding-and-managing-remotes-git-remote]]
