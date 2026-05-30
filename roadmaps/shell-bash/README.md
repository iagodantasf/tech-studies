---
title: Shell / Bash
roadmap: shell-bash
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, bash, shell]
---

# Shell / Bash

> roadmap.sh: https://roadmap.sh/shell-bash

Track for the **Shell / Bash** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Shell fundamentals
- [ ] What is a shell?
- [ ] Shell vs terminal vs console
- [ ] Bash vs sh vs zsh vs fish
- [ ] Interactive vs non-interactive shells
- [ ] Login vs non-login shells
- [ ] The shebang line (#!/bin/bash)
- [ ] Running a script (chmod +x, ./script, bash script)
- [ ] Shell startup files (.bashrc, .bash_profile, .profile)

### Basic commands
- [ ] echo and printf
- [ ] cd, pwd, ls
- [ ] cp, mv, rm, mkdir, touch
- [ ] cat, less, head, tail
- [ ] man and help
- [ ] history and command recall
- [ ] alias and unalias
- [ ] type, which, command

### Variables and expansion
- [ ] Defining and using variables
- [ ] Quoting (single, double, backslash)
- [ ] Command substitution $(...)
- [ ] Arithmetic expansion $((...))
- [ ] Parameter expansion and defaults
- [ ] Special variables ($?, $$, $!, $0, $#, $@, $*)
- [ ] Environment vs shell variables (export)
- [ ] Brace expansion and tilde expansion

### Input and output
- [ ] Standard input, output, and error
- [ ] Redirection (>, >>, <, 2>, &>)
- [ ] Pipes (|)
- [ ] Here documents and here strings
- [ ] tee
- [ ] /dev/null and /dev/stdin
- [ ] read for user input

### Control flow
- [ ] if / elif / else
- [ ] test and [ ] / [[ ]]
- [ ] case statements
- [ ] for loops
- [ ] while and until loops
- [ ] break and continue
- [ ] Exit codes and return
- [ ] Logical operators (&&, ||, !)

### Functions and scripts
- [ ] Defining functions
- [ ] Function arguments and return values
- [ ] Local vs global variables
- [ ] Positional parameters and shift
- [ ] Parsing options (getopts)
- [ ] Sourcing scripts
- [ ] set options (set -e, -u, -x, -o pipefail)
- [ ] Trap and signal handling

### Text processing
- [ ] grep and regular expressions
- [ ] sed
- [ ] awk
- [ ] cut, paste, sort, uniq
- [ ] tr, wc, fold
- [ ] xargs
- [ ] find with -exec
- [ ] Globbing and wildcards

### Arrays and data
- [ ] Indexed arrays
- [ ] Associative arrays
- [ ] Iterating over arrays
- [ ] String manipulation (substrings, replace, length)
- [ ] Reading files line by line
- [ ] IFS (Internal Field Separator)

### Job control and processes
- [ ] Foreground and background (&)
- [ ] jobs, fg, bg
- [ ] kill and signals
- [ ] nohup and disown
- [ ] Subshells and command grouping
- [ ] wait and process synchronization
- [ ] Command exit status and pipelines

### Best practices and debugging
- [ ] Quoting and word-splitting pitfalls
- [ ] ShellCheck for static analysis
- [ ] Debugging with set -x and bash -x
- [ ] Writing portable POSIX scripts
- [ ] Error handling patterns
- [ ] Idempotency and safety
- [ ] Style guides and readability

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Write a robust backup script with `set -euo pipefail`, option parsing via `getopts`, logging, and a `trap` that cleans up temp files on exit.
- Build a CLI tool that parses a CSV with `awk`/`cut` and prints a formatted summary report, handling missing fields and edge cases.
- Create a dotfiles bootstrap script that detects the OS, symlinks config files, and installs packages idempotently so it is safe to re-run.
