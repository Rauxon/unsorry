# Discussion: Contributor Leaderboard Data, Gamification, and README Rendering

## Current Situation

There are two separate things in the repo today:

1. A real statistics pipeline:
   - `tools/leaderboard/generate.py`
   - `docs/metrics/community-stats.json`
   - `docs/leaderboard.md`
   - source records in `library/index/*.aisp` and `proof-runs/*.aisp`

2. A new `leaderboard.html` UI mock:
   - visually polished,
   - currently untracked,
   - uses placeholder corporate names,
   - seeds local IndexedDB with static `volume` data,
   - has no connection to Unsorry's generated stats.

The best engineering path is to keep the existing stats pipeline as the source of truth and adapt the HTML to consume generated JSON. Creating a second data source would create drift and would contradict ADR-023's provenance design.

## Existing Leaderboard Information

ADR-023 already defines the project policy:

- provenance is optional and recorded beside successful library index entries;
- terminal proof-run facts are append-only records under `proof-runs/`;
- historical/unknown proofs stay unknown;
- infrastructure failures are excluded;
- local-only smoke runs are excluded;
- leaderboard values are analytics only, not trust inputs;
- rank uses verified proof count, then difficulty points;
- failed effort is visible but does not improve rank.

`tools/leaderboard/generate.py` currently produces:

- `coverage`
- `outcomes`
- `outcome_counts`
- `queue`
- `contributors`
- `models`
- `difficulty`
- `effort`
- `daily`
- `goal_effort`
- `recent_runs`

The live generated data is richer than the checked-in generated files at the moment. Running:

```bash
python3 -m tools.leaderboard --json .
```

shows:

- `90` verified proofs
- `19` attributed proofs
- `71` historical/unknown proofs
- `23` logged terminal runs
- `19` successful proofs with run telemetry
- one current attributed contributor, `cgbarlow`

But:

```bash
python3 -m tools.leaderboard --check .
```

reports:

```text
docs/leaderboard.md, docs/metrics/community-stats.json stale — regenerate with `python3 -m tools.leaderboard --write`
```

So a first implementation should start by regenerating and drift-checking the existing outputs before adding a new visual surface.

## Recommended Data Flow

Use this flow:

```text
library/index/*.aisp + proof-runs/*.aisp + goals/*.aisp
  -> tools/leaderboard/generate.py
  -> docs/metrics/community-stats.json
  -> docs/metrics/leaderboard-ui.json
  -> docs/leaderboard.html
  -> optional docs/leaderboard.svg or docs/leaderboard.png
```

The UI can technically consume `community-stats.json` directly. A small UI-specific adapter is still cleaner because the HTML wants fields like `rank`, `score`, `avatar_url`, `profile_url`, and display badges. Those are presentation fields, not core statistical facts.

## What Can Be Collected Automatically

The run harness can collect these fields without human input during coordinated proof work:

| Field | How it is collected | Where it belongs |
|---|---|---|
| Solver GitHub login | `gh api user --jq .login`, overrideable with `UNSORRY_SOLVER` | `library/index/*.aisp` provenance and `proof-runs/*.aisp` |
| Agent id | current swarm agent id | `proof-runs/*.aisp`; successful index provenance |
| Provider | selected provider (`claude`, `codex`, `gemini`, `openai`) | provenance and run records |
| Model | provider wrapper exposes effective model when known | provenance and run records |
| Effort | resolved effort rung | provenance and run records |
| Attempts | proof attempt count used by the loop | provenance and run records |
| Solve time | local proof generation plus local verification duration | provenance and run records as `solve_s` |
| Terminal outcome | proof loop outcome: `proved`, `decomposed`, or `failed` | `proof-runs/*.aisp` |
| End timestamp | UTC completion time | `proof-runs/*.aisp` |
| Proved SHA | content-addressed proof artifact when success lands | index record and run artifact block |
| Goal difficulty/status | parsed from committed goal records | generated stats, not duplicated in run record |
| GitHub profile URL | deterministic from solver handle | generated UI JSON |
| GitHub avatar URL | deterministic from solver handle | generated UI JSON |

This is enough for rank, badges, profile links, model/provider stats, effort stats, daily trends, and recent activity.

## What Should Be Generated Per Run

A coordinated run should generate source telemetry, not presentation data.

For a successful proof:

- update or create the proved `library/index/*.aisp` entry with optional provenance;
- append a `proof-runs/*.aisp` terminal fact with outcome `proved`;
- include attempts, solve time, provider, model, effort, solver, agent, ended timestamp, and proof SHA.

For exhausted proof budget with accepted decomposition:

- append a `proof-runs/*.aisp` terminal fact with outcome `decomposed`;
- include the same attribution and metrics fields;
- include `sha≜∅` because no proof artifact was produced.

For exhausted proof budget without decomposition:

- append a `proof-runs/*.aisp` terminal fact with outcome `failed`;
- include the same attribution and metrics fields;
- include advisory lessons only if the run already emits them.

