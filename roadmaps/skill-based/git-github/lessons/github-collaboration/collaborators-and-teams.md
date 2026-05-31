---
title: Collaborators and teams
track: git-github
group: GitHub collaboration
tags: [git-github, access-control]
prerequisites: [creating-a-github-account-and-repository]
see-also: [branch-protection-rules, pull-requests]
---

# Collaborators and teams

How GitHub grants push and admin access to a repository — directly as outside collaborators, or at scale through organization teams with inherited roles.

## Why it matters

Access is the blast radius of your repo: a contributor with `admin` can delete branches, rewrite history, and disable [[branch-protection-rules|protection rules]]. On a personal repo you add people one by one, which doesn't scale; organizations exist precisely so 200 engineers don't each get hand-added to 80 repos. Getting roles right is least-privilege security, not bureaucracy — most breaches via stolen tokens escalate through over-broad write access.

## How it works

A **collaborator** is a single account granted a role on one repo. A **team** is an org-level group; granting a team access cascades to every member, and teams can nest (a child team inherits the parent's repo access).

| Role | Read code | Push | Manage issues/PRs | Manage settings/access |
|---|---|---|---|---|
| Read | yes | no | no | no |
| Triage | yes | no | yes (label, close) | no |
| Write | yes | yes | yes | no |
| Maintain | yes | yes | yes | partial (no destructive) |
| Admin | yes | yes | yes | yes |

- Effective permission is the **maximum** across all sources: direct grant, every team, and base org permission — never the minimum.
- Nested teams inherit downward: `@acme/backend` under `@acme/eng` gets everything `@acme/eng` has.
- `@team` mentions in a [[pull-requests|PR]] can auto-request review via [[reviewing-and-approving-changes|CODEOWNERS]].

## Example

```
# Add an outside collaborator with push access via gh CLI
$ gh api -X PUT repos/acme/api/collaborators/jdoe -f permission=push

# A user in two teams — Write wins:
#   @acme/eng    -> Read
#   @acme/payments -> Write   ==> effective: Write
```

## Pitfalls

- **Maximum-permission surprise** — demoting one team won't lower access if another team or a direct grant still gives more; audit all sources.
- **Outside collaborators bypass org policy** — they aren't governed by team structure or SSO and are easy to forget; review them periodically.
- **Admin handed out for convenience** — only Admin can change protection rules, so a careless Admin can disable the very guardrails the team relies on.
- **Deleting a team** silently revokes its repo access; orphaned members lose access with no per-repo audit trail.

## See also

- [[branch-protection-rules]]
- [[reviewing-and-approving-changes]]
