# ADR-048: Verify-on-Ingest — Kernel-Verify Each Proof Once, Then Trust Immutability

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-048 |
| **Initiative** | unsorry — Gate A soundness model / performance |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Accepted |

## Context

Gate A's implicit model has been *re-verify in CI*: the full kernel replay (`leanchecker`) and
axiom audit re-run over large module sets — on every push to `main` (full backstop) and, until now,
on every archive-block PR (which re-replayed the archived proofs). On the available 16 GB (and
8 GB proof-PR) Namespace runners this is the dominant cost and the source of the exit-137 OOM class:
each archive package is a separate Lake project whose `leanchecker` loads its own full mathlib image
(>8 GB resident), so re-replaying a block OOM-killed even a 16 GB runner regardless of chunk size
(#764). But the *same proofs validate fine when active*, because their kernel replay runs once on the
larger push-to-`main` runner and PR-time replay is incremental and small.

The key observation: **a proof module only needs a kernel replay when its trusted context changes** —
the proof file, its goal statement, its imports/dependencies, the Lean/mathlib/lake configuration, or
the Gate A checker logic. If none of those changed, re-running `leanchecker` on the *same immutable
proof* re-proves nothing. Archiving a proof is a file move + metadata change; it changes none of the
above.

## WH(Y) Decision Statement

**In the context of** a Gate A that re-verifies large proof sets in CI — re-replaying archived blocks
and full-replaying on every push — at a cost that OOMs memory-bound runners and forces a 16 GB
profile just to re-check already-verified, immutable proofs,

**facing** the fact that this re-verification is redundant whenever the proof artifact and its
verification context are unchanged, and that the redundancy is precisely what blocks downscaling CI
to 8 GB,

**we decided for** a **verify-on-ingest** model: a proof is kernel-verified **exactly once**, by the
**trusted CI pipeline**, at the PR that introduces it (the normal incremental Gate A: build,
statement-binding, axiom audit, `leanchecker` replay). After it merges it is *verified for that
toolchain/mathlib context*. Thereafter the system **trusts the immutable artifact** rather than
re-deriving soundness: an archive move validates **provenance + byte-identity** (the archived file is
byte-for-byte the already-verified active proof, ADR-018) plus **packaging sanity** (`lake build
--wfail`), and does **not** re-run `leanchecker`,

**and explicitly NOT** "trust because the proving agent says it checked" — trust is *"CI verified
this exact artifact and the artifact is immutable since"*, never a prover's self-attestation,

**and neglected** making archive validation heavier / finding it a bigger runner (#838 — a tactical
unblocker that re-checks what's already verified), because verify-on-ingest matches what archives
*are* (frozen, already-verified blocks),

**to achieve** removal of the archive-OOM class entirely, archive PRs that are provenance + packaging
validation (cheap, fit 8 GB), and — with the rollout below — downscaling routine CI from 16 GB to
8 GB and a faster pipeline,

**accepting that** the residual risk shifts from *Lean soundness* to *bookkeeping soundness*: the
system must reliably know an archived proof is exactly the one CI verified (guardrails below), that a
context change must still force re-verification, and that a scheduled full replay remains as
defense-in-depth.

## Policy

1. **Active proof PRs** pass normal Gate A: build, statement-binding, axiom audit, **kernel replay**
   (incremental — only the changed modules + their reverse-import closure, ADR-033).
2. After merge, the proof is **verified for that toolchain/mathlib context**.
3. **Archive moves** validate that the archived file is **byte-identical** to an already-verified
   active proof (ADR-018 archive-aware immutability) and that metadata references that verification —
   plus `lake build --wfail` for packaging sanity. **No `leanchecker` replay.**
4. **Re-verification (kernel replay) re-runs only when the trusted context changes**: the proof file,
   its goal statement, its imports/deps, `lean-toolchain`/lakefile/`lake-manifest.json`, or the Gate A
   checker (`tools/gate_a/**`). These are exactly the ADR-033 full-replay triggers.
5. **Full replay becomes scheduled or context-triggered**, not a per-push / per-archive-PR step.

## Guardrails (bookkeeping soundness)

- Store the proof file hash at verification time (goal record `sha`; archive manifest hashes).
- Treat the per-package `lean-toolchain` + lakefile as the pinned verification context (archive
  packages are self-contained and frozen, so their context never drifts).
- The archive record must reference the verified hash; **reject an archive move if the file content
  differs** (ADR-018 byte-identity check, enforced in `gate-a-prepare`).
- **Force a full re-verify on toolchain / mathlib / lake / checker changes** (ADR-033 triggers).
- Keep a **scheduled full replay** as defense-in-depth against bookkeeping or scoping bugs.

## Rollout

- **Phase 1 (this ADR):** archive validation drops the `leanchecker` replay — provenance +
  `lake build --wfail` only. Removes the archive-OOM class; archive PRs fit 8 GB. (Supersedes the
  #823 chunking and #838 16 GB-runner tactical fixes for archives.)
- **Phase 2 (follow-up):** make the push-to-`main` full replay **incremental** (re-check only the
  pushed diff) with a **scheduled** full replay as the backstop; then **downscale the runner profiles
  16 GB → 8 GB**. Toolchain/dep full re-verifies (rare) run on a scheduled/temporarily-scaled runner
  or with small chunks. This is the change that realises the downscale + speed-up.

## Soundness

Lean soundness is unchanged: every proof is still kernel-replayed by the trusted pipeline once, under
the toolchain/mathlib it is verified against, and a context change re-triggers verification. What
changes is that we **stop re-deriving** soundness for unchanged, immutable artifacts and instead
**carry it forward via provenance**. The trust boundary is "CI verified this exact artifact +
immutability," not the prover. Defense-in-depth (scheduled full replay; context-change triggers;
byte-identity enforcement) covers the bookkeeping risk.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Archive-aware immutability / byte-identity | Decision | ADR-018-Goal-Statement-Immutability.md |
| REF-2 | Incremental kernel replay + full-replay triggers | Decision | ADR-033-Incremental-Kernel-Replay.md |
| REF-3 | Proof archive blocks | Decision | ADR-041-Proof-Archive-Blocks.md |
| REF-4 | Gate A soundness enforcement (re-verify stance amended) | Decision | ADR-006-Gate-A-Soundness-Enforcement.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
| Accepted | unsorry maintainers | 2026-06-15 |
