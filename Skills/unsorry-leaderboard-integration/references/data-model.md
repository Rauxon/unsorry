# Leaderboard Data Model

## Source Records

Use committed repository records as the source of truth:

- `goals/*.aisp`: goal id, status, difficulty.
- `library/index/*.aisp`: verified proof existence and optional successful-proof provenance.
- `proof-runs/*.aisp`: append-only terminal coordinated run facts.
- git add-author history for `library/index/*.aisp`: historical contributor
  visibility only, never solver credit.

`tools.leaderboard.generate.base_stats(root)` is the current aggregation function.

## Automatically Collected During Coordinated Runs

These fields can be captured without manual entry:

| Field | Source |
|---|---|
| `solver` | `gh api user --jq .login`, overrideable with `UNSORRY_SOLVER` |
| `agent` | current swarm agent id |
| `provider` | selected proof provider |
| `model` | effective provider model, when exposed |
| `effort` | resolved effort rung |
| `attempts` | proof attempts used |
| `solve_s` | proof generation plus local verification seconds |
| `outcome` | `proved`, `decomposed`, or `failed` |
| `ended` | UTC terminal timestamp |
| `sha` | proved artifact SHA, or empty for non-proof outcomes |

Goal difficulty and status are derived from `goals/*.aisp`; do not duplicate them into UI-specific source records.

## Generated After Records Change

Generators should derive:

- contributor rows;
- historical contributor rows;
- rank;
- display score;
- profile URLs;
- avatar URLs;
- badges;
- markdown table;
- machine stats JSON;
- UI contract JSON;
- attribution gaps JSON;
- optional HTML/SVG/PNG artifacts.

## Historical Attribution Boundary

The ranked leaderboard uses explicit `solver≜...` proof/run telemetry only.
Historical git attribution answers a different question: who added a proof index
file to git. That can restore community visibility for older proof artifacts, but
it must stay outside solver-provenance ranking.

Use:

- `docs/metrics/contributor-aliases.json` for reviewed git-author to GitHub
  handle mappings;
- `docs/metrics/attribution-gaps.json` as the review queue for proof index files
  missing explicit solver provenance;
- `historical_contributors` in `docs/metrics/leaderboard-ui.json` for browser
  display of historical proof index authors.

Do not write `solver≜` from git attribution automatically. Only backfill a
source proof record after human review establishes the actual solver.

## Excluded Data

Do not collect or infer:

- solver credit from git authorship, PR mergers, or squash commits;
- real names, emails, or GitHub API profile data;
- local-only smoke run results;
- infrastructure failures before a real provider attempt;
- raw model logs for public leaderboard display;
- costs, token counts, hardware, or energy data without a separate design.

## Scoring

Canonical rank should follow ADR-023:

1. verified proofs descending;
2. difficulty points descending;
3. deterministic tie-breaker.

Use display score only for UI bar length, for example:

```text
score = difficulty_points * 100 + verified_proofs * 25
```

Failed attempts should be visible but not score-positive.
