---
title: Git and GitHub
track: git-github
category: Skill-based
tags: [roadmap, git]
---

# Git and GitHub

> roadmap.sh: https://roadmap.sh/git-github

Suggested path through the **Git and GitHub** nodes. Each node links to its lesson when written.

## Nodes

### Version control basics
- [[what-is-version-control]]
- [[centralized-vs-distributed-vcs]]
- [[what-is-git]]
- [[git-vs-github]]
- [[installing-and-configuring-git]]
- [[git-config-user-name-user-email-core-editor]]
- [[getting-help-git-help-man-h]]

### Git fundamentals
- [[initializing-a-repository-git-init]]
- [[the-working-directory-staging-area-and-repository]]
- [[tracking-changes-git-add]]
- [[committing-git-commit]]
- [[checking-status-git-status]]
- [[viewing-history-git-log]]
- [[viewing-changes-git-diff]]
- [[ignoring-files-gitignore]]
- [[removing-and-moving-files-git-rm-git-mv]]

### Branching and merging
- [[what-is-a-branch]]
- [[creating-and-switching-branches-git-branch-git-switch-git-checkout]]
- [[merging-branches-git-merge]]
- [[fast-forward-vs-three-way-merge]]
- [[resolving-merge-conflicts]]
- [[deleting-branches]]
- [[branching-strategies-git-flow-github-flow-trunk-based]]

### Remote repositories
- [[what-is-a-remote]]
- [[cloning-git-clone]]
- [[adding-and-managing-remotes-git-remote]]
- [[fetching-git-fetch]]
- [[pulling-git-pull]]
- [[pushing-git-push]]
- [[tracking-branches-and-upstream]]
- [[https-vs-ssh-authentication]]

### Rewriting history
- [[amending-commits-git-commit-amend]]
- [[rebasing-git-rebase]]
- [[interactive-rebase-squash-fixup-reword-drop]]
- [[cherry-picking-git-cherry-pick]]
- [[reverting-commits-git-revert]]
- [[resetting-git-reset-soft-mixed-hard]]
- [[reflog-and-recovery-git-reflog]]

### Stashing and tags
- [[stashing-changes-git-stash]]
- [[applying-and-dropping-stashes]]
- [[lightweight-vs-annotated-tags]]
- [[creating-and-pushing-tags]]
- [[semantic-versioning]]

### Inspecting and undoing
- [[git-show]]
- [[git-blame]]
- [[git-bisect]]
- [[restoring-files-git-restore-git-checkout]]
- [[cleaning-untracked-files-git-clean]]

### GitHub basics
- [[creating-a-github-account-and-repository]]
- [[readme-license-and-repository-structure]]
- [[forking-a-repository]]
- [[cloning-vs-forking]]
- [[github-issues]]
- [[pull-requests]]
- [[code-review-and-comments]]
- [[merging-prs-merge-squash-rebase]]

### GitHub collaboration
- [[collaborators-and-teams]]
- [[branch-protection-rules]]
- [[reviewing-and-approving-changes]]
- [[discussions]]
- [[projects-and-milestones]]
- [[labels-and-assignees]]
- [[notifications-and-watching]]

### GitHub advanced
- [[github-actions-and-ci-cd]]
- [[github-pages]]
- [[github-cli-gh]]
- [[personal-access-tokens-and-ssh-keys]]
- [[releases-and-packages]]
- [[dependabot-and-security-alerts]]
- [[gists]]
- [[submodules-and-monorepos]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- Take a messy feature branch with many WIP commits and clean it up with an interactive rebase (squash, reword, reorder) before opening a PR.
- Build a small project and wire up a GitHub Actions workflow that runs linting and tests on every pull request, with branch protection requiring it to pass.
- Recover "lost" work after a bad `git reset --hard` using `git reflog`, and document the exact steps as a runbook.
