# SPEC-041-A: Proof Archive Blocks

Implements: [ADR-041](../ADR-041-Proof-Archive-Blocks.md) · Status: Living · Updated: 2026-06-15

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

## 8. Cutting a block — runbook

This is the routine procedure performed for blocks 0001 and 0002. One block ≈ 40 proved goals
moving from the active package into a new frozen archive package; the active `goals/<id>.aisp`
records stay (re-pointed to the archive), only the proved artefacts move.

**1. Plan.** On an up-to-date checkout of `main`:

```bash
python3 -m tools.archive --size 40          # proposes block id + the 40 goals (module, sha, proved_at)
python3 -m tools.archive --size 40 --json   # machine-readable
```

Confirm the proposed `block_id` is the next one after the existing `packages/unsorry-archive-*`
(the planner derives it from existing manifests; if a checkout is stale it can mis-number — verify).

**2. Create `packages/unsorry-archive-NNNN/`.** Mirror an existing block (e.g. copy 0002's layout):

- `lakefile.toml` — `name = "unsorryArchiveNNNN"`, one `[[lean_lib]]` `UnsorryArchiveNNNN`
  (`srcDir = "library"`, `globs = ["Unsorry.+"]`), and the `mathlib` require pinned to the **current**
  `rev` (match root `lakefile.toml`).
- `lean-toolchain` — copy of the root `lean-toolchain`.
- `lake-manifest.json` — the resolved manifest for the package.
- For each selected goal `<id>` (module `Unsorry.<Mod>`):
  - **move** `library/Unsorry/<Mod>.lean` → `packages/unsorry-archive-NNNN/library/Unsorry/<Mod>.lean`
  - **move** its index entry `library/index/<sha>.aisp` → the package's `library/index/`
  - **move** `goals/<id>.lean` → the package's `goals/<id>.lean` (**byte-identical** — required so the
    ADR-018 immutability gate accepts its removal from active; see §9 of ADR-018 / the archive-aware
    exemption)
  - **copy** `goals/<id>.aisp` → the package's `goals/<id>.aisp` (provenance)
  - **move** `backlog/<id>.md`, `proof-runs/<id-runs>`, and any `decompositions/<id>.*.aisp` into the
    package's `backlog/`, `proof-runs/`, `decompositions/`.
- `archive-manifest.json` — `block_id`, `target_size`, `proof_count`, `status: "frozen"`,
  `source_commit`, `validation_commit` (null until validated), `pins` (`lean_toolchain`, `mathlib`),
  `notes`, `goals: [{goal, module}, …]`, `deferred_groups`.

**3. Retire from active.** Remove the moved `library/`, `goals/<id>.lean`, `backlog/`, `proof-runs/`,
and `decompositions/` entries from the active tree, and **edit each active `goals/<id>.aisp`** to the
archived end-state (keep the record, re-point it):

```
⟦Ω:Goal⟧{ … status≜archived … }
⟦Σ:Source⟧{ src≜packages/unsorry-archive-NNNN/backlog/<id>.md }
⟦Λ:Artifact⟧{ lean≜packages/unsorry-archive-NNNN/goals/<id>.lean ; sha≜<unchanged> ; aff≜… }
```

The `sha` is unchanged (the statement is preserved); only `status`, `src`, and the `lean` path move.

**4. Regenerate boards** (they are derived files): `python3 -m tools.leaderboard --write` plus the
targets board / metrics generators. Archived proofs retain leaderboard attribution.

**5. Validate locally** before the PR:

```bash
( cd packages/unsorry-archive-NNNN && lake exe cache get && lake build --wfail )
python3 -m tools.gate_a.archive_packages validate-changed       # build + audit + leanchecker replay of the block
python3 -m tools.leaderboard --check
```

**6. Open the PR** titled `chore(archive): retire active copies for block NNNN`. Gate A then
full-validates the new archive package (ADR-041 §4) and replays the **shrunk** active library. The
goal-`.lean` removals pass the ADR-018 immutability gate because each is recorded in the manifest
with a byte-identical archived copy (the archive-aware exemption).

## 9. Operating at scale

With a high inflow of proofs (many contributors / many agents), the active set crosses the block
target continuously, so archiving is **not** a one-off: the active package's full-replay and audit
cost (the Gate A long pole, especially on memory-bound runners where replay can't parallelise) grows
between cuts. Two implications:

- **Cut early and often.** Treat 40 as a ceiling, not a goal; a smaller effective active set keeps
  full validation fast. Cut a new block whenever the planner reports a full block of eligible goals.
- **Automate the cut.** The §8 runbook is mechanical and was done identically for 0001/0002 — it
  should become a `tools.archive` *write* mode (perform the moves, write the manifest, re-point the
  active records) plus a scheduled/threshold trigger that opens the retire PR automatically once the
  eligible count reaches a block. Until then, follow §8 by hand. (The planner today is report-only by
  design; the write mode is the natural next increment.)
