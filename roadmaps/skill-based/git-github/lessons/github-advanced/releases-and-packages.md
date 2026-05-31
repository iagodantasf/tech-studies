---
title: Releases and packages
track: git-github
group: GitHub advanced
tags: [git-github, distribution]
prerequisites: [creating-and-pushing-tags, semantic-versioning]
see-also: [github-actions-and-ci-cd, dependabot-and-security-alerts]
---

# Releases and packages

Two distribution surfaces on GitHub: a **Release** is a tagged, human-facing bundle (notes + downloadable assets), while **GitHub Packages** is a registry hosting installable artifacts (npm, Maven, NuGet, RubyGems, containers).

## Why it matters

A Git [[creating-and-pushing-tags|tag]] marks a commit; a Release turns it into something users *consume* — changelog, binaries, a stable download URL. Packages then let consumers `npm install` or `docker pull` that build by version, scoped to your org and gated by GitHub auth. Together they are the "ship it" half of CI/**CD**, usually fired from a tag push.

## How it works

A Release wraps a Git tag with metadata and uploaded assets; a Package is published to a per-ecosystem registry endpoint with its own auth.

| Surface | Addressed by | Auth to install | Typical asset |
|---|---|---|---|
| Release | a git tag (`v2.3.0`) | none (public) | binaries, `.zip`, checksums |
| Container registry | `ghcr.io/org/img:tag` | token / `GITHUB_TOKEN` | OCI image |
| npm/Maven/NuGet | registry URL + scope | token in registry config | package tarball |

- **Tag → Release** — a Release *requires* a tag; creating one in the UI or via `gh release create v2.3.0` will create the tag if missing. Mark it **prerelease** or **draft** to stage before announcing.
- **Auto notes** — "Generate release notes" diffs since the last tag, grouping merged [[pull-requests|PRs]] (honoring `release.yml` categories) — pairs with [[semantic-versioning|semver]] tags.
- **`ghcr.io`** is the modern container registry (Docker Packages is deprecated); push with a `GITHUB_TOKEN` from Actions.
- **Immutability gap** — Release *assets* are downloadable URLs but the underlying tag can be force-moved; consumers should pin by checksum for true integrity.

## Example

Cut a release with a built binary from CI:
```yaml
on: { push: { tags: ['v*'] } }
permissions: { contents: write }      # needed to create releases
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: make build                 # → ./bin/app
      - run: gh release create "$GITHUB_REF_NAME" ./bin/app --generate-notes
        env: { GH_TOKEN: ${{ github.token }} }
```

## Pitfalls

- **Moving a published tag** — re-tagging `v2.3.0` to a new commit silently changes what a Release points at; downloaders who pinned the tag get different bytes. Cut a new version instead.
- **Editing release assets in place** — replacing an uploaded `.zip` keeps the URL but changes contents; ship a new release or publish checksums.
- **`latest` container tag** — `:latest` is a moving pointer, not a version; pin deploys to an immutable digest (`@sha256:...`).
- **Missing `contents: write`** — `gh release create` in Actions fails with 403 unless the workflow grants write permission.

## See also

- [[github-actions-and-ci-cd]]
- [[dependabot-and-security-alerts]]
