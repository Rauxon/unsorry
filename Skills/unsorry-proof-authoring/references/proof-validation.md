# Proof Validation Matrix

## Minimal Metadata Check

Use after editing AISP records or generated proof metadata:

```bash
python3 -m tools.gate_b validate .
python3 -m tools.sourcing.targets_board --check .
python3 -m tools.leaderboard --check .
```

## Proof-Bearing Check

Use after editing `library/Unsorry/*.lean`, `goals/*.lean`, `lakefile.toml`, or proof-admission tooling:

```bash
lake build UnsorryLibrary --wfail
python3 -m tools.gate_a.check_statement_binding generate .
python3 -m tools.gate_a.check_library_options library
python3 -m tools.gate_a.parallel_modules audit --jobs 1 --output axiom-report.json
```

Run `python3 -m tools.gate_a.parallel_modules replay --jobs 1` when local resources allow and the change is trust-bearing.

## Goal Build Check

Use when goal files changed or a proof imports goal-facing modules:

```bash
lake build UnsorryGoals
```

Sorries are expected in `goals/`; they are not acceptable in `library/`.

## Broad Tool Check

Use when touching Python tooling, generators, or validators:

```bash
python3 -m pytest tools -q
```

If this is too broad for the current task, run the narrow package test and report that broader tests were not run.

## Failure Interpretation

- Lean build failure: inspect the first elaboration error and imports; do not edit the goal statement to make it pass.
- Statement binding failure: the library theorem no longer proves the exact goal type.
- Gate B `GB006`: index SHA or proved-goal linkage is inconsistent.
- Generated doc stale: run the matching generator only if the source data change is intentional.
- Axiom audit failure: remove the trust-bearing construct; do not expand the whitelist for a proof.