For local-only smoke runs:

- do not write leaderboard telemetry.

For infrastructure failures before a real provider attempt:

- do not write leaderboard telemetry.

The aggregate markdown, JSON, HTML, and image files should not be hand-written during the run. They should be regenerated from committed records.

## What Should Not Be Collected Automatically

Avoid these unless a separate ADR/spec covers them:

- real names from GitHub profiles;
- email addresses;
- GitHub API profile metadata;
- token counts, cost, hardware, or energy data;
- every raw model attempt log;
- leaderboard credit inferred from git commit author, PR merger, or squash author;
- local-only experiments;
- infrastructure outages as model or contributor failures.

These omissions keep the public leaderboard deterministic, privacy-light, and aligned with ADR-023.

## Automatic Process

The desired process is:

```text
coordinated run
  -> source records written by swarm/agent.sh
  -> Gate B validates provenance and terminal-run facts
  -> tools.leaderboard --write regenerates all leaderboard outputs
  -> tools.leaderboard --check guards drift
  -> HTML fetches generated UI JSON
  -> README links to HTML and optionally embeds generated SVG/PNG
```

There are two reasonable automation policies.

### Policy A: include generated leaderboard artifacts in each proof PR

Every proof/decomposition/failure PR that changes `library/index/` or `proof-runs/` also runs:

```bash
python3 -m tools.leaderboard --write .
```

Pros:

- main branch always carries fresh leaderboard assets;
- no follow-up bot PRs;
- contributor sees the leaderboard update in their PR.

Cons:

- proof PRs include generated docs churn;
- merge conflicts become more likely during concurrent proof runs.

### Policy B: CI detects drift, scheduled/bot PR refreshes artifacts

Proof PRs commit source telemetry only. CI or a scheduled job regenerates leaderboard outputs and opens a generated-artifacts PR.

Pros:

- proof PRs stay smaller;
- concurrent proof runs conflict less often.

Cons:

- leaderboard can lag behind source records;
- requires bot workflow or maintainer action.

Recommendation: start with Policy A if the repo already expects generated files in proof PRs; switch to Policy B only if generated artifact conflicts become noisy.

## GitHub Profiles and Avatars

Do not call the GitHub API for profile metadata in the static page. It creates token/rate-limit questions and makes generation nondeterministic.

Use deterministic URLs:

```text
profile_url = https://github.com/<solver>
avatar_url  = https://github.com/<solver>.png?size=96
```

The display name should be `@<solver>` unless the repo later stores a verified human-readable name. Pulling real names from GitHub would require network/API behavior and creates unnecessary privacy and stability issues.

## Hosting Options

### Option A: `docs/leaderboard.html` on GitHub Pages

Best default.

The page can fetch:

```text
metrics/leaderboard-ui.json
```

relative to itself. This keeps the HTML and JSON in the same hosted tree.

Pros:

- simple static hosting;
- no backend;
- no GitHub API;
- aligns with existing `docs/proofs-contributors-visualisation.html`.

Cons:

- opening the file directly from disk may hit browser `file://` fetch restrictions;
- users should use GitHub Pages or a local static server.

### Option B: root `leaderboard.html` fetching `docs/metrics/community-stats.json`

Acceptable for local repo use, but worse for project docs because the page is outside the `docs/` tree used by GitHub Pages patterns.

### Option C: raw GitHub URL

The page could fetch:

```text
https://raw.githubusercontent.com/agenticsnz/unsorry/main/docs/metrics/leaderboard-ui.json
```

This may work in browsers, but it couples the page to the public repository, branch name, caching behavior, and cross-origin behavior. It is less robust than a relative GitHub Pages fetch.

## Score Design

The project already has a defensible rank policy: verified proofs first, then difficulty points. Keep that as the canonical rank.

The visual design wants a bar width currently called `volume`. Use a display-only score for that:

```text
score = difficulty_points * 100 + verified_proofs * 25
```

Why this is conservative:

- difficulty points dominate the bar, which rewards harder verified work;
- verified proofs still matter;
- failed attempts do not increase score;
- run success rate can be shown as a badge, not used as a reward;
- historical unknown work remains outside the contributor ranking.

Possible future badges:

- Verified proofs
- Difficulty points
- Run success rate
- Attempt yield
- Median solve time
- Recent proof count
- First proof
- Decomposer
- Recomposer
- Model explorer

Avoid any badge that rewards repeated failed attempts without a verified or accepted decomposition outcome.

## Current HTML Adaptation Notes

Current `leaderboard.html` uses:

```js
const seedData = [
  { id, name, avatar, volume, isCurrentUser, badges }
]
```

Replace that with:

```js
async function loadLeaderboard() {
  const response = await fetch('metrics/leaderboard-ui.json', { cache: 'no-store' });
  if (!response.ok) throw new Error(`leaderboard fetch failed: ${response.status}`);
  return response.json();
}
```

