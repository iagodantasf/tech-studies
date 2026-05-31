---
title: Creating and pushing tags
track: git-github
group: Stashing and tags
tags: [git-github, tagging]
prerequisites: [lightweight-vs-annotated-tags, pushing-git-push]
see-also: [semantic-versioning, releases-and-packages]
---

# Creating and pushing tags

How to create tags (now or retroactively), publish them to a remote, and delete them — the mechanics around `git tag` and `git push --tags`.

## Why it matters

A tag is worthless to your team until it leaves your laptop: `git push` does **not** send tags by default, so a freshly cut `v2.0.0` can sit local while CI and teammates see nothing. Pushed tags are also what trigger [[github-actions-and-ci-cd|tag-based CI pipelines]] and back GitHub [[releases-and-packages|Releases]], making correct publishing the difference between a real release and a private bookmark.

## How it works

Create on `HEAD`, or retroactively on any commit by appending its SHA: `git tag -a v1.2.0 9fceb02`. Pushing is explicit and selective.

| Action | Command |
|---|---|
| List / filter | `git tag -l "v1.*"` |
| Tag a past commit | `git tag -a v1.2.0 <sha> -m "..."` |
| Push one tag | `git push origin v1.2.0` |
| Push all missing tags | `git push --tags` |
| Push commits + their tags | `git push --follow-tags` |
| Delete locally | `git tag -d v1.2.0` |
| Delete on remote | `git push origin --delete v1.2.0` |

`--follow-tags` is the sane default for releases: it pushes commits plus the *annotated* tags reachable from them, never stray local lightweight ones. `git fetch` grabs tags on reachable commits automatically; `--tags` forces all.

## Example

```
$ git tag -a v1.2.0 -m "Release 1.2.0"
$ git push origin v1.2.0
 * [new tag]         v1.2.0 -> v1.2.0

# Oops, tagged the wrong commit:
$ git tag -d v1.2.0                       # delete local
$ git push origin --delete v1.2.0         # delete remote
$ git tag -a v1.2.0 1a2b3c4 -m "Release 1.2.0"   # retag right commit
$ git push origin v1.2.0
```

## Pitfalls

- **Plain `git push` omits tags** — the single most common surprise; use `--follow-tags` or push the tag by name.
- **Moving a published tag silently fails for others** — `git push -f` updates the remote, but peers keep the old tag unless they fetch with `--force`; never re-point released tags.
- **Deleting is two-step** — local `-d` plus remote `--delete`; people forget the remote and the tag reappears on next fetch.
- **`refs/tags` and `refs/heads` can collide** — a tag named like a branch (`release`) makes `git checkout release` ambiguous and warns.

## See also

- [[lightweight-vs-annotated-tags]]
- [[semantic-versioning]]
