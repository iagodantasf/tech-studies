---
title: Gists
track: git-github
group: GitHub advanced
tags: [git-github, snippets]
prerequisites: [what-is-git, creating-a-github-account-and-repository]
see-also: [github-cli-gh, readme-license-and-repository-structure]
---

# Gists

A gist is a lightweight, single-purpose Git repository for sharing snippets, notes, or small files — each gist is a full repo you can clone, fork, and commit to.

## Why it matters

When you want to share a config, a script, or a log without spinning up a whole project, a gist is the right granularity: it has a stable URL, syntax highlighting, revision history, and embeds. It's the canonical way to paste runnable code into issues, blogs, or chat — and because it's a real repo, the history is preserved, unlike a throwaway pastebin.

## How it works

Every gist is a Git repo under `gist.github.com/<id>`; you interact via the web, the [[github-cli-gh|gh]] CLI, or by cloning it like any remote.

| Aspect | Public gist | Secret gist |
|---|---|---|
| Listed on profile | yes | no |
| Discoverable / searchable | yes | no (URL only) |
| URL guessable | n/a | unguessable id |
| Truly private | no | **no** — anyone with the link sees it |

- **Public vs secret** — "secret" only means *unlisted*; the URL is a long unguessable id but is fully readable by anyone who has it. It is **not** access-controlled. Never put credentials in a gist.
- **It's a repo** — `git clone https://gist.github.com/<id>.git`, commit, push; the web "Revisions" tab is just the commit log. Multiple files per gist are supported.
- **Embedding** — each gist offers a `<script src=".../<id>.js">` embed that renders highlighted code on external pages.
- **CLI** — `gh gist create file.py`, `gh gist list`, `gh gist edit <id>` script the whole lifecycle.

## Example

```
$ gh gist create deploy.sh --desc "one-off deploy helper"
https://gist.github.com/iagodantasf/8f3c...        # secret by default
$ gh gist create notes.md --public                 # listed on profile

# A gist is a clonable repo:
$ git clone https://gist.github.com/8f3c....git
$ cd 8f3c... && git log --oneline                  # full revision history
```

## Pitfalls

- **"Secret" ≠ private** — pasting an API key or `.env` into a secret gist exposes it to anyone with the link, and search engines may crawl shared URLs. Use a private repo or secret manager instead.
- **Gist sprawl** — old secret gists are invisible on your profile but still live; leaked credentials sit there forgotten. Audit and delete periodically.
- **No issues or PRs** — gists support comments and forks but not issues, releases, or branch protection; outgrow one and migrate to a [[creating-a-github-account-and-repository|real repo]].
- **Forking loses linkage** — a forked gist is an independent copy; there's no upstream-tracking UI like a repo fork.

## See also

- [[github-cli-gh]]
- [[readme-license-and-repository-structure]]
