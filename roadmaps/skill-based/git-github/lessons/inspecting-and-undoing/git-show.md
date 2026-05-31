---
title: git show
track: git-github
group: Inspecting and undoing
tags: [git-github, inspecting]
prerequisites: [viewing-history-git-log, viewing-changes-git-diff]
see-also: [git-blame, lightweight-vs-annotated-tags]
---

# git show

`git show <object>` prints the metadata *and* the diff of any single Git object — most often one commit — combining `git log -1` and `git diff` for that object.

## Why it matters

When a bug lands or a line looks wrong, you want to inspect *one* commit in full: its author, message, and exact patch. `git show` is the fastest way to answer "what did this commit actually change?", and because it accepts any object type, it also dereferences tags, dumps a single file at a revision, or prints a raw blob — useful in review, bisect, and incident forensics.

## How it works

`git show` resolves the argument, picks a formatter for that object type, and prints it. With no argument it defaults to `HEAD`.

| Object | What `git show` prints |
|---|---|
| Commit | Header + log message + diff vs first parent |
| Annotated tag | Tag message, then the commit it points to |
| Tree | List of entries (mode, type, name) |
| Blob | Raw file contents, no diff |

- **A specific file inside a commit** — `git show <sha>:path/to/file` prints that file *as of* that commit; `git show HEAD~2:config.yml` is a one-liner to read an old version without checking it out.
- **Merge commits** — by default Git shows a *combined* diff (only hunks that conflicted); `git show -m <merge>` splits it into one diff per parent, and `--first-parent` shows it against the mainline only.
- **Formatting** — `--stat` for a summary, `--name-only` for just paths, `-p` to force the patch. `git show <sha> -- path` limits the diff to one path.
- Revision syntax works: `HEAD@{yesterday}`, `main~3`, `v1.2^{commit}`.

## Example

```
$ git show abc123 --stat
commit abc123...  Author: Dev <d@x>  Date: ...
    Fix off-by-one in pager
 src/pager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

$ git show v2.0:CHANGELOG.md | head   # read a file at a tag, no checkout
```

## Pitfalls

- **Merge commits look empty** — the default combined diff hides non-conflicting changes; use `-m` or `--first-parent` to see what a merge really brought in.
- **`sha:file` path is repo-relative** — it is from the repo root, not your `cwd`; a wrong prefix yields "exists on disk, but not in 'sha'".
- **`git show` on a tree/blob has no diff** — newcomers expect a patch and get a file listing or raw bytes instead.
- **Whitespace noise** — like [[viewing-changes-git-diff|diff]], add `-w` to suppress reformat-only churn when reviewing the patch.

## See also

- [[git-blame]]
- [[viewing-history-git-log]]
