# ADR-012: Backlog Sourcing

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-012 |
| **Initiative** | unsorry Phase 2.5 — keeping the queue full |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-10 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a working swarm that produces kernel-verified Lean proofs and a contributor invitation that needs a steady stream of worthwhile targets, now that the machinery (decomposition, affinity, statement binding) is built and the first unformalised-in-mathlib lemma is proved,
**facing** the fact that the value of a target depends entirely on it being *already proven but not yet in mathlib* — and that mathlib-presence is exactly the claim humans and LLMs get wrong from memory (the Nicomachus case: confident-but-wrong recollection of a `Finset.sum_range_cube` that does not exist),
**we decided for** a sourcing pipeline that admits a target only after a **machine** absence check against the pinned mathlib source (`tools/sourcing/check_absence.py`, grep-authoritative + best-effort Loogle, recording the mathlib revision), with provenance (source, reference, absence-verified-at) on every goal record, fed by curated lists and a contributor issue template, and surfaced as a generated `docs/targets.md` board,
**and neglected** trusting human/LLM memory for absence, sourcing open conjectures, and admitting unverified statements,
**to achieve** a backlog that is genuinely *worth a researcher's time* — each target proven-but-unformalised, statement type-checked, absence machine-verified — riding the machinery already built (translate/fidelity for statements, affinity/gap for routing, decomposition for hard ones, binding for meaning),
**accepting that** grep cannot decide semantic presence so the absence check is a pre-filter not a proof (the definitive signal is downstream — an in-mathlib target gets a one-line citation, not a real proof), that mathlib moves so absence claims carry a shelf life, and that curation remains a human judgement at the top of the funnel.

## Context

unsorry proves theorems against the Lean kernel; it does not discover new mathematics. So the backlog is a **formalisation worklist** — theorems that are *already proven on paper but not yet in mathlib* — not a list of open conjectures. This boundary is load-bearing: the design doc ranks "pure-insight monoliths and fusion" (Riemann, P≠NP) last precisely because there is no proof for the swarm to formalise and no cheap oracle. Erdős/Millennium problems are out of scope by construction.

The hard part of sourcing is not finding candidate theorems; it is verifying *absence from mathlib*. The Nicomachus target (`∑ k³ = (∑ k)²`) is the cautionary tale this ADR is built around: capable models "recall" a named mathlib lemma for it that does not exist, while the real status is that it is left as a `sorry` exercise in *Mathematics in Lean* §5. Absence therefore cannot be a judgement call — it must be a machine check against the pinned mathlib the swarm actually builds against, recorded with the revision so the claim is dated.

The back half of the pipeline already exists: `backlog/*.md` (natural-language theorems) → the translate/fidelity gate (two independent agents lower English to a type-checking sorried `goals/<id>.lean`) → claim → prove, with affinity/gap routing the reachable ones first, decomposition splitting the hard ones, and the ADR-011 binding gate guaranteeing a proof proves *that* statement. This ADR adds the front half: where targets come from, how they are vetted, and how they are admitted.

## Options Considered

### Option 1: Machine absence check + provenance + curated lists + contributor template (Selected)
A target is admitted only after `check_absence` finds no mathlib match (advisory) and its statement type-checks; every goal record carries `source`, `reference`, and `absence_verified_at` provenance; a generated `docs/targets.md` board is the human-facing worklist.
**Pros:** keeps obvious duplicates out cheaply; dates every absence claim; rides the existing machinery; gives researchers a vetted, referenced queue.
**Cons:** grep absence is a pre-filter, not a proof; curation is still human at the funnel top; the board needs regeneration as goals change.

### Option 2: Trust human/LLM judgement of mathlib presence (Rejected)
Admit targets on a contributor's or agent's say-so. Rejected: this is the exact Nicomachus failure mode — confident, wrong, and it wastes the swarm's and researchers' time on duplicates. Absence is checkable; checking it is cheap.

### Option 3: Source open conjectures (Rejected)
Point the swarm at unsolved problems. Rejected: the swarm formalises existing proofs; it has nothing to formalise for an open conjecture, and the design doc's gating criterion (cheap, exact self-verification) is not met. Mis-scoping the backlog this way would also mislead contributors about what unsorry is.

### Option 4: Admit unverified statements, fix later (Rejected)
Let statements in without type-checking or absence verification and prune downstream. Rejected: an untyped statement is unclaimable, and an undetected duplicate burns a full prove cycle to discover what grep finds in milliseconds.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Depends On | ADR-003 | AISP Coordination Format | Targets are goal records; provenance fields live there |
| Relates To | ADR-010 | Affinity-Gap Selection | Difficulty/decomposition banding feeds gap-based routing |
| Relates To | ADR-011 | Statement-Binding Gate | Binding guarantees a proof matches the admitted statement |
| Refines | SPEC-003-A | Goal Record Schema | Adds optional provenance fields |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-012-A — Backlog sourcing pipeline | Specification | specs/SPEC-012-A-Backlog-Sourcing.md |
| REF-2 | Backlog sourcing proposal | Proposal | ../proposals/backlog-sourcing.md |
| REF-3 | Freek Wiedijk, Formalizing 100 Theorems (Lean column = unformalised) | External list | <https://www.cs.ru.nl/~freek/100/> |
| REF-4 | phase2-targets.md — "verify before claiming" discipline | Metrics/plan | ../phase2-targets.md |
| REF-5 | gate-a-redteam / Nicomachus — the absence-from-memory failure mode | Evidence | ../proposals/phase2-plan.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-10 |
| Accepted | unsorry maintainers | 2026-06-10 |
