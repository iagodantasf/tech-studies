---
title: Getting help (git help, man, -h)
track: git-github
group: Version control basics
tags: [git-github, tooling]
prerequisites: []
see-also: [git-config-user-name-user-email-core-editor, viewing-history-git-log]
---

# Getting help (git help, man, -h)

Git ships its own complete documentation; `-h`, `git help`, and `man` give you a quick synopsis, the full manual, and the same manual via the system pager — so you rarely need to leave the terminal.

## Why it matters

Git has 150+ subcommands and dense flag sets; guessing flags from memory causes data-losing mistakes (e.g. the difference between [[resetting-git-reset-soft-mixed-hard|--soft and --hard]]). Built-in help is offline, version-accurate to *your* installed Git, and authoritative — unlike a stale blog post that may describe a different version's behavior. It also surfaces config keys and exit-code semantics you won't find elsewhere.

## How it works

Three tiers, fastest to fullest:

| Command | Shows | Where |
|---|---|---|
| `git <cmd> -h` | one-screen synopsis + flags | stderr, no pager |
| `git help <cmd>` | full manual page | opens in browser/man |
| `man git-<cmd>` | same manual | system pager (`less`) |
| `git help -a` | list all commands | pager |
| `git help -g` | concept guides (e.g. `gitglossary`) | pager |

`-h` (single dash) prints a terse usage block and exits — ideal mid-task. `git help <cmd>` and `man git-<cmd>` render the identical full page; the only difference is the viewer. Inside the `less` pager, `/word` searches, `n` jumps to the next hit, `q` quits. For settings, `git help config` documents every key referenced in [[git-config-user-name-user-email-core-editor]].

## Example

You forget which flag squashes during a rebase:

```
git rebase -h        → ... -i, --interactive   (instant, no pager)
git help rebase      → full man page; type /squash , n , n , q
git help -g          → lists guides: gittutorial, giteveryday, gitglossary
git help glossary    → defines "detached HEAD", "fast-forward", "refspec"
```

`git <cmd> -h` answers 90% of "what was that flag?" moments without breaking flow.

## Pitfalls

- **`--help` opens a browser** — on desktop installs `git x --help` may launch a web page; use `-h` for a quick in-terminal hit.
- **Reading the wrong version's docs online** — your installed Git may differ from the latest; `man`/`git help` always match `git --version`.
- **`man git` ≠ `man git-commit`** — bare `man git` is the top-level overview; per-command pages are hyphenated.
- **Pager confusion** — output "vanishes" because it's in `less`; press `q` to exit, not Ctrl-C.

## See also

- [[git-config-user-name-user-email-core-editor]]
- [[viewing-history-git-log]]
