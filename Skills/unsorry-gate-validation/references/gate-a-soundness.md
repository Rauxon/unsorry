# Gate A Soundness

## What Gate A Protects

Gate A protects the verified Lean library. It is the only gate that can admit a proof-bearing change.

Primary surfaces:

- `library/**`
- `goals/**/*.lean`
- `lakefile.toml`
- `lake-manifest.json`
- `lean-toolchain`
- `AxiomAudit/**`
- `AuditFixtures/**`
- `tools/gate_a/**`
- `.github/workflows/gate-a.yml`

## CI Sequence

The workflow does roughly this:

1. Detect Lean-relevant paths.
2. Check goal-statement immutability for PRs.
3. Build `UnsorryGoals`.
4. Regenerate statement-binding obligations.
5. Build `UnsorryLibrary --wfail`.
6. Run axiom audit.
7. Run leanchecker replay.
8. Run audit self-test.
9. Scan for forbidden library options and forbidden added tokens.

## Local Equivalents

```bash
python3 -m tools.gate_a.check_goal_immutability --base <base-sha>
lake build UnsorryGoals
python3 -m tools.gate_a.check_statement_binding generate .
lake build UnsorryLibrary --wfail
python3 -m tools.gate_a.parallel_modules audit --jobs 1 --output axiom-report.json
python3 -m tools.gate_a.parallel_modules replay --jobs 1
./tools/gate_a/test_audit.sh
python3 -m tools.gate_a.check_library_options library
```

Use the commands that match the touched surface. Run the whole sequence for trust-bearing changes.

## Failure Interpretation

- Goal immutability failure: an existing `goals/*.lean` statement changed. Create a new goal or decomposition instead.
- Statement-binding failure: the proved library theorem does not inhabit the exact goal type.
- `--wfail` failure: warnings are treated as failures for the verified library.
- Axiom audit failure: a proof introduced a non-whitelisted axiom or trust-bearing construct.
- Replay failure: kernel replay did not accept compiled artifacts.
- Forbidden option failure: a file relaxed elaboration or used a banned construct.

## Editing Guidance

Do not weaken Gate A to make a proof pass. If a gate test is wrong, add a failing fixture or unit test first, then fix the checker.
