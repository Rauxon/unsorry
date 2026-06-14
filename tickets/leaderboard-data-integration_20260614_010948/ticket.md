# Ticket: Connect the Contributor Leaderboard UI to Generated Unsorry Stats

## Summary

Create a project leaderboard that gamifies verified Unsorry contributions by connecting the existing `leaderboard.html` UI to the repository's generated community statistics. The implementation should rank contributors, link to GitHub profiles, display GitHub avatars, and reuse the existing proof-provenance data model rather than introducing a parallel scoring system.

## Background

The repo already has a leaderboard data pipeline:

- `tools/leaderboard/generate.py`
- `docs/leaderboard.md`
- `docs/metrics/community-stats.json`
- `library/index/*.aisp`
- `proof-runs/*.aisp`
- ADR/spec: `docs/adrs/ADR-023-Proof-Provenance-Leaderboard.md` and `docs/adrs/specs/SPEC-023-A-Proof-Provenance-Leaderboard.md`

The current untracked `leaderboard.html` is a polished static mock, but it seeds local IndexedDB with corporate placeholder data and does not yet consume Unsorry's generated statistics.

Live generator output from `python3 -m tools.leaderboard --json .` currently shows useful data:

- `90` verified proofs
- `19` attributed proofs
- `71` historical/unknown proofs
- `23` terminal proof runs
- `19` successful proofs with run telemetry
- `21.11%` proof-run coverage
- current top contributor row: `cgbarlow`, `19` verified proofs, `49` difficulty points, `23` runs, `82.61%` run success rate

The checked-in generated outputs are stale at the time this ticket was written:

```bash
python3 -m tools.leaderboard --check .
# docs/leaderboard.md, docs/metrics/community-stats.json stale — regenerate with `python3 -m tools.leaderboard --write`
```

## Goals

1. Use the existing deterministic leaderboard source of truth.
2. Populate an HTML leaderboard with real Unsorry contributor rows.
3. Link each contributor to their GitHub profile.
4. Use GitHub avatars without requiring GitHub API credentials.
5. Keep the generated data checked into the repo and drift-checked.
6. Preserve ADR-023's policy that historical/unknown proofs remain unknown and failures are visible but do not improve rank.
7. Make the page easy to host from GitHub Pages or open locally from a small static server.

## Non-Goals

- Do not infer historical solvers from git authorship or PR mergers.
- Do not use leaderboard rank in proof admission, goal selection, Gate A, or Gate B trust decisions.
- Do not require a live backend, database, or GitHub token for the public leaderboard.
- Do not block the first implementation on README image generation.
- Do not manually maintain leaderboard rows.

## Proposed Implementation

### Phase 1: Data-backed HTML leaderboard

1. Regenerate the current stats:

   ```bash
   python3 -m tools.leaderboard --write .
   ```

2. Add a UI-facing generated JSON file, either by extending `tools/leaderboard/generate.py` or by adding a small adapter module:

   ```text
   docs/metrics/leaderboard-ui.json
   ```

   Suggested row shape:

   ```json
   {
     "schema_version": 1,
     "generated_from": "docs/metrics/community-stats.json",
     "contributors": [
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
     ]
   }
   ```

3. Replace `leaderboard.html` mock seed data with a fetch from the generated JSON.

   Recommended hosting path:

   - Move or generate the final page as `docs/leaderboard.html`.
   - Fetch `metrics/leaderboard-ui.json` relative to that page.
   - Keep `docs/leaderboard.md` as the GitHub-rendered markdown view.

4. Map the current HTML fields to Unsorry data:

   | Current field | Unsorry field |
   |---|---|
   | `id` | GitHub solver login |
   | `name` | `@solver` unless a later optional profile-name source exists |
   | `avatar` | `https://github.com/<solver>.png?size=96` |
   | `volume` | `score` |
   | `badges.kudos` | verified proofs |
   | `badges.trophies` | difficulty points |
   | `badges.trend` | run success rate or recent successes |

5. Add tests for the UI adapter:

   - deterministic ordering,
   - score calculation,
   - avatar/profile URL generation,
   - empty contributor list,
   - unknown historical proofs excluded from contributor rows,
   - schema version included.

6. Add or wire drift checks:

   ```bash
   python3 -m tools.leaderboard --check .
   ```

   If `leaderboard-ui.json` or `docs/leaderboard.html` are generated, their generator should also support `--write` and `--check`.

### Automatic collection vs generated artifacts

The leaderboard should use three layers of information.

Layer 1: collected automatically during coordinated runs:

- solver GitHub handle from `gh api user`, or `UNSORRY_SOLVER` when explicitly set;
- swarm agent id;
- provider id;
- effective model when exposed by the provider wrapper;
- final effort rung;
- attempts used;
- proof/local-verification duration as `solve_s`;
- terminal outcome: `proved`, `decomposed`, or `failed`;
- completion timestamp;
- proved artifact SHA when a proof lands.

Layer 2: already present in repository source records:

- goal id, status, and difficulty from `goals/*.aisp`;
- verified proof existence and optional successful-proof provenance from `library/index/*.aisp`;
- terminal run facts from `proof-runs/*.aisp`;
- queue and difficulty distributions from the goal records.

