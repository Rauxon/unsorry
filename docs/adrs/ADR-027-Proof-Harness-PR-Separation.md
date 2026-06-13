# ADR-027: Proof / Harness PR Separation

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-027 |
| **Initiative** | repository governance / trust-surface isolation |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a trunk-based repository where the swarm continuously opens **proof** PRs (verified content under `library/`, `goals/`, `proof-runs/`, …) while maintainers evolve the **harness** (the trust-bearing machinery under `swarm/`, `tools/`, `.github/`, `lakefile.toml`, `lean-toolchain` that decides whether a proof is accepted), and where ADR-026 already made the PR-title taxonomy a required gate,
**facing** the fact that nothing stopped a single PR from changing both surfaces at once — which is exactly how the #292 harness regression rode in unnoticed and halted the proof queue, and which tangles review (a proof reviewer is not reviewing trust-bearing code, and vice-versa),
**we decided for** a required `pr-scope` CI gate that classifies a PR's changed paths into the *proof* surface, the *harness* surface, or *neutral* (docs, CHANGELOG, README, licence) and **fails any PR that touches both** proof and harness, while letting neutral paths travel with either side; the classifier (`tools/repo/pr_scope.py`) is pure and unit-tested and runs fork-safely on the base ref via the changed-file API,
**and neglected** enforcing this only by convention/review (the status quo that let #292 through), splitting by directory ownership alone (CODEOWNERS already requires review for harness paths but does not prevent bundling), and a allow-list of "blessed" mixed PRs (it would reopen the exact hole),
**to achieve** that a harness change is always isolated from verified content, so a regression cannot hide in a proof PR, the right gates and reviewers apply to each kind, and the queue stays legible,
**accepting that** a genuinely cross-cutting change must now be split into two PRs (proof side and harness side), that the proof/harness/neutral path lists are a maintained policy that will need updates as the tree grows, and that this gate checks *paths*, not semantics (it does not verify the title matches the content — ADR-026 covers the title, and that title-vs-content tightening remains future work in #302).

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Proof/harness PR-scope separation specification | Specification | specs/SPEC-027-A-Proof-Harness-PR-Separation.md |
| REF-2 | PR convention enforcement | Decision | ADR-026-PR-Convention-Enforcement.md |
| REF-3 | CI hardening follow-ups | Issue | GitHub issue #302 |
| REF-4 | Motivating incident | PRs | #292 (regression), #301 (fix) |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-13 |
| Accepted | unsorry maintainers | 2026-06-13 |
