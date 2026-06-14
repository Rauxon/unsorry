# ADR-040: Changelog Fragments (one file per change)

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-040 |
| **Initiative** | repository governance / contribution workflow |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** trunk-based development where many short-lived PRs squash-merge to `main` on green gates (ADR-005) at a high and rising cadence (swarm proofs plus harness/feature PRs), and a Keep-a-Changelog `CHANGELOG.md` whose single `[Unreleased]` section *every* user-facing PR edited at the same spot,

**facing** the fact that concurrent PRs therefore constantly conflict on `CHANGELOG.md` — and the `.gitattributes` `merge=union` driver only auto-resolves that on a **local** `git rebase`, while **GitHub's own conflict detection and merge button do not run custom merge drivers**, so PRs are flagged "dirty" repeatedly and re-rebasing only resets the clock; the contention is inherent to a shared edit point and grows with merge rate (it would be untenable at 3–10+ merges/hour),

**we decided for** **changelog fragments**: each user-facing change adds one uniquely-named file `changelog.d/<category>-<slug>.md` (category from Keep a Changelog) and **does not touch `CHANGELOG.md`**; `tools.changelog --preview` renders the `[Unreleased]` body from the fragments, and `tools.changelog --release <version> <date>` folds them into a versioned section and clears the directory; `CHANGELOG.md`'s `[Unreleased]` becomes a do-not-edit pointer,

**and neglected** generating the changelog from Conventional-Commit PR titles at release (also conflict-free, but it collapses the curated multi-sentence entries into one-line commit subjects), and keeping the union driver as the primary mechanism (GitHub ignores it, so it never fixed GitHub's view),

**to achieve** a changelog workflow that **sustains trunk-based development at any merge rate**: the hot path (every PR) only *adds* a disjoint file, so a 3-way merge — and GitHub — see independent additions and **never conflict**, whether the repo lands 1 or 100 merges an hour; the cold path (the release fold) is the only writer of `CHANGELOG.md` and is run by a single release process, so it is **serialized, not contended**, even if a release is cut on every deploy,

**accepting that** the one residual collision is two PRs choosing the *same fragment filename* — mitigated by requiring a unique slug (issue/PR number or agent id), and strictly weaker than the previous always-conflicting shared line; that in-flight PRs carrying old-style `[Unreleased]` edits must move their entry to a fragment during the transition; and that cutting a release is now a tool invocation (`tools.changelog --release`) rather than a hand-edit.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Changelog-fragments specification | Specification | specs/SPEC-040-A-Changelog-Fragments.md |
| REF-2 | Autonomous merge on green gates | Decision | ADR-005-Autonomous-Merge.md |
| REF-3 | PR convention enforcement | Decision | ADR-026-PR-Convention-Enforcement.md |
| REF-4 | Prior art: towncrier / scriv news fragments | Reference | https://github.com/twisted/towncrier |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
