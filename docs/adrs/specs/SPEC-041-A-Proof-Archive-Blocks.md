# SPEC-041-A: Proof Archive Blocks

Implements: [ADR-041](../ADR-041-Proof-Archive-Blocks.md) · Status: Living · Updated: 2026-06-14

## 1. Terms

- **Active package**: the package that receives normal proof PRs and contains the current working set.
- **Archive block**: an immutable Lake package containing a frozen batch of proved goals.
- **Block target size**: 40 proved goals for the initial rollout. This is an operational threshold, not a soundness invariant.
- **Archive pin**: the exact Git/Lake revision by which the active package depends on an archive block.

## 2. Archive Cut Rule

The active package becomes archive-eligible when it contains at least 40 proved goals that are not already assigned to an archive block.

The cut tool should:

1. Count proved goals from `goals/*.aisp` records with `status≜proved`.
2. Exclude any goal already recorded in an archive manifest.
3. Select the oldest stable proved goals until the next block reaches 40, unless doing so would split a tightly coupled decomposition tree.
4. Emit a proposed manifest before moving files.

The report-only command is:

```bash
python3 -m tools.archive --size 40
python3 -m tools.archive --size 40 --json
```

It emits the next archive block id, eligible proved count, selected goal/module
pairs, and dependency/decomposition groups deferred to avoid splitting related
work.

Maintainers may defer a cut for dependency-tree coherence, but should record the reason in the archive manifest or PR body.

## 3. Package Shape

The first implementation keeps archive packages in the same repository:

```text
packages/
  unsorry-active/
  unsorry-archive-0001/
  unsorry-archive-0002/
```

Each archive block contains:

- the archived proof modules;
- corresponding `library/index/*.aisp` records;
- enough goal/proof-run metadata to preserve provenance and leaderboard attribution;
- an archive manifest.

The manifest records:

- block id, for example `unsorry-archive-0001`;
- proof count;
- goal ids;
- module names;
- source commit used to cut the archive;
- validation commit;
- Lean/mathlib/archive dependency pins.

## 4. Validation Rules

Before an archive block is frozen, CI must run the full soundness and metadata stack for that block:

- `lake build --wfail`;
- authoritative axiom audit;
- `leanchecker` kernel replay;
- statement-binding regeneration/checks for archived goals;
- forbidden elaboration option checks;
- Gate B validation over archived index/proof-run metadata.

After freezing:

- normal active proof PRs validate the active package and the archive pins they depend on;
- archive source is not re-audited or replayed on every active PR;
- any PR changing archive source, archive manifests, archive pins, archive packaging tools, `lean-toolchain`, Lake files, or Gate A tooling is trust-bearing and must full-validate the affected boundary;
- scheduled or manual full validation over all archive blocks remains the backstop for toolchain/mathlib migrations.

## 5. Gate A Integration

Gate A should distinguish three validation scopes:

1. **Active PR scope**: changed active modules plus existing incremental replay/audit closure.
2. **Archive boundary scope**: archive pin or manifest changes; validate the active package against the pinned archive and full-validate the touched archive block.
3. **Global scope**: toolchain, Lake, Gate A, or archive packaging changes; full-validate active plus affected archive blocks.

The default must always fail toward a larger validation scope when the changed-path classifier cannot decide.

## 6. Rollout Plan

1. Add a report-only tool that prints:
   - proved goals not assigned to an archive;
   - proposed next archive block at target size 40;
   - dependency/decomposition groups that should not be split.
2. Cut `unsorry-archive-0001` from the oldest stable proved goals.
3. Update imports and package configuration so active proofs can import archive modules through the pinned package dependency.
4. Update Gate A to use the three validation scopes in §5.
5. Compare CI timings before and after the first cut, then decide whether the block target should remain 40 or move to 50/100.

## 7. Acceptance Criteria

- A docs-only ADR/spec PR passes protocol and does not trigger Lean validation.
- `python3 -m tools.archive --size 40` can identify the next 40-goal block without moving files.
- A frozen archive block can be validated independently from the active package.
- A normal proof PR after the first archive cut does not enumerate archived proof modules in the active replay/audit set.
- A PR changing an archive pin or archive source triggers full validation for the affected archive boundary.
