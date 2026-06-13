# ADR-028: Protocol-Compliance Gate (Spec-per-ADR)

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-028 |
| **Initiative** | repository governance / protocol enforcement |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a repository whose `docs/protocols.md` mandates a specification for every implementation ADR, where ADRs are added by both maintainers and (increasingly) agents, and where ADR-026/ADR-027 already established that conventions worth having are conventions worth enforcing in CI,
**facing** the fact that the spec-per-ADR rule was honoured only by discipline — an ADR could merge with no spec, eroding the "decision record + how" pairing that keeps the design legible,
**we decided for** a required `pr-protocol` CI gate that, for the **newly added** files in a PR, requires every added `ADR-<n>-*.md` to have a matching `SPEC-<n>-*.md` (added in the same PR or already present) and every added `SPEC-<n>` to have a matching `ADR-<n>`; the check (`tools/repo/pr_protocol.py`) is pure and unit-tested and scans only added paths so historical ADRs that predate the convention (ADR-001, ADR-002, ADR-005, ADR-022, …) are never retroactively failed,
**and neglected** retroactively requiring specs for all historical ADRs (it would wedge the repo and punish past decisions), enforcing a CHANGELOG entry on every PR in this same gate (it cannot cleanly tell a release-worthy change from swarm content like a single proof, so it would false-positive on proof PRs — left for a separate, scoped follow-up), and relying on review alone (the discipline that already slipped),
**to achieve** that the decision record and its "how" always travel together for new decisions, enforced uniformly for human and agent authors,
**accepting that** the gate checks file *pairing*, not spec *quality* or that the spec truly matches the ADR, that it keys on the shared `<n>` number (an ADR that deliberately reuses another ADR's spec must still add a same-number spec or be granted an exception), and that broader protocol checks (CHANGELOG, README accuracy) remain future work tracked in issue #302.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Protocol-compliance gate specification | Specification | specs/SPEC-028-A-Protocol-Compliance-Gate.md |
| REF-2 | Development protocols | Reference | ../../protocols.md |
| REF-3 | PR convention enforcement | Decision | ADR-026-PR-Convention-Enforcement.md |
| REF-4 | CI hardening follow-ups | Issue | GitHub issue #302 |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-13 |
| Accepted | unsorry maintainers | 2026-06-13 |
