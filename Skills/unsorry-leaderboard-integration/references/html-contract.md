# Leaderboard HTML Contract

## Preferred File

Generate a stable UI payload:

```text
docs/metrics/leaderboard-ui.json
```

The browser page should fetch it relative to `docs/leaderboard.html`:

```js
const response = await fetch('metrics/leaderboard-ui.json', { cache: 'no-store' });
```

Avoid raw GitHub URLs unless relative hosting is impossible.

## Top-Level Shape

```json
{
  "schema_version": 1,
  "generated_from": "docs/metrics/community-stats.json",
  "generated_at": "2026-06-14T00:00:00Z",
  "score_policy": "rank by verified_proofs desc, difficulty_points desc; score = difficulty_points * 100 + verified_proofs * 25",
  "summary": {
    "verified_proofs": 90,
    "attributed_proofs": 19,
    "historical_unknown_proofs": 71,
    "terminal_runs": 23,
    "proof_run_coverage": 0.2111
  },
  "contributors": []
}
```

## Contributor Row

```json
{
  "rank": 1,
  "solver": "cgbarlow",
  "display_name": "@cgbarlow",
  "profile_url": "https://github.com/cgbarlow",
  "avatar_url": "https://github.com/cgbarlow.png?size=96",
  "score": 5375,
  "verified_proofs": 19,
  "difficulty_points": 49,
  "runs": 23,
  "successes": 19,
  "run_success_rate": 0.8261,
  "attempt_yield": 0.4872,
  "failed_attempts": 20,
  "median_solve_s": 547,
  "badges": {
    "proofs": 19,
    "difficulty": 49,
    "success_rate_percent": 82.61
  }
}
```

## Mapping To Current HTML

| Current field | UI payload field |
|---|---|
| `id` | `solver` |
| `name` | `display_name` |
| `avatar` | `avatar_url` |
| `volume` | `score` |
| `badges.kudos` | `badges.proofs` |
| `badges.trophies` | `badges.difficulty` |
| `badges.trend` | `badges.success_rate_percent` |

Replace money labels with proof-point labels. Keep GitHub profile links on names or avatars.

## Browser Responsibilities

The browser should:

- fetch the JSON;
- verify `schema_version` is supported;
- render rows;
- show an empty state when there are no attributed contributors;
- show a concise error state when fetch fails.

The browser should not be the canonical rank or score calculator.
