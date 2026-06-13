# ADR-026: PR Convention Enforcement and Trunk-Based Workflow

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-026 |
| **Initiative** | repository governance / agent–human ergonomics |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a trunk-based repository where most PRs are opened autonomously by the swarm and the rest by maintainers, where a single `main` is guarded by Gate A (soundness) and Gate B (hygiene), and where a PR's *kind* (a proved theorem, a theorem that did not pass, a harness fix, a feature, docs) already determines how it should be read and which gates matter,
**facing** the fact that this taxonomy was only *advisory* — `tools/repo/pr_labels.py` labelled titles but nothing failed a nonconforming title, harness/tooling changes and theorem PRs flowed through the same gates and could be bundled together, and a harness regression (the #292 path-guard break, fixed by #301) silently halted the proof pipeline because nothing separated or specially-gated trust-bearing harness changes,
**we decided for** making the existing title taxonomy a *required CI gate*: a new `pr-conventions` check runs the single-source-of-truth classifier and fails any PR whose title does not match a known shape; the accepted shapes are the full Conventional-Commits set (`feat/fix/docs/chore/ci/test/refactor/perf/build`, scope optional, `:` required) plus the swarm shapes (`prove(<goal>):` = theorem proved; `decompose(<goal>):` and `affinity(<goal>):` = theorem **not** proved, split or demoted; `tr(<goal>):`/`converge(<goal>):`), red-team, and release; and for documenting the canonical trunk-based workflow (one short-lived branch per single logical change off `main`, squash-merged on green gates, branch deleted after) in `CONTRIBUTING.md` and `docs/pr-labels.md` so agents and humans share one reference,
**and neglected** leaving the taxonomy advisory (the status quo that let the friction and the #292 mix-up happen), enforcing only via local git hooks (not honoured by the swarm or by fork PRs), inventing a parallel classifier (it would violate the single-source-of-truth and DRY), and — for *this* ADR — the heavier separation and regression gates (mixed proof/harness blocking, a harness-regression integration test, a protocol-compliance gate, a mock-provider end-to-end smoke), which are real but are tracked as staged follow-ups in issue #302 so each ships as its own PR rather than one bundle,
**to achieve** a repository where a PR's kind is unambiguous from its title alone, nonconforming or mixed-intent titles are caught before merge, and the conventions are written down once and enforced once,
**accepting that** title-shape enforcement does not yet verify that the title matches the PR's *content* (a `prove(...)` that also edits `swarm/` still passes this first gate — content/mixed-PR enforcement is the next follow-up), that broadening to the full Conventional-Commits set adds labels that did not previously exist in history, and that the gate trusts the base-branch classifier (run via `pull_request_target` on the base ref) rather than the PR head.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | PR convention enforcement specification | Specification | specs/SPEC-026-A-PR-Convention-Enforcement.md |
| REF-2 | PR labelling strategy | Reference | ../../pr-labels.md |
| REF-3 | Follow-up: CI hardening, regression gates, proof/harness separation | Issue | GitHub issue #302 |
| REF-4 | Motivating incident: harness regression and its fix | PRs | #292 (regression), #301 (fix) |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-13 |
| Accepted | unsorry maintainers | 2026-06-13 |
