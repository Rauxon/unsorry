# ADR-021: Sponsor PR Helper

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-021 |
| **Initiative** | unsorry Phase 3 — thread C (upstreaming ergonomics) |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-12 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** ADR-020 stopping at a ready packet because mathlib policy reserves the PR and the review conversation for a human who understands the proof,
**facing** the fact that "everything after the packet is human" bundled two very different things — the *irreducibly human* parts (understanding the proof, the Zulip thread, the PR narrative, review replies) and a pile of *purely mechanical* git/gh plumbing (clone master, branch, `git apply`, commit, push to a fork, open the PR) — and leaving the sponsor to hand-run fifteen commands made the last mile feel like the machine had quit early,
**we decided for** a sponsor-run helper (`tools/upstream/raise_pr.py`) that performs only the mechanical half: it clones/updates mathlib master, applies the packet patch to a fresh branch, pushes to the sponsor's fork, and opens a **draft** PR against `leanprover-community/mathlib4` whose body carries the factual AI-disclosure block and a loud `SPONSOR: replace…` narrative placeholder — with the policy boundary *enforced*, not merely documented: it refuses without `--understood` (running it is the sponsor's attestation that they have read the proof), refuses a packet that is not `packet-ready` or HEAD-verified, opens a **draft** (not a review request) and never marks it ready, and never writes a review reply,
**and neglected** auto-marking the PR ready (that is the human's act of vouching), generating the PR narrative even as a draft to edit (mathlib forbids LLM-written conversation; the placeholder forces the human's words), and running unattended in CI (it must run as the *sponsor's* identity against the *sponsor's* fork — a bot identity opening mathlib PRs is the exact policy violation ADR-020 forbids),
**to achieve** a last mile where the sponsor's effort is the part only a human can do — understand, discuss, write, vouch — with zero mechanical friction,
**accepting that** the helper needs the sponsor's local `gh`/git auth and a mathlib fork, that a draft PR is still visible on mathlib (mitigated: draft ≠ review request, and the placeholder + `--understood` make the human commitment explicit before anything is pushed), and that the `--understood` flag is an honour-system attestation (as it must be — no tool can verify understanding).

## Context

Closes the ergonomic gap the maintainer flagged: the expectation was "the PR gets raised and I approve it", the ADR-020 reality was "here is a packet, now hand-run the git". This ADR splits the last step precisely along the policy line and automates only the side that is safe to automate.

## Options Considered

### Option 1: Sponsor-run helper, draft PR, enforced boundary (Selected)
**Pros:** removes all mechanical friction; encodes the policy as preconditions and a draft+placeholder; runs as the human, so it is the human acting.
**Cons:** needs local auth + a fork; honour-system `--understood`.

### Option 2: Push the branch only; print the "create PR" URL (Rejected)
Safer but leaves the sponsor to open the PR by hand — the maintainer explicitly wanted the PR raised. The draft + placeholder achieves the same safety without the manual step.

### Option 3: CI opens the mathlib PR (Rejected, permanently)
A bot identity opening mathlib PRs is precisely what ADR-020 / mathlib policy forbid. Non-negotiable.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Depends On | ADR-020 | Human-Sponsored Upstreaming | Consumes the packet + patch + HEAD stamp |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-021-A — Sponsor PR helper | Specification | specs/SPEC-021-A-Sponsor-PR-Helper.md |
| REF-2 | Upstreaming process | Documentation | ../upstreaming.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-12 |
| Accepted | unsorry maintainers | 2026-06-12 |
