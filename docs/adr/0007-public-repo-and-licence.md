# ADR 0007 — Public repository mothy2180/donation-jar, licensed AGPL-3.0-only

**Status**: Accepted (founder decision) · **Date**: 2026-10-05 (proposed 2026-10-04)

## Context
GitHub's secret scanning, push protection and CodeQL are free only on public
repositories (private repos need Team plus US$19/US$30 per committer). A
transparency platform benefits from open code. This Mac's GitHub CLI, SSH key
and global git identity default to a separate work account, which must not
appear in a public repository.

## Decision
- Repository: **public `github.com/mothy2180/donation-jar`** (personal account).
  The product's working name stays "Balang"; the repo name is deliberately
  brand-neutral until the name is final (GitHub redirects after a rename).
- Licence: **GNU AGPL-3.0-only** (full text in `LICENSE`): anyone who runs a
  modified hosted copy must publish their changes.
- Authorship: commits are authored "Timothy Thomas" with mothy2180's private
  noreply address `114565357+mothy2180@users.noreply.github.com`; the repo is
  pinned to mothy2180 with a repo-local credential helper
  (`docs/runbooks/github-account.md`).
- Runbooks with personal details, legal drafts and anything sensitive go to a
  separate **private** repo, `mothy2180/donation-jar-ops`, created when first needed.

## Consequences
- Free security tooling and unlimited Actions minutes from day one.
- Nothing secret may ever be committed: gitleaks pre-commit, the `.env.example`
  pattern and GitHub push protection.
- Third-party contributions will need a contributor agreement or DCO if the
  licence is ever to change; decide before accepting outside code.
