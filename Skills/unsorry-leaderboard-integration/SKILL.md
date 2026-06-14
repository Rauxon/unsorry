---
name: unsorry-leaderboard-integration
description: "Workflow for implementing, reviewing, or maintaining Unsorry contributor leaderboard data and UI surfaces. Use when working with tools/leaderboard, docs/metrics/community-stats.json, docs/leaderboard.md, docs/leaderboard.html, leaderboard.html, proof-runs telemetry, library index provenance, GitHub profile/avatar links, generated leaderboard JSON, README leaderboard images, or automation that regenerates and drift-checks leaderboard artifacts."
---

# Unsorry Leaderboard Integration

## Purpose

Use this skill to connect proof-run telemetry and verified proof metadata to contributor-facing leaderboard products. Keep source telemetry, generated stats, UI data, and README preview artifacts separate.

## First Files

Read these before changing leaderboard behavior:

```bash
sed -n '1,260p' tools/leaderboard/generate.py
sed -n '1,220p' docs/adrs/ADR-023-Proof-Provenance-Leaderboard.md
sed -n '1,260p' docs/adrs/specs/SPEC-023-A-Proof-Provenance-Leaderboard.md
sed -n '1,220p' proof-runs/README.md
sed -n '1,220p' leaderboard.html 2>/dev/null || true
```

If the change touches interactive proof graph data, also read `docs/adrs/ADR-032-Proof-Graph-Visualiser.md` and `docs/adrs/specs/SPEC-032-A-Proof-Graph-Visualiser.md`.

## Data Boundaries

- Source records: `goals/*.aisp`, `library/index/*.aisp`, and `proof-runs/*.aisp`.
- Core generated stats: `docs/metrics/community-stats.json` and `docs/leaderboard.md`.
- Proposed UI contract: `docs/metrics/leaderboard-ui.json`.
- Proposed visual page: `docs/leaderboard.html`.
- Optional README preview: `docs/leaderboard.svg` or `docs/leaderboard.png`.

Do not infer historical attribution from git authors, PR mergers, or squash commits. Do not use leaderboard values in Gate A, Gate B admission, or queue selection.

## Implementation Pattern

1. Preserve `tools.leaderboard.generate.base_stats(root)` as the statistical source.
2. Add a UI adapter that derives display-only fields from core stats: rank, score, GitHub profile URL, avatar URL, badges, and summary.
3. Keep the browser page presentation-only. It should fetch generated JSON, validate basic shape, render rows, and show empty/error states.
4. Make `python3 -m tools.leaderboard --write .` refresh every generated leaderboard artifact.
5. Make `python3 -m tools.leaderboard --check .` detect drift for every generated leaderboard artifact.
6. Add tests before or with implementation changes.

## Automatic Data

Load [references/data-model.md](references/data-model.md) when deciding what can be collected automatically and what must be generated after the run. Short version:

- coordinated runs collect solver, agent, provider, model, effort, attempts, solve time, outcome, timestamp, and proof SHA when present;
- generators derive contributor rows, ranks, score, avatar/profile URLs, summaries, markdown, HTML data, and optional README preview assets;
- local-only smoke runs and infrastructure failures before real provider attempts do not create leaderboard telemetry.

## HTML Contract

Load [references/html-contract.md](references/html-contract.md) before changing the browser interface. The HTML should consume `docs/metrics/leaderboard-ui.json` or an equivalent generated file with a versioned schema. Do not hand-code ranks or hard-code contributor rows in the page.

## Validation

Use these checks for leaderboard work:

```bash
python3 -m tools.leaderboard --write .
python3 -m tools.leaderboard --check .
python3 -m pytest tools/leaderboard -q
python3 -m tools.gate_b validate .
```

If HTML or README preview rendering changes, inspect the generated artifact in a browser or image viewer as appropriate.

## Pack Resources

Load these references only when needed:

- [references/data-model.md](references/data-model.md): automatic collection, per-run facts, generated artifacts, and fields to avoid.
- [references/html-contract.md](references/html-contract.md): UI JSON schema, mapping to the current HTML, empty/error states.
- [references/automation.md](references/automation.md): automatic regeneration options, CI drift checks, and generated-artifact conflict tradeoffs.
- [references/readme-rendering.md](references/readme-rendering.md): README image/link options and SVG vs PNG tradeoffs.

Reusable templates live in `assets/`:

- [assets/leaderboard-ui.schema.example.json](assets/leaderboard-ui.schema.example.json): example connection payload.
- [assets/leaderboard-implementation-checklist.md](assets/leaderboard-implementation-checklist.md): implementation checklist.
- [assets/leaderboard-closeout-template.md](assets/leaderboard-closeout-template.md): final/PR report template.
