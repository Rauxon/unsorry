# SPEC-037-A: Corroborated Solver Provenance (Phantom-Attribution Guard)

Implements: [ADR-037](../ADR-037-Corroborated-Solver-Provenance.md) · Relates to [SPEC-023-A](SPEC-023-A-Proof-Provenance-Leaderboard.md) · Status: Living · Updated: 2026-06-14

## Definition

A proved `library/index/*.aisp` record with an explicit `⟦Π:Provenance⟧{solver≜X; …}` is a
**phantom attribution** when `X` (casefolded) is corroborated by **none** of:

1. **proof-runs telemetry** — `X` equals a `solver≜` in any `proof-runs/*.aisp` record
   (the agent's machine-captured solver, for any goal);
2. **git add-author** — `X` equals the alias-resolved github handle, or the raw author
   name, of the git commit that first added the index record (`git log --diff-filter=A`);
3. **contributor-alias** — `X` equals a `github` value in `docs/metrics/contributor-aliases.json`.

A record with **no** `solver≜` is *not* a phantom — that is a missing-provenance gap,
already tracked in `attribution-gaps.json` (SPEC-023-A). Corroboration is **global**, not
per-goal: a contributor with a footprint on any goal is real.

## API

In `tools/leaderboard/generate.py`:

- `provenance_phantoms(root, data=None) -> list[dict]` — returns the phantom records
  (`path`, `sha`, `goal`, `solver`, `git_author`, `git_author_name`, `git_add_commit`),
  sorted by path. Reuses `load_dataset`, `git_add_authors`, `contributor_aliases`,
  `_alias_for`, `_valid_github_handle`.
- `_corroborated_handles(root, data) -> set[str]` — the casefolded handle set from
  proof-runs + alias github values.
- CLI: `python3 -m tools.leaderboard --audit-provenance [<root>]` — prints the phantoms
  (human-readable, to stderr) and exits **1** if any, **0** if clean. Mutually standalone
  (handled before the `--check`/`--write`/`--json` modes).

## CI

`.github/workflows/attribution-advisory.yml` — **advisory, non-blocking** (mirrors
`triviality.yml`, ADR-035). On `pull_request` touching `library/index/**`, `proof-runs/**`,
or `docs/metrics/contributor-aliases.json`:

1. checkout `fetch-depth: 0` (git-author corroboration needs history);
2. run `tools.leaderboard --audit-provenance .`;
3. post/update a sticky `<!-- attribution-advisory -->` comment — ✅ when clean, or the
   phantom list + remediation when not.

The job always exits 0. **Do NOT** add it to branch protection's required checks
(ADR-023: self-reported provenance must not gate admission). Because `main` is kept
phantom-free, a phantom on a PR head was introduced by that PR.

## Acceptance criteria

1. `provenance_phantoms` flags `solver≜X` with no proof-run / git-author / alias
   corroboration, and does **not** flag one corroborated by any of the three, nor a
   record with no `solver≜`.
2. `--audit-provenance` exits 1 with a phantom present, 0 when clean.
3. `attribution-advisory.yml` is valid, pinned (ADR-019), `pull-requests: write`,
   triggered on the three provenance-input paths, and never fails the run.
4. The `tools/leaderboard` suite stays green; `main` audits clean after #431.

## Remediation

Set `solver≜` to the real solver's handle (cross-check the goal's `proof-runs/` telemetry
and the prove commit's git author), or — for a legitimate solver with no repo footprint —
add them to `docs/metrics/contributor-aliases.json`.
