# Leaderboard Data Model

## Source Records

Use committed repository records as the source of truth:

- `goals/*.aisp`: goal id, status, difficulty.
- `library/index/*.aisp`: verified proof existence and optional successful-proof provenance.
- `proof-runs/*.aisp`: append-only terminal coordinated run facts.
- git add-author history for `library/index/*.aisp`: inferred proof credit only
  when explicit solver provenance is missing.

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

The ranked leaderboard uses credited verified proofs. Explicit `solver≜...`
proof telemetry wins. If a proof index record lacks solver provenance, git
add-author attribution may provide inferred historical credit. Generated rows
must keep explicit and inferred counts visible.

Use:

- `docs/metrics/contributor-aliases.json` for reviewed git-author to GitHub
  handle mappings;
- `docs/metrics/attribution-gaps.json` as the review queue for proof index files
  missing explicit solver provenance;
- `contributors` in `docs/metrics/leaderboard-ui.json` as the unified gamified
  ranking, including explicit and inferred proof-credit counts.

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
