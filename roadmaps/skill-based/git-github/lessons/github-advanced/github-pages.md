---
title: GitHub Pages
track: git-github
group: GitHub advanced
tags: [git-github, hosting]
prerequisites: [creating-a-github-account-and-repository, github-actions-and-ci-cd]
see-also: [readme-license-and-repository-structure, github-actions-and-ci-cd]
---

# GitHub Pages

GitHub Pages is free static-site hosting served straight from a repository over HTTPS — docs, project sites, blogs, and SPAs, with no server to run.

## Why it matters

Most projects need a public face: API docs, a landing page, a coverage report. Pages gives it for free at a predictable URL with automatic TLS, so you ship a site by pushing files. It is the default home for tool docs (mkdocs/Docusaurus/Quartz output) precisely because it couples to the repo and a [[github-actions-and-ci-cd|build workflow]].

## How it works

A repo's Pages site builds from a chosen **source** (a branch+folder, or a Pages-type Actions workflow) and publishes to a URL keyed by repo type.

| Repo name | URL | Type |
|---|---|---|
| `user.github.io` | `https://user.github.io/` | user/org site (one per account) |
| any other repo | `https://user.github.io/repo/` | project site |
| custom `CNAME` | `https://docs.acme.com/` | apex or subdomain |

- **Two build paths** — *legacy* "deploy from a branch" runs Jekyll on `main`/`gh-pages`; *modern* uses an Actions workflow (`actions/deploy-pages`) that uploads an artifact, which is how non-Jekyll generators deploy.
- **Limits (soft)** — published site ≤ **1 GB**, ~**100 GB/month** bandwidth, ~**10 builds/hour**. It is for static content only — no server-side code, no databases.
- **`.nojekyll`** — drop this file at the site root to skip Jekyll; otherwise files/dirs starting with `_` are silently ignored.
- **Custom domain** — a `CNAME` file plus a DNS `CNAME` (or apex `A`/`ALIAS`) record; tick "Enforce HTTPS" once the cert provisions.

## Example

Deploy a built `dist/` via Actions:
```yaml
permissions: { pages: write, id-token: write }
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run build      # emits ./dist
      - uses: actions/upload-pages-artifact@v3
        with: { path: dist }
      - uses: actions/deploy-pages@v4
```

## Pitfalls

- **Root-relative asset paths on a project site** — `/style.css` 404s because the site lives under `/repo/`; use a base path or relative URLs.
- **Underscore folders vanish** — a `_next/` or `_assets/` dir disappears under Jekyll; add `.nojekyll`.
- **Public output from a private repo** — the *source* repo may be private, but the published Pages site is world-readable (unless on Enterprise). Don't ship secrets into the build.
- **Stale DNS / HTTPS** — changing the custom domain before DNS propagates leaves the cert unprovisioned; "Enforce HTTPS" stays greyed out until it resolves.

## See also

- [[readme-license-and-repository-structure]]
- [[github-actions-and-ci-cd]]
