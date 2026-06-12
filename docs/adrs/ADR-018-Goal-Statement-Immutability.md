# ADR-018: Goal-Statement Immutability

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-018 |
| **Initiative** | unsorry Phase 3 — soundness hardening (issue #190) |
| **Proposed By** | unsorry maintainers (finding: external review, issue #190) |
| **Date** | 2026-06-12 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a gate architecture in which every statement-integrity layer derives from `goals/<id>.lean` *as it exists in the PR's own tree* — the ADR-011 binding obligation is regenerated from it, and Gate B's sha checks (GB006/GB016) recompute against it,
**facing** issue #190's CRITICAL finding that this self-consistency is circular against a coordinated attack: a PR that rewrites {goal `.lean` weakened, goal record sha, index entry, library proof} **consistently** passes both gates, because nothing pins a statement against history — which bites exactly the advertised open "untrusted rag-tag contributors" trust model,
**we decided for** making goal `.lean` files **create-only**: a new gate-a step (`tools/gate_a/check_goal_immutability.py`) diffs `goals/` against the PR base ref and rejects any modify, delete, rename, or typechange of an existing `goals/*.lean` — creation (translate, decompose, backlog seeding) remains the only legitimate write, a wrong statement gets a *new* goal id with the old goal abandoned in place, and the rule is unconditional (no proved-status exemption: an open goal's statement is the contract for every future claim too),
**and neglected** putting the rule in Gate B (deliberately treeless — it validates a tree, and "modification" only exists relative to a base ref, which is CI's context), pinning `.aisp` records (they change legitimately — status, affinity — and their shas are recomputed *from* the pinned `.lean`, so freezing the `.lean` closes the chain), and a softer "frozen once proved" variant (the index entry is itself part of the attacker-controlled tree; existence-at-base is the only anchor the attacker cannot touch),
**to achieve** a statement history the kernel's verdicts can be trusted against: what a goal *says* can never silently change under a proof, a binding, or an index entry,
**accepting that** legitimate statement fixes become a new-goal-id workflow (deliberate friction — an editable history is exactly the tampering surface), and that residual surfaces remain outside this pin (deleting a `library/index` entry un-proves a goal; workflow-file self-modification is ADR-019's territory) — recorded, not hidden.

## Context

Found by the external review in issue #190 ("Soundness assessment: … CRITICAL hole: same-PR goal tampering … Nothing pins a proved goal's canonical statement against history. Fix is small."). The fix is the review's suggested base-ref diff, implemented as a tested module rather than inline YAML so the rule itself is under TDD. Red-team round 003 (`docs/metrics/gate-a-redteam-003.md`) replays the exact attack with a real adversarial PR.

## Options Considered

### Option 1: Create-only `goals/*.lean`, enforced by base-ref diff in gate-a (Selected)
**Pros:** the base ref is the one thing a PR cannot rewrite; cheap (runs before the build); testable pure core; covers open and proved goals alike.
**Cons:** statement fixes need a new goal id; depends on gate-a running unneutered (ADR-019 hardens that).

### Option 2: Gate B rule "reject modification once an index entry exists" (Rejected)
The review's alternative. Rejected: Gate B is treeless by design and the index entry is part of the same attacker-controlled tree — a tampering PR can adjust it consistently. Modification is a *history* property; only the layer with a base ref can see it.

### Option 3: Signed/hashed statement registry outside the repo (Rejected)
A second root of trust to operate and protect. Rejected as disproportionate: existence-at-base-ref gives the same anchor for free.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Amends | ADR-006 | Gate A Soundness Enforcement | New authoritative layer |
| Relates To | ADR-011 | Statement-Binding Gate | Binding regenerates from the now-pinned statement |
| Relates To | ADR-019 | CI Supply-Chain & Workflow Protection | Protects the layer itself |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-018-A — Goal-statement immutability | Specification | specs/SPEC-018-A-Goal-Statement-Immutability.md |
| REF-2 | External review | Issue | https://github.com/agenticsnz/unsorry/issues/190 |
| REF-3 | Red-team round 003 | Metrics | ../metrics/gate-a-redteam-003.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-12 |
| Accepted | unsorry maintainers | 2026-06-12 |
