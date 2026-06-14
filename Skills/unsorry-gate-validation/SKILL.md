---
name: unsorry-gate-validation
description: "Procedures for validating or changing Unsorry's trust and hygiene gates. Use when editing Gate A or Gate B tooling, .github/workflows, AISP records, goal/source metadata, generated targets or leaderboard docs, PR protocol tooling, or any change that can affect proof admission, queue integrity, CI enforcement, sourcing, or telemetry validation."
---

# Unsorry Gate Validation

## Purpose

Use this skill when the question is "will the gates accept this, and should they?" Gate A is the soundness gate for Lean proofs. Gate B is the deterministic hygiene gate for AISP coordination records. Keep those roles separate.

## Gate Map

- Gate A: Lean trust surface. It covers `library/`, `goals/**/*.lean`, `lakefile.toml`, `lake-manifest.json`, `lean-toolchain`, `AxiomAudit/`, `AuditFixtures/`, `tools/gate_a/`, and `.github/workflows/gate-a.yml`.
- Gate B: coordination hygiene. It scans `goals/`, `claims/`, `translations/`, `decompositions/`, `library/index/`, and `proof-runs/`.
- Generated repository views: `docs/targets.md`, `docs/leaderboard.md`, `docs/metrics/community-stats.json`, and proof visualisation docs are derived from goals, index records, and run telemetry.
- Protocol tooling: `tools/repo/` enforces PR conventions and scope rules.
- Provider tooling: `tools/llm_providers/` supports the agent loop and is tested from Gate B CI.

For detailed gate behavior, load [references/gate-a-soundness.md](references/gate-a-soundness.md) or [references/gate-b-hygiene.md](references/gate-b-hygiene.md). For generated output rules, load [references/generated-artifacts.md](references/generated-artifacts.md).

## First Files To Read

For a validation-sensitive change, inspect the narrowest relevant sources before editing:

```bash
sed -n '1,220p' CLAUDE.md
sed -n '1,260p' CONTRIBUTING.md
sed -n '1,260p' tools/gate_b/README.md
sed -n '1,260p' .github/workflows/gate-a.yml
sed -n '1,220p' .github/workflows/gate-b.yml
```

If an ADR or spec is referenced in the files you touch, read that ADR/spec before changing behavior.

## Change Workflow

1. Classify the surface: soundness, hygiene, generated docs, provider plumbing, or PR protocol.
2. Find the executable tests and fixtures for that surface before editing. For gate behavior, update or add tests first.
3. Keep generated files generated. Do not manually edit generated sections unless the generator is also being changed.
4. Preserve the authority boundary: Gate B can reject malformed queue artifacts but cannot admit proofs; Gate A decides proof-bearing changes.
5. For workflow files, preserve pinned action SHAs and minimum permissions unless the change is specifically about supply-chain hardening.

## Validation Commands

For AISP record and queue changes:

```bash
python3 -m tools.gate_b validate .
python3 -m tools.gate_b validate . --json
pytest tools/gate_b -q
```

For proof-admission or Gate A changes:

```bash
lake build UnsorryLibrary --wfail
python3 -m tools.gate_a.check_statement_binding generate .
python3 -m tools.gate_a.check_library_options library
python3 -m tools.gate_a.parallel_modules audit --jobs 1 --output axiom-report.json
python3 -m tools.gate_a.parallel_modules replay --jobs 1
./tools/gate_a/test_audit.sh
```

For generated boards and analytics:

```bash
python3 -m tools.sourcing.targets_board --check .
python3 -m tools.sourcing.targets_board . > docs/targets.md
python3 -m tools.leaderboard --check .
python3 -m tools.leaderboard --write .
python3 -m tools.visualiser --check .
python3 -m tools.visualiser --write .
```

For broad tool changes:

```bash
python3 -m pytest tools -q
pytest tools/llm_providers -q
./swarm/agent.sh --self-test
```

## Common Failure Modes

- Stale generated docs after changing `goals/`, `library/index/`, or `proof-runs/`.
- Claim files accidentally committed on `main`; only `claims/README.md` belongs there.
- A goal statement edited in place instead of adding a new goal or decomposition.
- A Gate B schema mirror changed without updating `swarm/protocol.aisp` or the corresponding contract test.
- A proof passes a local build but fails statement binding, library option checks, axiom audit, or leanchecker replay.

## Reporting Results

When reporting validation status, separate:

- commands that passed,
- commands that failed and their exact artifact names,
- commands skipped because they are expensive or irrelevant,
- generated files that were rewritten.

Do not summarize "gates pass" unless the actual local equivalents for the touched surfaces were run.

## Pack Resources

Load these only when the task needs the extra detail:

- [references/gate-a-soundness.md](references/gate-a-soundness.md): Gate A trust surface, local equivalents, and failure interpretation.
- [references/gate-b-hygiene.md](references/gate-b-hygiene.md): AISP validator surface, violation families, claim rules, and schema-drift checks.
- [references/generated-artifacts.md](references/generated-artifacts.md): generated docs and metrics, source inputs, commands, and stale-output fixes.
- [references/risk-matrix.md](references/risk-matrix.md): which validation commands to run by touched path.

Reusable templates live in `assets/`:

- [assets/validation-report-template.md](assets/validation-report-template.md): concise validation summary.
- [assets/gate-change-checklist.md](assets/gate-change-checklist.md): pre-PR checklist for gate/tooling changes.
- [assets/ci-failure-triage-template.md](assets/ci-failure-triage-template.md): structured CI failure investigation note.
