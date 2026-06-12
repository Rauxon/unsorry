# ADR-020: Human-Sponsored Upstreaming

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-020 |
| **Initiative** | unsorry Phase 3 — thread C (realise the public good) |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-12 |
| **Status** | Accepted (sponsor signed up: Chris Barlow, 2026-06-12) |

## WH(Y) Decision Statement
**In the context of** a library whose public good is only realised when a verified lemma lands in the commons, and mathlib's verified AI-contribution policy — disclosure mandatory, `LLM-generated` label, the author must understand everything without AI, LLM-written GitHub/Zulip conversation forbidden, low-quality LLM PRs summarily closed,
**facing** the fact that a fully autonomous unsorry→mathlib pipeline is therefore against policy *and* strategically self-defeating (one spammy AI PR costs more credibility than a merged lemma gains), while a purely manual path would leave proved, absence-verified lemmas sitting unharvested as the swarm's output grows,
**we decided for** machine-prepared, human-sponsored upstreaming with **automatic initiation**: a nightly workflow scans for packet-eligible targets — proved (library/index) ∧ ADR-012 absence-verified (structured `Absence` backlog field; machine-minted decomposition subs are excluded by construction) ∧ unpacketed — and for each runs dedup at mathlib HEAD, renders a mechanical sponsor packet (`docs/upstream/<id>.md` + a `git apply`-able new-file patch with the human author's header), and opens a gated docs PR assigned to the **named sponsor (Chris Barlow)**, who owns everything after the packet: reading the proof to full unaided understanding, the Zulip-first question, the PR, and every review reply — in his own words,
**and neglected** autonomous mathlib PRs/comments/Zulip posts (forbidden, permanently), LLM-drafted PR narrative even as a "draft to edit" (the rewrite-in-own-words boundary is stated inside every packet; only the lemma itself and the factual disclosure block are paste-ready), bulk submission (one lemma per PR, Zulip-first, paced by community feedback), and packeting the 17 shakedown lemmas (they exist in mathlib; the eligibility rule excludes them via the missing `Absence` field),
**to achieve** a pipeline where a target that becomes ready generates its sponsor packet by itself — the sponsor's queue is the open packet PRs — while every word the mathlib community reads from a human is actually the human's,
**accepting that** the sponsor is a real bottleneck by design (community trust does not parallelise), packets may be declined ("declined" is a valid recorded outcome that still validates the machinery), the HEAD kernel-verification stage is deliberately manual/dispatch-heavy (60–90 min cold), and the patch's `Mathlib/Unsorry/` placeholder path makes placement an explicit Zulip question rather than a machine guess.

## Context

Implements the merged thread-C proposal (`docs/proposals/mathlib-upstream-plan.md`), whose policy constraints were verified against the mathlib contributing guide on 2026-06-11. The proposal expected 2 candidates; by implementation time **9 targets** are eligible (the swarm and two external contributor machines proved seven more ADR-012 targets in between) — which is exactly why initiation is automatic rather than a maintainer remembering to run a script.

## Options Considered

### Option 1: Auto-initiated mechanical packets + named human sponsor (Selected)
**Pros:** policy-compliant by construction; nothing unharvested; the boundary between machine facts and human words is explicit in every artifact.
**Cons:** sponsor bottleneck; CI token caveat (default-token PRs trigger no checks — documented in the workflow and checklist).

### Option 2: Fully autonomous mathlib PRs (Rejected, permanently)
Against mathlib policy; would burn the project's honesty capital. A standing non-goal, restated from the proposal.

### Option 3: Manual pipeline runs (Rejected)
The maintainer running scripts on demand. Rejected: already stale twice in one day (2→9 candidates while building this); readiness is machine-detectable, so detection should be machine-owned.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Depends On | ADR-012 | Backlog Sourcing | The `Absence` field is the eligibility provenance |
| Relates To | ADR-006 | Gate A | Gate evidence is part of the disclosure dossier |
| Relates To | ADR-019 | CI Supply-Chain Protection | The packet workflow arrives pinned |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-020-A — Upstream pipeline | Specification | specs/SPEC-020-A-Human-Sponsored-Upstreaming.md |
| REF-2 | Thread-C proposal | Proposal | ../proposals/mathlib-upstream-plan.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-12 |
| Accepted | Chris Barlow (sponsor sign-up) | 2026-06-12 |
