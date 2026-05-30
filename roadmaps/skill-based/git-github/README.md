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
- What is version control?
- Centralized vs distributed VCS
- What is Git?
- Git vs GitHub
- Installing and configuring Git
- git config (user.name, user.email, core.editor)
- Getting help (git help, man, -h)

### Git fundamentals
- Initializing a repository (git init)
- The working directory, staging area, and repository
- Tracking changes (git add)
- Committing (git commit)
- Checking status (git status)
- Viewing history (git log)
- Viewing changes (git diff)
- Ignoring files (.gitignore)
- Removing and moving files (git rm, git mv)

### Branching and merging
- What is a branch?
- Creating and switching branches (git branch, git switch, git checkout)
- Merging branches (git merge)
- Fast-forward vs three-way merge
- Resolving merge conflicts
- Deleting branches
- Branching strategies (Git Flow, GitHub Flow, trunk-based)

### Remote repositories
- What is a remote?
- Cloning (git clone)
- Adding and managing remotes (git remote)
- Fetching (git fetch)
- Pulling (git pull)
- Pushing (git push)
- Tracking branches and upstream
- HTTPS vs SSH authentication

### Rewriting history
- Amending commits (git commit --amend)
- Rebasing (git rebase)
- Interactive rebase (squash, fixup, reword, drop)
- Cherry-picking (git cherry-pick)
- Reverting commits (git revert)
- Resetting (git reset --soft / --mixed / --hard)
- Reflog and recovery (git reflog)

### Stashing and tags
- Stashing changes (git stash)
- Applying and dropping stashes
- Lightweight vs annotated tags
- Creating and pushing tags
- Semantic versioning

### Inspecting and undoing
- git show
- git blame
- git bisect
- Restoring files (git restore, git checkout --)
- Cleaning untracked files (git clean)

### GitHub basics
- Creating a GitHub account and repository
- README, LICENSE, and repository structure
- Forking a repository
- Cloning vs forking
- GitHub Issues
- Pull Requests
- Code review and comments
- Merging PRs (merge, squash, rebase)

### GitHub collaboration
- Collaborators and teams
- Branch protection rules
- Reviewing and approving changes
- Discussions
- Projects and milestones
- Labels and assignees
- Notifications and watching

### GitHub advanced
- GitHub Actions and CI/CD
- GitHub Pages
- GitHub CLI (gh)
- Personal access tokens and SSH keys
- Releases and packages
- Dependabot and security alerts
- Gists
- Submodules and monorepos

## Resources
See [resources.md](./resources.md).

## Project ideas
- Take a messy feature branch with many WIP commits and clean it up with an interactive rebase (squash, reword, reorder) before opening a PR.
- Build a small project and wire up a GitHub Actions workflow that runs linting and tests on every pull request, with branch protection requiring it to pass.
- Recover "lost" work after a bad `git reset --hard` using `git reflog`, and document the exact steps as a runbook.
