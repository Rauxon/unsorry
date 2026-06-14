# Follow-up Ticket: Restore Historical Contributor Visibility in the Leaderboard

## Summary

The current leaderboard is technically following ADR-023 proof-provenance rules, but it gives a misleading first impression because only one contributor has explicit `solver≜...` telemetry. Many historical proof index records were committed by other contributors before solver provenance existed, so the visual leaderboard currently looks like "only Chris worked on this" instead of "only Chris has recorded solver-provenance rows."

Add a separate historical attribution layer based on git history for `library/index/*.aisp`, keep it clearly distinct from verified solver credit, and update the generated leaderboard views so contributors with historical proof work are visible without pretending that git authorship is the same thing as solver provenance.

## Current Evidence

Generated leaderboard data currently reports:

- `90` verified proof index records.
- `19` attributed proof records.
- `71` historical/unknown proof records.
- `23` terminal proof-run records.
- All attributed solver rows are `cgbarlow`.

Direct git-history inspection of `library/index/*.aisp` shows every proof index file has a clear add author:

| Git add author | Index files added |
|---|---:|
| Chris Barlow `<cgbarlow@gmail.com>` | 60 |
| chat-bit-01 `<chatuser55@gmail.com>` | 20 |
| binto `<marcjvincent@gmail.com>` | 9 |
| OceanLi `<quantocean.li@gmail.com>` | 1 |

`git blame --line-porcelain` across the same proof index files shows no mixed-author index files:

| Git blame author | Blamed lines |
|---|---:|
| Chris Barlow `<cgbarlow@gmail.com>` | 439 |
| chat-bit-01 `<chatuser55@gmail.com>` | 140 |
| binto `<marcjvincent@gmail.com>` | 63 |
| OceanLi `<quantocean.li@gmail.com>` | 7 |

Broader commit history over proof-related paths also includes additional contributors, including Perttu Isotalo, but the index-file add-author signal is the strongest candidate for historical proof artifact visibility.

## Problem

The current implementation only ranks rows from explicit proof provenance:

- `tools/leaderboard/generate.py` reads `solver`, `agent`, `provider`, `model`, `effort`, `attempts`, and `solve_s` from `library/index/*.aisp`.
- `base_stats()` only includes a proof in contributor credit when `solver` and `provider` are present.
- `ui_payload()` turns those contributor rows into profile/avatar rows.
- `docs/leaderboard.html` renders only those UI rows.

That is correct for verified solver provenance, but incomplete as a community view. Historical proof contributors disappear into the summary number `historical_unknown_proofs`.

## Goals

1. Preserve ADR-023: do not infer or overwrite `solver≜...` from git authorship.
2. Add visible historical proof authoring data derived from git history.
3. Make the HTML and SVG communicate the difference between:
   - ranked solver-provenance leaderboard;
   - historical proof index contributors from git attribution;
   - unknown/unattributed historical proofs.
4. Add a deterministic machine-readable output so humans and future agents can inspect attribution gaps.
5. Add a safe manual identity-map path for mapping git authors to GitHub handles when the mapping is reviewed.
6. Document how future contributors avoid the same issue by authenticating `gh` as themselves or setting `UNSORRY_SOLVER=<github-handle>`.

## Non-Goals

- Do not rewrite historical `solver≜` fields from git history automatically.
- Do not assume every git author is the proof solver.
- Do not call the GitHub API during static page load.
- Do not expose emails in the visual leaderboard unless the project explicitly accepts that UI exposure.
- Do not use historical git attribution as a proof admission, Gate A, Gate B, or work-selection trust input.
- Do not merge solver-provenance points and git-attributed historical counts into one undifferentiated score.

## Proposed Fix

### 1. Add historical proof attribution stats

Extend `tools/leaderboard/generate.py` or add a small helper under `tools/leaderboard/` that can derive add-author attribution for `library/index/*.aisp`.

Recommended generated structure:

```json
{
  "historical_attribution": {
    "source": "git-add-author",
    "scope": "library/index/*.aisp",
    "records": 90,
    "authors": [
      {
        "display_name": "Chris Barlow",
        "git_author": "Chris Barlow <cgbarlow@gmail.com>",
        "github": "cgbarlow",
        "index_files_added": 60,
        "solver_provenance_proofs": 19
      }
    ]
  }
}
```

If `.git` is unavailable, the generator should either fail with a clear message when the historical attribution output is requested, or preserve the last checked-in generated data during normal static rendering. Prefer failing in `--check`/`--write` inside a repository checkout so drift cannot hide.

### 2. Add a reviewed identity map

