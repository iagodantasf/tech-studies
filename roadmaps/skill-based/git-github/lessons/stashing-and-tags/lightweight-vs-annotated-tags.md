---
title: Lightweight vs annotated tags
track: git-github
group: Stashing and tags
tags: [git-github, tagging]
prerequisites: [committing-git-commit, viewing-history-git-log]
see-also: [creating-and-pushing-tags, semantic-versioning]
---

# Lightweight vs annotated tags

The two kinds of Git tag: a lightweight tag is a bare named pointer to a commit, while an annotated tag is a full tag *object* carrying its own author, date, message, and optional signature.

## Why it matters

Tags mark release points — `v1.4.0`, `2024-q3` — and the choice of kind has real consequences. Annotated tags record *who* tagged and *when*, can be GPG-signed for supply-chain trust, and are what `git describe` and most release tooling expect. Reaching for a lightweight tag on a public release loses that provenance and can make `git describe` behave unexpectedly.

## How it works

A **lightweight** tag is just an entry in `refs/tags/<name>` pointing straight at a commit — no extra object, no metadata. An **annotated** tag creates a separate object in the database that *holds* the metadata and points to the commit; the ref points to that tag object.

| | Lightweight | Annotated |
|---|---|---|
| Creates an object | No (ref only) | Yes (tag object) |
| Tagger + date | No | Yes |
| Message | No | Yes (required) |
| GPG signable | No | Yes (`-s`) |
| Command | `git tag v1.0` | `git tag -a v1.0 -m "..."` |
| `git describe` default | skipped | matched |

By default `git describe` walks only annotated tags; you must pass `--tags` to consider lightweight ones. Inspect either with [[git-show|git show v1.0]] — for annotated tags it prints the tagger header before the commit.

## Example

```
$ git tag tmp-test                       # lightweight: bare pointer
$ git cat-file -t tmp-test
commit

$ git tag -a v1.0.0 -m "First GA release"   # annotated: real object
$ git cat-file -t v1.0.0
tag
$ git show v1.0.0 | head -3
tag v1.0.0
Tagger: Ada <ada@example.com>
Date:   Fri May 30 2026 ...
```

## Pitfalls

- **Lightweight tags on releases lose provenance** — no tagger, no date, no signature; auditors and SBOM tools can't verify them.
- **`git describe` silently skips them** — `v1.0` made lightweight won't show up in `describe` output unless `--tags` is set, breaking version strings in builds.
- **Tags are not branches** — a tag never moves with new commits; checking one out lands you in [[creating-and-switching-branches-git-branch-git-switch-git-checkout|detached HEAD]].
- **Re-pointing a tag needs `-f`** — and force-moving a published tag is hostile to anyone who already fetched it.

## See also

- [[creating-and-pushing-tags]]
- [[semantic-versioning]]
