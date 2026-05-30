---
title: Code Review
roadmap: code-review
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, code-review]
---

# Code Review

> roadmap.sh: https://roadmap.sh/best-practices/code-review

Track for the **Code Review** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] Why code review matters
- [ ] Goals: quality, knowledge sharing, consistency
- [ ] Code review is not gatekeeping
- [ ] Shared ownership of the codebase
- [ ] Reviews catch defects early
- [ ] Reviews are a mentoring opportunity

### Before the Review
- [ ] Keep pull requests small
- [ ] One logical change per PR
- [ ] Write a clear PR description
- [ ] Explain the why, not just the what
- [ ] Link the related issue or ticket
- [ ] Self-review before requesting others
- [ ] Ensure CI passes first
- [ ] Add tests with the change
- [ ] Include screenshots for UI changes
- [ ] Flag breaking changes explicitly

### As an Author
- [ ] Respond to every comment
- [ ] Do not take feedback personally
- [ ] Explain your reasoning when you disagree
- [ ] Push back respectfully when warranted
- [ ] Keep the discussion in the open
- [ ] Make follow-up commits easy to review
- [ ] Thank your reviewers

### As a Reviewer — Mindset
- [ ] Review promptly
- [ ] Be kind and respectful
- [ ] Critique the code, not the person
- [ ] Ask questions instead of making demands
- [ ] Offer suggestions, not just criticism
- [ ] Explain the reasoning behind feedback
- [ ] Distinguish blocking from non-blocking comments
- [ ] Use nits to mark minor preferences
- [ ] Approve when it is good enough, not perfect
- [ ] Praise good work

### What to Look For
- [ ] Correctness and logic
- [ ] Edge cases and error handling
- [ ] Readability and clarity
- [ ] Naming
- [ ] Test coverage and quality
- [ ] Security vulnerabilities
- [ ] Performance implications
- [ ] Maintainability
- [ ] Adherence to conventions and style
- [ ] Proper documentation
- [ ] No leftover debug or dead code
- [ ] No hardcoded secrets
- [ ] Backward compatibility
- [ ] Accessibility (where relevant)

### Communication
- [ ] Be specific and actionable
- [ ] Provide context and examples
- [ ] Use a constructive tone
- [ ] Avoid sarcasm
- [ ] Prefer written async review
- [ ] Move long debates to a call or pairing
- [ ] Assume good intent

### Process & Practices
- [ ] Define clear review guidelines
- [ ] Use a pull request template
- [ ] Use a review checklist
- [ ] Automate linting and formatting
- [ ] Automate tests in CI
- [ ] Require approvals before merge
- [ ] Use CODEOWNERS for routing
- [ ] Pair programming as live review
- [ ] Track review turnaround time
- [ ] Avoid rubber-stamp approvals

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Draft a code-review guideline and PR-template for a real repo, encoding blocking vs nit conventions, and open a PR proposing it.
- Set up CODEOWNERS plus required CI checks (lint, format, tests) so reviews focus on logic instead of style.
- Audit a month of merged PRs and write up patterns — PR size, turnaround time, common comment categories — with concrete improvements.
