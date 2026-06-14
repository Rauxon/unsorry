# Gate B Hygiene

## What Gate B Protects

Gate B protects the work queue and coordination metadata. It does not prove mathematics and cannot admit a theorem into `library/`.

Scanned directories:

- `goals/`
- `claims/`
- `translations/`
- `decompositions/`
- `library/index/`
- `proof-runs/`

Directories such as `tools/`, `docs/`, `swarm/`, and `.git/` are not scanned by the Gate B validator.

## Core Commands

```bash
python3 -m tools.gate_b validate .
python3 -m tools.gate_b validate . --json
pytest tools/gate_b -q
```

Use `--at ISO8601Z` for deterministic claim freshness checks and `--goals-root PATH` when validating a claims-only tree.

## Violation Families

- Header and grammar violations: malformed AISP records or identity mismatches.
- Goal artifact violations: bad phase/status/difficulty, missing Lean file, inconsistent SHA, missing index.
- Dependency violations: missing goal references or malformed decomposition edges.
- Source violations: missing `src` path.
- Claim violations: bad filename, stale TTL, duplicate live claims, claim files on `main`.
- Index violations: filename/SHA/statement mismatch or malformed proof provenance.
- Proof-run violations: malformed terminal run identity, attribution, timing, outcome, or artifact link.

## Schema Drift

`swarm/protocol.aisp` is normative for the swarm contract. `tools/gate_b/config.py` mirrors constants from the contract, and tests should catch drift. If a contract field changes, update the mirror and the tests together.

## Claims Rule

On `main`, `claims/` should contain only `README.md`. Live claims belong on the `claims` branch. A file such as `claims/<goal-id>.<agent-id>.aisp` on `main` is a Gate B violation.
