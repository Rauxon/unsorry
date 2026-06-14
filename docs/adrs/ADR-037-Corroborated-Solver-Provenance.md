# ADR-037: Corroborated Solver Provenance — a Phantom-Attribution Guard

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-037 |
| **Initiative** | unsorry — leaderboard / contributor-attribution integrity |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

The leaderboard (ADR-023) and the proofs-and-contributors visualisation (ADR-032)
credit each proof to the **self-reported `solver≜`** field in its `library/index/*.aisp`
record — explicit provenance is authoritative, with git-add-author inference used only
when `solver≜` is absent.

Because `solver≜` is hand-written by whoever generates the index record, a typo or a
stale placeholder is silently load-bearing for credit. This happened: two of Adam Holt's
proofs (`nat-sq-lt-two-pow`, `four-consecutive-product-add-one-square-s3`) carried
`solver≜kev` — a handle that appears **nowhere else** in the repo (no `proof-runs/`
telemetry, no git identity, no alias). The leaderboard dutifully credited a phantom
"kev" with the verified proofs while Adam (`adam91holt`) sat at 0 verified, buried
(#431). Nothing flagged the inconsistency, even though Adam's own machine-captured run
telemetry (`proof-runs/…`) recorded `solver≜adam91holt` for the very same goals — the
two records disagreed and no check noticed.

`solver≜` is self-reported metadata and must **not** gate proof admission, affinity, or
ranking (ADR-023), so a hard build gate is the wrong instrument. But an *uncorroborated*
solver is a detectable data-quality defect: a real contributor leaves a footprint — a
proof-run, a git identity, or an alias — and a handle with none is almost certainly
wrong.

## WH(Y) Decision Statement

**In the context of** a leaderboard/visualiser that credits proofs to a hand-written
`solver≜` field,
**facing** the fact that a typo or placeholder in that field silently mis-credits a real
solver with no signal (the `solver≜kev` incident, #431), even when the goal's own
`proof-runs/` telemetry records the correct handle,
**we decided for** a **corroboration check** (`tools.leaderboard.provenance_phantoms` /
`--audit-provenance`): a proof's `solver≜X` is a *phantom* unless `X` is corroborated by a
real footprint — a `solver≜X` in any `proof-runs/` record, the record's git add-author
(alias-resolved name or github handle), or a `contributor-aliases.json` github mapping —
surfaced by a **non-blocking `attribution-advisory.yml` CI check** (a sticky advisory
comment on PRs touching `library/index/`, `proof-runs/`, or the alias file) and an
on-demand audit,
**and neglected** a hard gate (rejected — ADR-023 forbids self-reported provenance from
blocking admission, and a legitimate cross-credit to a pair-partner who didn't run the
swarm could be a false positive), auto-rewriting `solver≜` to the git author (rejected —
the git author is the *committer*, not necessarily the solver; corrections must be
deliberate), and corroborating only against same-goal proof-runs (rejected — too strict;
a contributor with a footprint on *other* goals is still real, e.g. an untelemetered
recompose leaf),
**to achieve** that a phantom solver attribution is caught at PR time and in the
post-merge audit, so credit lands on real contributors,
**accepting that** the check is advisory (a determined typo can still merge — but it is
now visible and reviewable), that it needs git history (`fetch-depth: 0`) for git-author
corroboration, and that a genuine cross-credit to someone with no repo footprint must be
resolved by adding them to `contributor-aliases.json`.

## Consequences

- **Positive.** Phantom/typo solver attributions are surfaced before they bury a real
  contributor; the leaderboard and the #371 visualiser (which share the provenance) both
  benefit; the audit is a fast pure-Python check (no Lean build).
- **Negative.** Advisory-only, so it informs rather than enforces; a legitimate solver
  with zero repo footprint must be alias-mapped to clear the flag.
- **Complements** ADR-023 (the provenance/credit model) and the missing-solver review
  queue in `attribution-gaps.json`; the immediate `solver≜kev → adam91holt` data fix is #431.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Phantom-solver guard spec | Specification | specs/SPEC-037-A-Corroborated-Solver-Provenance.md |
| REF-2 | Proof-provenance leaderboard (the credit model) | Decision | ADR-023-Proof-Provenance-Leaderboard.md |
| REF-3 | Proofs-and-contributors visualiser (shares the provenance) | Decision | ADR-032-Proof-Graph-Visualiser.md / issue #371 |
| REF-4 | The incident (Adam Holt mis-credited to "kev") | PR/Issue | https://github.com/agenticsnz/unsorry/pull/431 |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
