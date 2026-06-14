---
name: unsorry-proof-authoring
description: "Workflow for adding, repairing, or reviewing Unsorry Lean proofs. Use when working with goals/*.lean, goals/*.aisp, library/Unsorry/*.lean, library/index/*.aisp, proof-runs, content-addressed statements, mathlib imports, or any task that proves, decomposes, or preserves an Unsorry theorem."
---

# Unsorry Proof Authoring

## Purpose

Use this skill to move from an Unsorry goal to a kernel-checked proof while preserving the queue metadata that makes the swarm safe. The Lean kernel is the proof authority; AISP records explain the queue state and provenance.

## Access Pattern

Start at the goal, then follow the artifacts outward:

1. Read `goals/<id>.aisp` for `phase`, `status`, `difficulty`, source path, dependencies, artifact path, and current SHA.
2. Read `goals/<id>.lean` for the exact statement. Existing goal statements are create-only; do not edit them to make a proof easier.
3. Search `library/Unsorry/` and `library/index/` for reusable proved lemmas before inventing new support lemmas.
4. If the goal is proved, put the reusable theorem in `library/Unsorry/*.lean`, update the matching index record under `library/index/`, and keep the goal metadata consistent.
5. If the goal cannot be proved within budget, prefer a decomposition record or affinity/difficulty update over weakening the statement.

Useful discovery commands:

```bash
rg -n "<goal-id>|<theorem_name>|<source phrase>" goals library library/index backlog docs
find library/Unsorry -maxdepth 1 -name '*.lean' | sort
find library/index -maxdepth 1 -name '*.aisp' | sort
```

For deeper orientation, read [references/repo-map.md](references/repo-map.md). For exact artifact relationships and mutation rules, read [references/proof-artifacts.md](references/proof-artifacts.md).

## Lean Proof Rules

- Keep `library/` at the zero-sorry bar. Do not add `sorry`, `admit`, new `axiom`s, `unsafe`, `native_decide`, `implemented_by`, `extern`, or local options that relax elaboration.
- Keep `autoImplicit = false` behavior intact. If a theorem needs binders, write them explicitly.
- Prefer mathlib lemmas and existing `Unsorry` lemmas over custom proof machinery.
- Keep imports narrow and ordinary. Import `Mathlib...` or existing `Unsorry...` modules as needed; do not create hidden trust paths.
- Do not treat a passing Gate B result as proof correctness. Gate B only validates coordination records.

## Metadata Rules

- `goals/*.aisp` is the work queue. For prove-phase goals, `lean` should point to the Lean goal file and `status` should match reality.
- `library/index/<sha>.aisp` is the content-addressed proof index. Use nearby records as the schema pattern and run Gate B after editing.
- `proof-runs/*.aisp` records terminal coordinated runs for analytics. It is not proof admission and should not be fabricated for local-only experiments.
- `claims/` on `main` must contain only `README.md`; live claim files belong on the `claims` branch.
- Source and absence evidence live in `backlog/`, `docs/targets.md`, and sourcing metadata. Preserve source paths rather than replacing them with prose.

## Validation

Choose the lightest checks that cover the touched surface, then expand if the change is proof-bearing:

```bash
lake build UnsorryLibrary --wfail
lake build UnsorryGoals
python3 -m tools.gate_b validate .
python3 -m tools.sourcing.targets_board --check .
python3 -m tools.leaderboard --check .
```

For full local confidence before a proof PR, also run:

```bash
python3 -m tools.gate_a.check_statement_binding generate .
python3 -m tools.gate_a.check_library_options library
python3 -m tools.gate_a.parallel_modules audit --jobs 1 --output axiom-report.json
```

Use `lake exe cache get` if dependencies are missing. Do not build mathlib from source unless the repository policy changes.

For command selection and failure interpretation, read [references/proof-validation.md](references/proof-validation.md).

## Pack Resources

Load these only when the task needs the extra detail:

- [references/repo-map.md](references/repo-map.md): proof-authoring map of `goals/`, `library/`, `library/index/`, `backlog/`, `proof-runs/`, and docs.
- [references/proof-artifacts.md](references/proof-artifacts.md): how Lean goals, library theorems, AISP records, hashes, and decomposition records fit together.
- [references/proof-validation.md](references/proof-validation.md): local validation matrix for proof-bearing edits.

Reusable templates live in `assets/`:

- [assets/proof-closeout-template.md](assets/proof-closeout-template.md): concise final/PR proof report.
- [assets/library-index-record.template.aisp](assets/library-index-record.template.aisp): content-addressed index record skeleton.
- [assets/decomposition-record.template.aisp](assets/decomposition-record.template.aisp): decomposition record skeleton for failed proof budgets.
