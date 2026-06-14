# SPEC-033-A: Non-Trivial Theorem Enforcement

Implements: [ADR-033](../ADR-033-Non-Trivial-Theorem-Enforcement.md) · Status: Living · Updated: 2026-06-14 · Refines [SPEC-012-A](SPEC-012-A-Backlog-Sourcing.md)

## The probe

`tools/sourcing/check_triviality.py` builds a probe module — the [ADR-011](../ADR-011-Statement-Binding-Gate.md) binding template with the proof term replaced by a tactic block, and `import Mathlib` (the full library, so a renamed duplicate is in scope) in place of the proving module:

```lean
import Mathlib
<open_lines(goal)>
set_option linter.unusedVariables false in
theorem <theorem_name(goal)>_triviality_probe : <foralltype(goal)> := by
  first | rfl | trivial | decide | norm_num | omega | simp | simp_all | aesop | ring | linarith | tauto
```

`foralltype` / `open_lines` / `theorem_name` are reused verbatim from `tools/lean_sig.py`, so the probe elaborates the **same** closed statement the binding gate asserts — a `trivial` verdict means trivial *as stated*. The module is written to a tempdir and elaborated via an injectable runner (default `lake env lean <file>`, cwd = repo root), mirroring the `Runner = subprocess.run` pattern of `tools/gate_a/parallel_modules.py` so tests stay hermetic.

`TACTIC_BATTERY` is a module constant (the single source of truth). `native_decide` is excluded (forbidden in `library/`, platform-nondeterministic). The default probe is one combined `first | …` build (the gate); `--per-tactic` runs N single-tactic builds and reports `closed_by` (used by the retro-audit).

## Verdict trichotomy (`classify`)

| build result | verdict | exit | meaning |
|---|---|:--:|---|
| returncode 0 | `trivial` | 1 | a battery tactic closed it → reject |
| non-zero, elaboration-error signature (`unknown identifier/constant/tactic`, `unexpected token`, `function expected`, …) | `probe-error` | 2 | the statement failed to elaborate (import/open gap) → surface, do not admit |
| non-zero, otherwise (unsolved goals / tactic failure) | `non-trivial` | 0 | elaborated, nothing closed it → admit-eligible |

A `subprocess.TimeoutExpired` is classified `non-trivial` (conservative: admits rather than falsely rejects). The verdict dict records `mathlib_rev` (reused `manifest_rev`) so a triviality claim is rev-dated like an absence claim.

## Downgrades (false-positive handling)

A `trivial` verdict is downgraded (→ admit) when either holds:
- the goal id is on `tools/sourcing/triviality_allowlist.txt` (intentional fixtures; → `allowlisted`), or
- `backlog/<id>.md` carries a `- **Nontrivial-override:** <reason> (approved-by <who>, <date>)` line (→ `override`, reason recorded). Gate B does not validate backlog md and `targets_board._FIELD_RE` already reads `- **Field:**` lines, so this adds no schema churn.

## Gates (three postures)

1. **Sourcing admission** — after the goal type-checks (SPEC-012-A §3), run the probe; admit only on `non-trivial`/`allowlisted`/`override`. Record `- **Triviality:** machine-checked non-trivial (battery v1, rev <sha>, <date>)` in `backlog/<id>.md`, parallel to `- **Absence:**`. **Advisory-first one cycle, then block.**
2. **CI backstop** — `.github/workflows/triviality.yml`, on `pull_request`, changed `goals/**/*.lean` only (reuse the gate-a `dorny/paths-filter` `detect` pattern + `git diff --name-only base...HEAD`). **Non-blocking** (sticky PR comment, like gate-a's axiom-footprint comment); pinned action SHAs (ADR-019); `lake exe cache get`; the `max_safe_jobs`/swap memory discipline.
3. **Retro-audit** — `check_triviality --all` over `goals/*.lean`, report-only (`docs/triviality-audit.md` + `.json`). **Never deletes**, never touches a proved goal's kernel-verified library entry.

## Acceptance criteria

1. `test_probe_module_is_canonical` / `test_probe_module_carries_open_commands` — byte-exact probe text (incl. opens travelling) from a fixture goal.
2. `test_classify_*` — the trichotomy: returncode 0 ⇒ `trivial`; unsolved-goals ⇒ `non-trivial`; elaboration-error ⇒ `probe-error`.
3. `test_per_tactic_reports_closer` — per-tactic mode reports which tactic closed it.
4. `test_timeout_is_non_trivial` — a timeout ⇒ `non-trivial`.
5. `test_allowlist_downgrades_trivial` / `test_override_field_downgrades_trivial` — downgrades to `allowlisted` / `override`.
6. `test_main_exit_codes` / `test_json_verdict_deterministic` — exit codes (1 trivial / 0 admit) and byte-identical repeated verdicts.
7. Integration (real lake+mathlib): a trivial fixture (`n*0=0`, closed by `simp`/`decide`) ⇒ `trivial`; a known non-trivial goal ⇒ `non-trivial`.

## Out of scope (noted as future)

An `exact?`/`apply?` "Try this:" membership probe and the `LeanSearchClient` semantic signal (both version-sensitive / network) — the MVP relies on `simp`/`aesop` + the existing grep/Loogle absence check. Automated removal of flagged existing theorems (human-approved, separate). Promoting the CI check to required (after the battery proves low-false-positive in practice).
