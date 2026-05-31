---
title: Dependabot and security alerts
track: git-github
group: GitHub advanced
tags: [git-github, security]
prerequisites: [pull-requests, releases-and-packages]
see-also: [personal-access-tokens-and-ssh-keys, github-actions-and-ci-cd]
---

# Dependabot and security alerts

Dependabot is GitHub's automated dependency keeper: it scans your manifests against the advisory database, **alerts** on vulnerable dependencies, and opens **PRs** that bump them.

## Why it matters

Transitive dependencies are where most modern CVEs land (Log4Shell, event-stream); manually auditing them across repos doesn't scale. Dependabot watches `package-lock.json`, `go.sum`, etc., flags known-vulnerable versions, and proposes the fix as a reviewable [[pull-requests|PR]] — turning patching from a research project into a merge. It is free on public and private repos.

## How it works

Three cooperating features read your lockfiles and the GitHub Advisory Database, then file alerts or PRs.

| Feature | Trigger | Output |
|---|---|---|
| Dependabot alerts | new advisory matches a dep | alert in Security tab |
| Security updates | an alert is open | PR bumping just that dep |
| Version updates | `dependabot.yml` schedule | PRs for routine upgrades |
| Secret scanning | committed credential | alert (+ optional push protection) |

- **Alerts vs updates** — *alerts* tell you a dependency is vulnerable; *security updates* auto-open the minimal PR to fix it; *version updates* (opt-in via `.github/dependabot.yml`) keep deps fresh on a cadence regardless of CVEs.
- **Severity** — advisories carry CVSS scores; you can route only `high`/`critical` to reduce noise, and `dependabot-core` honors your version constraints.
- **CI gate** — its PRs run your [[github-actions-and-ci-cd|Actions]] suite, so a bump that breaks tests is caught before merge; `dependabot/...` branches are first-class.
- **Auto-merge** — combine branch rules + `gh pr merge --auto` to land green patch bumps untouched.

## Example

`.github/dependabot.yml` — weekly npm upgrades, grouped:
```yaml
version: 2
updates:
  - package-ecosystem: npm
    directory: "/"
    schedule: { interval: weekly }
    open-pull-requests-limit: 5
    groups:
      minor-and-patch:
        update-types: [minor, patch]
```

## Pitfalls

- **PR fatigue** → ignored alerts — daily ungrouped bumps train the team to dismiss them; use `groups`, limits, and severity filters so real CVEs stand out.
- **Auto-merging majors** — a `major` bump can be breaking; restrict auto-merge to `patch`/`minor` and require green CI.
- **Lockfile only fixes one tree** — bumping `package-lock.json` doesn't help a sibling service; alerts are per-manifest, per-repo.
- **Treating secret-scanning alerts as "rotate later"** — a leaked [[personal-access-tokens-and-ssh-keys|token]] is compromised the moment it's pushed; revoke immediately, don't just remove the line.

## See also

- [[personal-access-tokens-and-ssh-keys]]
- [[github-actions-and-ci-cd]]