Layer 3: generated after records change:

- `docs/metrics/community-stats.json`;
- `docs/leaderboard.md`;
- proposed `docs/metrics/leaderboard-ui.json`;
- proposed `docs/leaderboard.html`;
- optional `docs/leaderboard.svg` or `docs/leaderboard.png`.

Historical proofs without provenance must remain `historical/unknown`. Do not backfill them from git authors, PR mergers, or guesses.

### HTML data contract

The HTML should consume a stable, generated connection interface rather than the raw internal stats object. Proposed contract:

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

Each contributor row should include:

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

This is "true" for the HTML connection if it is generated deterministically from `base_stats(root)` and tested. The HTML should not calculate rank, profile URLs, avatar URLs, or score policy on its own except as a defensive fallback.

### Automatic wiring process

Recommended end-to-end process:

1. Coordinated proof run finishes.
2. `swarm/agent.sh` records proof provenance in `library/index/*.aisp` for successes and appends terminal facts under `proof-runs/*.aisp` for durable outcomes.
3. Gate B validates the new metadata with `GB019` and `GB020`.
4. The proof/decomposition/failure PR includes the source telemetry records.
5. A generator step runs:

   ```bash
   python3 -m tools.leaderboard --write .
   ```

6. `--write` regenerates markdown, machine stats, UI JSON, and the HTML/SVG outputs once they are implemented.
7. CI or a required local check runs:

   ```bash
   python3 -m tools.leaderboard --check .
   ```

8. README links to the markdown/HTML page, and optionally embeds a generated SVG/PNG preview.

The best automation target is to make `tools.leaderboard --write` the single command that refreshes every leaderboard artifact, and `tools.leaderboard --check` the single command that detects drift.

### Phase 2: README image or badge renderer

Investigate a static generated asset for README use. GitHub README markdown cannot execute JavaScript, so the interactive HTML cannot be embedded directly.

Preferred low-dependency option:

- Generate `docs/leaderboard.svg` from the same stats using pure Python string rendering.
- Embed it in the README:

  ```markdown
  [![Unsorry leaderboard](docs/leaderboard.svg)](docs/leaderboard.html)
  ```

Alternative richer option:

- Use Playwright or another headless browser in CI to screenshot `docs/leaderboard.html` into `docs/leaderboard.png`.
- This produces the closest match to the HTML design but adds browser tooling and CI complexity.

Phase 2 should be implemented only after Phase 1 is stable.

## Scoring Recommendation

Use ADR-023's existing rank policy as the canonical rank:

1. Higher `verified_proofs`
2. Higher `difficulty_points`
3. Lower median solve time or alphabetical solver as deterministic tie-breaker

For the visual bar length, use a separate display score:

```text
score = difficulty_points * 100 + verified_proofs * 25
```

Keep failures and attempts visible as badges/secondary metrics, but do not let failed attempts increase rank or score. This avoids rewarding noisy repeated failure while still recognizing effort in the detailed stats.

## Acceptance Criteria

- `docs/metrics/community-stats.json` is current and generated from source records.
- The ticket's automatic collection boundary is implemented: run telemetry is captured by coordinated runs, and presentation artifacts are generated from committed records.
- `docs/metrics/leaderboard-ui.json` exists, is deterministic, and follows a documented schema.
- A browser-visible leaderboard page displays real contributor data instead of placeholder people.
- Contributor rows link to `https://github.com/<solver>`.
- Contributor rows use `https://github.com/<solver>.png?size=96` avatars.
- The data source is deterministic and checked into the repo.
- Unknown historical proofs remain reported as unknown rather than attributed.
- Tests cover the UI data adapter or generator path.
- `python3 -m tools.gate_b validate .` validates proof-run and index provenance records used by the leaderboard.
- `python3 -m tools.leaderboard --check .` passes after regeneration.
- README image generation is either implemented as a follow-up or explicitly deferred with a documented path.

## Open Questions

- Should `leaderboard.html` be moved into `docs/leaderboard.html` for GitHub Pages hosting?
- Should the HTML consume `docs/metrics/community-stats.json` directly, or should the generator emit a UI-specific `leaderboard-ui.json`?
- Should `tools.leaderboard --write` own `docs/leaderboard.html`, or should the HTML be manually maintained while only the JSON is generated?
- Should proof/decomposition PR creation automatically regenerate leaderboard artifacts, or should CI only detect drift and require a follow-up generated-artifacts PR?
- Should score be displayed as an explicit "points" number, or should rank remain proof-first with points only used for bar width?
- Should `docs/leaderboard.svg` be generated in Phase 1 as a simple README preview, or deferred until after the interactive page lands?
- Should leaderboard drift checking be added to an existing CI workflow, and does that touch CODEOWNERS-protected workflow surfaces?

## Suggested Validation

```bash
python3 -m tools.leaderboard --write .
python3 -m tools.leaderboard --check .
python3 -m pytest tools/leaderboard -q
python3 -m tools.gate_b validate .
```

If an HTML/SVG generator is added:

```bash
python3 -m tools.leaderboard --check .
```

should include the new generated artifact drift checks, or a new explicit check command should be documented.
