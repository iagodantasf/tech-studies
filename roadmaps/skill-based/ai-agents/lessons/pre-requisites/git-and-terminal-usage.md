---
title: Git and Terminal Usage
track: ai-agents
group: Pre-requisites
tags: [ai-agents, tooling]
prerequisites: []
see-also: [code-execution-repl, operating-systems]
---

# Git and Terminal Usage

Fluency with the shell and version control — running commands, piping output, branching, diffing — which you need both to build agents and because the terminal is itself one of the most powerful agent tools.

## Why it matters

You develop and deploy agents from a terminal, and version control is how you track prompt and config changes that quietly change behavior. More directly: a coding or DevOps agent often acts *through* a shell — running tests, applying patches, committing — so understanding exit codes, stdout vs stderr, and `git` semantics is what lets you give an agent that power safely (see [[code-execution-repl]]).

## How it works

The shell runs a command, then exposes its result three ways your code (or an agent) must read:

| Channel | Carries | An agent should |
|---|---|---|
| stdout | normal output | parse as the result |
| stderr | errors, logs | surface to the model |
| exit code | 0 = ok, non-0 = fail | branch the loop on it |

**Composition** is the superpower: pipes (`|`) feed one command's stdout into the next, and `&&` chains on success. An agent that shells out should capture all three channels and feed the exit code back as an [[observation-reflection|observation]].

**Git** tracks snapshots (commits) on branches:

- `status` / `diff` — what changed, the agent's primary read.
- `add` / `commit` — stage and snapshot a unit of work.
- `branch` / `checkout` — isolate experiments; agents should work on a throwaway branch, never `main`.
- `log` — history, useful for letting an agent see prior context.

## Example

```bash
# What a coding agent effectively runs per step
git checkout -b agent/fix-123      # isolate work; never touch main
pytest -q                          # exit 0? proceed. non-0? read stderr, retry
echo $?                            # 1  ← agent branches its loop on this
git add -A && git commit -m "fix"  # snapshot only after tests pass
```

The agent reads the exit code (`$?`) to decide its next action — exactly the observe-then-act cycle of the [[agent-loop]].

## Pitfalls

- **Letting an agent commit straight to `main`** — always sandbox on a branch; an autonomous loop can rewrite history or push a broken state.
- **Ignoring the exit code** — a command can print a friendly message *and* exit non-zero; trust the code, not the text.
- **Running unsandboxed shell from a prompt** — model-generated commands can be destructive (`rm -rf`) or injected; gate them behind allow-lists and a sandbox (see [[safety-red-team-testing]]).

## See also

- [[code-execution-repl]]
- [[operating-systems]]
