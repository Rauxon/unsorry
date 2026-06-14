# ADR-033: Incremental (Diff-Scoped) Kernel Replay

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-033 |
| **Initiative** | Gate A performance / soundness scope |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** Gate A's `leanchecker` kernel replay, which re-verifies the **entire** library on every PR (SPEC-006-B, full-library anti-tampering), and which has become the gate's long pole as the library grew toward ~180 modules — ~20 min wall time at ~12 GB RAM plus heavy swap, the OOM/thrash we have been papering over with serialization, chunking, a best-effort swapfile, and a larger runner,

**facing** measurements showing `leanchecker`'s cost scales with the **import union of the module set** it is given (1 module ≈ 10 s / 1.4 GB; a 30-module chunk ≈ 127 s / 12.5 GB; all 56 local proof modules in one process ≈ 225 s / 20 GB; the ~180-module production set OOMs a 16 GB runner) — while a typical PR changes only **1–3** library modules and re-replays the unchanged remainder for nothing, because in CI **every olean is rebuilt from the PR's own sources**, so a module whose source *and entire transitive import closure* are unchanged rebuilds **byte-identically** to the olean already kernel-replayed when it merged,

**we decided for** scoping the PR-time replay to the **changed library modules plus their transitive reverse-import closure** (every on-disk module that imports, directly or transitively, a changed one), with conservative **full-replay fallbacks**: a push to `main` (no PR base), a diff that cannot be computed (shallow clone / missing base), or a **global-impact change** (`lean-toolchain`, `lakefile.toml`, `lakefile.lean`, `lake-manifest.json`, `tools/gate_a/**`, `.github/workflows/gate-a.yml`),

**and neglected** dropping `leanchecker` entirely (it is the kernel-level anti-tampering layer beyond the elaborating build — keep it), skipping or trusting the mathlib re-load (orthogonal: the cost is the per-set import union, which incremental already collapses; mathlib remains a pinned, verified cache under ADR-002), and running incremental on `main` (main keeps doing a **full** replay post-merge as a defense-in-depth backstop),

**to achieve** a typical proof PR's replay dropping from ~20 min / 12 GB-plus-swap to **~10–30 s / <2 GB**, removing the gate's bottleneck and the OOM pressure on any runner size, without weakening the soundness guarantee,

**accepting that** this narrows the per-PR replay scope — a Gate A trust-surface change — justified by the invariant *"a module outside the replay set has an unchanged source **and** only unchanged dependencies, so its rebuilt olean is identical to the already-verified `main` olean"*; that the reverse closure is computed by parsing `import Unsorry.*` lines, so generated `*Binding` modules (which `import Unsorry.<Base>`, ADR-011) are pulled into the replay set automatically when their base changes; that **any** uncertainty (diff failure, global-impact change, non-PR build) falls back to a full replay rather than under-checking; and that the `main` post-merge full replay remains the catch-all if a per-PR scoping ever proves too narrow.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Incremental kernel-replay specification | Specification | specs/SPEC-033-A-Incremental-Kernel-Replay.md |
| REF-2 | Gate A workflow (full-replay scope amended here) | Specification | specs/SPEC-006-B-Gate-A-Workflow.md |
| REF-3 | Soundness gate (Gate A) | Decision | ADR-006-Soundness-Gate.md |
| REF-4 | Pinned mathlib binary cache | Decision | ADR-002-Mathlib-Pinning.md |
| REF-5 | Statement-binding obligations (`*Binding` modules) | Decision | ADR-011-Statement-Binding.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