Then map:

```js
const leaderboardData = payload.contributors.map(row => ({
  id: row.solver,
  name: row.display_name,
  avatar: row.avatar_url,
  profileUrl: row.profile_url,
  volume: row.score,
  badges: {
    kudos: row.verified_proofs,
    trophies: row.difficulty_points,
    trend: Math.round((row.run_success_rate || 0) * 100)
  }
}));
```

The page should:

- show `@solver` linked to GitHub;
- use project language instead of corporate sales language;
- replace money formatting with points/proofs formatting;
- replace `$10,000` goal markers with proof/difficulty point scale markers;
- show an empty state when no contributors have attributed proofs.

The interface to the HTML should be treated as a contract. The page should prefer a stable generated file such as:

```text
docs/metrics/leaderboard-ui.json
```

That file should contain `schema_version`, `summary`, `score_policy`, and `contributors`. The HTML can remain simple and presentation-only: fetch JSON, validate the top-level shape, render rows, and show a clear empty/error state. Rank, score, profile URL, and avatar URL should be generated by Python tests, not recomputed independently in browser code.

## README Image Feasibility

The README cannot embed the interactive HTML as a live component because GitHub markdown does not execute page JavaScript.

There are three practical choices.

### Choice 1: Link to the HTML and keep markdown table

Lowest cost. The README links to `docs/leaderboard.html` or `docs/leaderboard.md`.

Pros:

- no new dependencies;
- already aligned with current repo;
- reliable on GitHub.

Cons:

- not visually gamified in the README.

### Choice 2: Generate SVG

Generate `docs/leaderboard.svg` from the same JSON.

Pros:

- can be deterministic;
- can be generated by pure Python string rendering;
- easy to embed in README as an image;
- no browser dependency.

Cons:

- less visually rich than the HTML;
- external avatars inside SVG are fragile and should probably be avoided;
- GitHub's SVG rendering/sanitization behavior can be restrictive.

Best SVG design: top 5 text rows with rank, `@solver`, proof count, difficulty points, and score. Link the image to the full HTML page.

### Choice 3: Generate PNG screenshot

Use Playwright or Puppeteer in CI to render `docs/leaderboard.html` and save `docs/leaderboard.png`.

Pros:

- closest visual match to the HTML;
- supports avatars and the current bar design;
- good README visual.

Cons:

- adds Node/browser tooling;
- introduces CI runtime and dependency management;
- screenshot determinism must be handled carefully;
- fonts/network avatars can make image output unstable unless controlled.

Engineering recommendation: ship Phase 1 without image generation. Add `docs/leaderboard.svg` as the first README-preview renderer if the README image remains important. Add PNG screenshotting only if the project accepts the browser tooling cost.

## CI and Drift

The generator has `--write`, `--json`, and `--check` modes. That is the right pattern.

The implementation should ensure:

```bash
python3 -m tools.leaderboard --write .
python3 -m tools.leaderboard --check .
```

passes after new artifacts are added.

If adding `docs/leaderboard.html`, `docs/metrics/leaderboard-ui.json`, or `docs/leaderboard.svg`, prefer making them generated by `tools.leaderboard --write` and checked by `tools.leaderboard --check`.

Adding the check to CI is desirable, but workflow edits may touch protected surfaces. If that is high-friction, the first PR can add the generator/check behavior and leave CI wiring to a follow-up code-owner-reviewed PR.

## Suggested Implementation Steps

1. Regenerate existing leaderboard files and confirm the current data.
2. Add tests for a UI-facing contributor payload.
3. Extend `tools/leaderboard/generate.py` to produce `leaderboard-ui.json`, or add a small adapter module under `tools/leaderboard/`.
4. Move or generate the HTML as `docs/leaderboard.html`.
5. Replace IndexedDB seed data with a fetch from `metrics/leaderboard-ui.json`.
6. Update language from sales/corporate volume to Unsorry proof points.
7. Make `--check` detect drift in the new generated file(s).
8. Add README/docs links to the HTML page.
9. Defer SVG/PNG image generation unless explicitly scoped into the issue.

## Risks

- **Stale generated files:** mitigated by `--check` and CI drift checks.
- **Misattribution:** mitigated by using only recorded solver fields and preserving historical unknowns.
- **Rewarding spam:** mitigated by keeping failures visible but not score-positive.
- **GitHub API dependence:** avoided by deterministic profile/avatar URLs.
- **Browser fetch issues locally:** mitigated by using GitHub Pages or documenting `python3 -m http.server`.
- **Screenshot flakiness:** avoid in Phase 1; prefer SVG if a README image is needed.

## Decision Recommendation

Proceed with the first part now:

- connect real generated data to a static HTML leaderboard;
- add GitHub profile/avatar links;
- make the generated data deterministic and drift-checked;
- leave README image generation as a documented Phase 2.

This gives the project a useful contributor-facing leaderboard without adding a backend or browser-based CI dependency.
