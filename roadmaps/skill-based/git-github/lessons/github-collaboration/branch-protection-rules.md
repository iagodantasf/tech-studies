---
title: Branch protection rules
track: git-github
group: GitHub collaboration
tags: [git-github, access-control]
prerequisites: [pull-requests, collaborators-and-teams]
see-also: [reviewing-and-approving-changes, github-actions-and-ci-cd]
---

# Branch protection rules

Server-side policies that gate what can land on a branch — requiring reviews, passing checks, and blocking force-pushes — so `main` stays releasable.

## Why it matters

Without protection, anyone with [[collaborators-and-teams|write access]] can push directly to `main`, force-push over history, or merge an unreviewed [[pull-requests|PR]]. Protection turns team conventions into *enforced* rules the server rejects on violation, which is the backbone of [[branching-strategies-git-flow-github-flow-trunk-based|GitHub Flow]] and trunk-based development. It's also a compliance lever: "every change to production code was reviewed and passed CI" becomes auditable fact, not policy on paper.

## How it works

Rules attach to a branch name or pattern (`main`, `release/*`) via classic branch protection or the newer **rulesets** (which can target tags and apply org-wide).

| Rule | Effect |
|---|---|
| Require pull request before merging | No direct pushes; changes must go through a PR |
| Require N approvals | Merge blocked until N approvals are given |
| Dismiss stale approvals on new commits | New push invalidates prior sign-off |
| Require status checks to pass | Named CI jobs must be green |
| Require branches up to date | Must rebase/merge latest base first |
| Require linear history | Forbids merge commits (squash/rebase only) |
| Include administrators | Rules apply to admins too |

- Status checks are matched by **job name**; a renamed [[github-actions-and-ci-cd|Actions]] job no longer satisfies a required check and silently blocks every merge.
- "Require branches up to date" forces serialized merges — safe but a throughput bottleneck on busy repos; **merge queues** solve this by testing the prospective merge result.

## Example

```
# Require 2 approvals + a CI check, enforced on admins, via gh CLI
$ gh api -X PUT repos/acme/api/branches/main/protection \
  -f required_pull_request_reviews[required_approving_review_count]=2 \
  -f required_status_checks[strict]=true \
  -f required_status_checks[contexts][]=ci/test \
  -f enforce_admins=true \
  -f restrictions=null
```

## Pitfalls

- **"Include administrators" left off** — an admin force-pushes a bad rebase to `main` and erases history the rule was meant to protect.
- **Required check never reports** — if a check is required but the workflow never triggers (path filter, fork), the PR is stuck "Expected — waiting" forever.
- **Stale approvals not dismissed** — a reviewer approves, the author pushes a malicious commit, and it merges on the old green checkmark.
- **Rule patterns don't match** — protecting `main` but not `release/*` leaves release branches wide open; verify the pattern actually covers them.

## See also

- [[reviewing-and-approving-changes]]
- [[collaborators-and-teams]]
