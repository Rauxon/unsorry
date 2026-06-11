# ADR-014: Cross-Goal Dependency Reuse

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-014 |
| **Initiative** | unsorry Phase 3 — compounding (thread B) |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-11 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a library whose merged lemmas have never been *reused* — every proof to date imports only mathlib, so "every merged lemma makes the next one cheaper" (the README's headline) has been aspiration, not mechanism,
**facing** the fact that a prover agent has no way to know which of its goal's dependencies are already kernel-verified in this repository, and that a recomposing decomposition parent (ADR-009) is *expected* to build on its proved sub-lemmas but was never told about them,
**we decided for** surfacing a goal's proved dependencies in the prove prompt — its declared `deps≜⟨…⟩` entries plus the subs of any decomposition record naming it as parent — as explicit importable modules (`import Unsorry.<Module>` + theorem name + statement), located by which library file declares the theorem (`proved-deps` helper), with the import-tightness rule amended to allow exactly these,
**and neglected** automatic injection of the imports into the module (the prover decides whether to use them), surfacing unproved deps (gap routing, ADR-010, already orders those first), and transitive dependency closure (deferred until a real tree needs it),
**to achieve** actual compounding — a recomposing parent imports its proved subs instead of re-deriving them, and a seeded dependency tree (the Nicomachus triangular form depending on the proved `nicomachus_sum_cubes`) closes with merged work reused as a dependency,
**accepting that** the prover may still ignore the hint (the kernel and binding gate judge the result either way), library-internal imports lengthen the Gate A build graph marginally, and the helper's module location is by textual `theorem <name>` scan (the same pragmatic of the binding generator — Gate A remains the authority on what a module actually proves).

## Context

Thread B of the Phase-3 roadmap. The machinery exists end-to-end except for one link: nothing tells a prover that a dependency is already proved *here*. The prove prompt's import-tightness rule ("import exactly the mathlib modules the proof needs") actively pushed provers away from library reuse. Meanwhile ADR-010's gap term already routes goals bottom-up through a dependency tree, and ADR-009's unblock sweep re-opens a parent when its subs are proved — both assume the parent's prover will *use* the subs, which until now it could not know to do.

The mechanism is deliberately advisory: surfacing changes what the prover *knows*, not what the gates *accept*. Soundness is untouched — a parent that imports its subs still closes only through Gate A, the axiom audit, kernel replay, and the ADR-011 binding obligation.

## Options Considered

### Option 1: Surface proved deps (declared + own-decomposition subs) in the prove prompt (Selected)
`proved-deps` resolves each dep through the library index (the authoritative proved marker) to its declaring module, and the prompt lists `import Unsorry.<Module>` lines with statements.
**Pros:** minimal, advisory, rides existing records; makes the recompose path realistic; activates seeded dependency trees.
**Cons:** textual module location; prover may ignore it.

### Option 2: Auto-inject imports into the target module (Rejected)
Pre-write the import header before the prover runs. Rejected: the prover owns the module (rule 1); a pre-seeded file complicates the retry path and the prover can trivially write imports itself once told.

### Option 3: Transitive dependency closure (Rejected for now)
Surface deps-of-deps. Rejected until a real tree is deep enough to need it — today's trees are depth ≤ 1, and an import of a module transitively imports its imports anyway.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Depends On | ADR-009 | Goal Decomposition | Recomposing parents reuse their subs |
| Depends On | ADR-010 | Affinity-Gap Selection | Gap routing orders trees bottom-up |
| Relates To | ADR-011 | Statement-Binding Gate | Reuse changes knowledge, never acceptance |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-014-A — Dependency surfacing | Specification | specs/SPEC-014-A-Dependency-Reuse.md |
| REF-2 | Phase-3 roadmap, thread B | Proposal | ../proposals/phase3-roadmap.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-11 |
| Accepted | unsorry maintainers | 2026-06-11 |