Git history reliably gives names and emails, but not always GitHub usernames. Add a reviewed mapping file so generated UI can link profiles only when the project knows the mapping:

```text
docs/metrics/contributor-aliases.json
```

Suggested schema:

```json
{
  "schema_version": 1,
  "git_authors": {
    "Chris Barlow <cgbarlow@gmail.com>": {
      "github": "cgbarlow",
      "display_name": "Chris Barlow",
      "evidence": "existing solver provenance and git history"
    }
  }
}
```

Rows without a reviewed GitHub handle should still appear in the historical section by display name, but without a GitHub avatar/profile link.

### 3. Update generated UI JSON

Extend `docs/metrics/leaderboard-ui.json` with separate sections:

```json
{
  "contributors": [],
  "historical_contributors": [],
  "summary": {
    "verified_proofs": 90,
    "attributed_proofs": 19,
    "historical_unknown_proofs": 71,
    "git_attributed_index_files": 90
  }
}
```

Keep `contributors` as the ranked solver-provenance leaderboard. Add `historical_contributors` as unranked or separately ranked historical proof index authors.

### 4. Update `docs/leaderboard.html`

Add visible sections:

- "Solver leaderboard" for current `contributors`.
- "Historical proof index contributors" for `historical_contributors`.
- A summary callout explaining that old proof records may lack `solver≜` telemetry.

The UI should never imply that historical git attribution is the same as solver credit. Suggested label:

```text
Historical proof index authors from git history. Not used as solver-provenance ranking.
```

### 5. Update `docs/leaderboard.svg`

The README SVG should avoid the misleading one-person visual. Options:

- show top solver rows plus a small "Historical proof authors: 4" note;
- include an unranked "Historical / git-attributed" summary row;
- add `71 historical proof records need provenance review`.

The SVG must still render in GitHub README without JavaScript.

### 6. Add diagnostics

Add a command or generated report listing:

- proof index files without `solver`;
- their git add author;
- whether an alias-map entry exists;
- whether they are candidates for manual backfill.

Suggested path:

```text
docs/metrics/attribution-gaps.json
```

This gives maintainers a review queue without changing proof records automatically.

## Likely Code Touch Points

- `tools/leaderboard/generate.py`
  - add git add-author collection;
  - add historical contributor aggregation;
  - extend `ui_payload()`;
  - extend `render_svg()`;
  - extend generated markdown summary if useful.
- `tools/leaderboard/tests/test_generate.py`
  - add tests for historical attribution parsing and alias mapping;
  - add tests that solver leaderboard and git-attributed historical contributors stay separate.
- `docs/leaderboard.html`
  - render a second section from `historical_contributors`;
  - improve summary copy and empty states.
- `docs/metrics/contributor-aliases.json`
  - new reviewed alias source.
- `docs/metrics/leaderboard-ui.json`
  - generated output shape expands.
- `docs/leaderboard.svg`
  - generated README visual should mention historical contributors or unknown provenance.
- `CONTRIBUTING.md`
  - add a short note about setting `UNSORRY_SOLVER` and using the right `gh` account.
- `Skills/unsorry-leaderboard-integration`
  - update the skill after implementation so agents understand the two attribution layers.

## Acceptance Criteria

- `python3 -m tools.leaderboard --write .` generates solver leaderboard data and historical proof attribution data.
- `python3 -m tools.leaderboard --check .` detects drift for all generated leaderboard artifacts.
- `docs/leaderboard.html` shows more than the single solver row when historical proof authors exist.
- `docs/leaderboard.svg` no longer implies the project has only one contributor.
- Historical git attribution is labeled separately from solver-provenance ranking.
- Tests cover:
  - missing solver provenance remains historical/unknown;
  - git add-author attribution is collected separately;
  - alias-map GitHub profile links are used only when configured;
  - contributors without alias-map entries still display without broken GitHub links;
  - UI JSON schema remains deterministic.

## Open Questions

1. Should the historical section count all `library/index/*.aisp` files, or only files missing `solver≜`?
2. Should the alias map include raw git emails, or should it use a hashed/stable key to avoid repeating emails in generated docs?
3. Should `docs/leaderboard.md` include historical contributors, or only the HTML/SVG?
4. Should manually reviewed backfill ever add `solver≜` to old records, or should historical visibility remain a separate layer forever?
5. Should a future GitHub Action post an attribution-gaps report on leaderboard PRs?

## Recommended Decision

Implement this as a separate historical-attribution layer, not as solver backfill.

This gives contributors visibility immediately, avoids false precision, and preserves ADR-023's trust boundary. After the historical view exists, maintainers can decide whether individual old proofs deserve reviewed `solver≜` backfill based on PR evidence.
