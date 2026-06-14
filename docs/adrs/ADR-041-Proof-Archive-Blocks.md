# ADR-041: Proof Archive Blocks

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-041 |
| **Initiative** | Gate A performance / proof-library lifecycle |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## WH(Y) Decision Statement

**In the context of** an unsorry library that keeps accumulating solved proof modules in one
active Lean package, where Gate A's build, axiom audit, statement-binding regeneration, and
kernel replay all become slower as the verified library grows,

**facing** the fact that most merged proofs are no longer active development targets but still
sit in the same package as new work, causing every full validation path to scale with the
historical proof count rather than with the current working set,

**we decided for** splitting proved work into immutable **proof archive blocks**: keep only the
current working set in the active package, and when the active proved set reaches a target of
**40 proved goals**, cut a frozen archive package containing that block's proofs, index entries,
and any required metadata. The active package then depends on the archived block by a pinned
Lake/Git revision instead of carrying all archived proof source files in its own active module
set,

**and neglected** keeping one ever-growing package indefinitely (simple but makes Gate A's long
pole grow forever), archiving by individual proof (too much package/index churn), archiving only
by moving files to a directory still enumerated by Gate A (does not reduce the active
verification surface), and choosing 50+ as the initial block size (reasonable once proof inflow
is steady, but too coarse for the current library size and operational learning loop),

**to achieve** a bounded active verification surface, faster normal proof PRs, clearer lifecycle
boundaries between current work and frozen dependencies, and a path toward distributed
problem-solving where solved blocks behave like pinned, previously certified dependencies rather
than live source,

**accepting that** archive boundaries add dependency-management overhead; that archive blocks
must be validated fully before freezing; that the initial block size of 40 is an operational
target, not a mathematical invariant, and may be retuned later from CI telemetry; and that any
change to an archive package or dependency pin is trust-bearing and must trigger full validation
of the affected archive/pin boundary.

## Policy

An archive block is created when the active package reaches roughly 40 proved goals. The
maintainer may delay a cut to avoid splitting a tightly related decomposition tree, but the
default target remains 40 because it keeps blocks reviewable and gives CI feedback sooner than a
50- or 100-proof block.

Before a block is frozen, it must pass the full Gate A soundness stack for the block:

- `lake build --wfail`
- authoritative axiom audit
- `leanchecker` kernel replay
- statement-binding regeneration/checks for the archived goals
- forbidden elaboration option checks
- Gate B index/proof-run metadata validation

After freezing, normal active proof PRs do not replay or re-audit the archive source. They
validate the active package plus the pinned archive dependency boundary. A PR that modifies an
archive block, changes its pin, changes the archive packaging rules, or changes shared Gate A
tooling falls back to full validation for the affected trust boundary.

## Shape

The preferred first implementation is separate Lake packages, not necessarily separate GitHub
repositories:

```text
packages/
  unsorry-active/
  unsorry-archive-0001/
  unsorry-archive-0002/
```

Separate repositories can come later if package size, release cadence, or external reuse makes
that worthwhile. Starting in one repository keeps history, issue links, and migration tooling
simpler while still letting Gate A distinguish active modules from frozen archive modules.

Each archive block should carry:

- the archived `library/Unsorry/*.lean` modules for that block
- the corresponding `library/index/*.aisp` entries
- enough goal/proof-run metadata to preserve provenance and leaderboard attribution
- a manifest recording the block number, proof count, source commit, validation commit, and
  dependency pins

## Consequences

- **Positive.** Normal CI scales with the active block instead of all historical proofs. A
  40-proof active package should be easier to validate, reason about, and cache than a package
  that grows without bound.
- **Positive.** Archive packages become reusable proof dependencies, closer to how the project
  already treats pinned mathlib artifacts.
- **Cost.** The repo needs migration tooling, package manifests, import rewrites, and Gate A
  awareness of active-vs-archive paths.
- **Cost.** Dependency pin changes become explicit trust events and need dedicated validation.
- **Residue.** Archive blocks reduce active verification scope, but they do not remove the need
  for periodic full validation, especially after Lean/mathlib/toolchain changes.

## Implementation Notes

The first implementation should be conservative:

1. Add tooling that reports active proved count and proposes the next archive cut at 40.
2. Create `unsorry-archive-0001` from the oldest stable proved goals.
3. Teach Gate A to validate active modules by default and full-validate archive packages only
   when archive paths or pins change.
4. Keep a scheduled or manual full validation over all archive blocks as a backstop.
5. Record CI timing before and after the first archive cut to decide whether 40 remains the
   right block size.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Gate A soundness enforcement | Decision | ADR-006-Gate-A-Soundness-Enforcement.md |
| REF-2 | Statement binding gate | Decision | ADR-011-Statement-Binding-Gate.md |
| REF-3 | Incremental kernel replay | Decision | ADR-033-Incremental-Kernel-Replay.md |
| REF-4 | Gate A workflow | Specification | specs/SPEC-006-B-Gate-A-Workflow.md |
| REF-5 | Distributed workload engine | Decision | ADR-030-Distributed-Workload-Engine.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
