# SPEC-018-A: Goal-Statement Immutability

Implements: [ADR-018](../ADR-018-Goal-Statement-Immutability.md) · Status: Living · Updated: 2026-06-12

## The rule

Once a `goals/*.lean` file exists at a PR's base ref, the PR may not modify, delete, rename, or typechange it. Creation (`A`, and the new side of `C*`) is the only legitimate write. Goal *records* (`goals/*.aisp`) are out of scope — they change legitimately and Gate B recomputes their statement shas from the pinned `.lean`.

## Enforcement

`tools/gate_a/check_goal_immutability.py`:

- pure core `violations(lines)` over `git diff --name-status` output: rejects `M`/`D`/`T` on a pinned path and `R*` whose *old* side is pinned (the new side is creation);
- CLI `--base <sha> [--repo <dir>]` runs `git diff --name-status <base>...HEAD -- goals/`; exit 0 clean · 1 violations (each printed, plus a `::error::` explaining the new-goal-id rule) · 2 git/usage error.

gate-a.yml invokes it immediately after checkout (before the build — fail fast), under `detect.lean == 'true' && pull_request`. The detect filter includes `goals/**/*.lean`, so any change to a pinned file forces the full gate; checkout uses `fetch-depth: 0`, so the base ref is always present.

## The legitimate-fix path

A wrong statement is never edited: seed a **new goal id** with the corrected statement and abandon the old goal (demote below τ_v, or leave unclaimed). Deliberate friction — an editable statement history is precisely the #190 tampering surface.

## Acceptance criteria

`tools/gate_a/tests/test_check_goal_immutability.py` (10 tests): M/D/T/R rejected on pinned paths; `A` and `C*` allowed; `.aisp` edits allowed; non-goal paths ignored; mixed diffs report only violations; CLI integration against a real temporary git repository (creation → exit 0, tamper → exit 1 naming the file).

Red-team proof: round 003 (`docs/metrics/gate-a-redteam-003.md`) — a real adversarial PR replaying the #190 attack (consistent weakening of a proved goal across `.lean`, record sha, index entry, and proof) must go red on this step.
