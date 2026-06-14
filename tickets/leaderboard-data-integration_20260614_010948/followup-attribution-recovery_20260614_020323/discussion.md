# Discussion: Git Attribution, Solver Provenance, and Historical Leaderboard Visibility

## Why the Leaderboard Shows One Person

The implemented leaderboard is currently sourced from explicit proof provenance, not from general repository contribution history.

Current generated stats show:

```text
verified_proofs: 90
attributed_proofs: 19
historical_unknown_proofs: 71
terminal_runs: 23
successful_proofs_with_run_telemetry: 19
contributors: cgbarlow only
```

The generator behavior is intentional:

- `proofs()` reads `solver`, `agent`, `provider`, `model`, `effort`, `attempts`, and `solve_s` from `library/index/*.aisp`.
- `base_stats()` treats a proof as attributed only when it has both `solver` and `provider`.
- `ui_payload()` turns the attributed contributor rows into GitHub profile and avatar rows.
- `docs/leaderboard.html` consumes only `contributors` from `docs/metrics/leaderboard-ui.json`.

That means the visual result is accurate under the strict solver-provenance policy, but misleading as a human community view.

## What Git History Can Tell Us

Git history can answer a different question:

```text
Who added or last touched each proof index file?
```

It cannot always answer:

```text
Who actually solved the proof?
```

Those are related but not equivalent. A commit author can be a proof solver, bot, merger, pair-programming operator, or migration author. ADR-023 intentionally avoided git authorship as solver credit because merge and squash workflows can distort authorship.

For this repo, however, `library/index/*.aisp` has a useful signal. Every proof index file has a clear add author, and no proof index file currently has mixed blame authors.

## Current Repo Attribution Findings

Command used conceptually:

```bash
git log --diff-filter=A --format='%H%x09%an%x09%ae%x09%cs' -- library/index/<sha>.aisp
git blame --line-porcelain -- library/index/<sha>.aisp
```

Add-author counts for `library/index/*.aisp`:

| Git add author | Index files added |
|---|---:|
| Chris Barlow `<cgbarlow@gmail.com>` | 60 |
| chat-bit-01 `<chatuser55@gmail.com>` | 20 |
| binto `<marcjvincent@gmail.com>` | 9 |
| OceanLi `<quantocean.li@gmail.com>` | 1 |

Line-blame counts for `library/index/*.aisp`:

| Git blame author | Blamed lines |
|---|---:|
| Chris Barlow `<cgbarlow@gmail.com>` | 439 |
| chat-bit-01 `<chatuser55@gmail.com>` | 140 |
| binto `<marcjvincent@gmail.com>` | 63 |
| OceanLi `<quantocean.li@gmail.com>` | 7 |

Files with multiple blamed authors:

```text
0
```

Broader proof-related git history includes more people:

| Git author | Commits touching proof-related paths |
|---|---:|
| Chris Barlow `<cgbarlow@gmail.com>` | 120 |
| chat-bit-01 `<chatuser55@gmail.com>` | 20 |
| binto `<marcjvincent@gmail.com>` | 9 |
| Perttu Isotalo `<pisotalo@isotalo.org>` | 7 |
| Your Name `<you@example.com>` | 1 |
| OceanLi `<quantocean.li@gmail.com>` | 1 |

This broader signal is useful for repository contribution visibility, but less precise for proof index attribution than the add-author counts.

## What Is Possible

### Option A: Keep Only Solver Provenance

Do nothing except improve explanatory text.

Pros:

- Strictest interpretation of ADR-023.
- No risk of conflating commit author and solver.
- No extra generator complexity.

Cons:

- Leaderboard keeps looking like only one person contributed.
- Historical contributors remain invisible.
- Human users will reasonably keep questioning the output.

This is not recommended as the final UX.

### Option B: Add an Unranked Historical/Unknown Bucket

Show a visible row or card:

```text
Historical / unknown: 71 proof records
```

Pros:

- Very easy.
- Avoids false attribution.
- Fixes the "one person did everything" visual somewhat.

Cons:

- Still hides contributors whose git history is available.
- Does not use the strong add-author signal present in this repo.

This is a good minimum fix but not enough.

### Option C: Add Git-Attributed Historical Proof Contributors

Add a second section based on git add-author attribution for `library/index/*.aisp`:

```text
Historical proof index contributors
Chris Barlow      60 index files added
chat-bit-01       20 index files added
binto              9 index files added
OceanLi            1 index file added
```

Pros:

- Reflects real repository history.
- Makes historical contributors visible.
- Keeps solver-provenance ranking clean.
- Can be deterministic in a git checkout.

Cons:

- Add-author is not guaranteed to equal solver.
- Git author names/emails are not always GitHub usernames.
- Requires careful labeling and tests.

This is the recommended fix.

### Option D: Backfill `solver≜` From Git

Automatically edit historical index files and set `solver≜...` from git authorship.

Pros:

- Makes one unified leaderboard.

Cons:

- Violates the original caution in ADR-023.
- Converts a useful hint into a factual solver claim.
- Requires identity mapping that may be wrong.
- Risks rewriting content-addressed historical records incorrectly.

This should not be automated.

### Option E: Manual Backfill With Evidence

Use git attribution, PR links, or maintainer knowledge to review individual old proofs and add explicit provenance only when known.

Pros:

- Produces real solver credit.
- Can be done incrementally.
- Auditable.

Cons:

- Human review cost.
- Not necessary for the first UX improvement.

This can be a later project after the historical section and attribution-gaps report exist.

## GitHub Username Recovery

Git commit metadata gives:

- author name;
- author email;
- commit hash;
- commit date.

It does not always give a GitHub login.

Safe automatic mappings:

- If email is GitHub no-reply in the form `<id>+<login>@users.noreply.github.com`, extract `<login>`.
- If the author name is already a valid GitHub-handle-shaped string, it may be displayed as a name, but should not automatically become a profile link unless the project accepts that convention.

Unsafe automatic mappings:

- Inferring `cgbarlow` from `Chris Barlow <cgbarlow@gmail.com>`.
- Inferring GitHub handles from personal email local parts.
- Searching GitHub by email/name during generation.

Recommended approach:

- Add a reviewed alias map.
- Use aliases for profile/avatar URLs.
- Display unmapped authors by name only.
- Keep raw email out of the HTML UI unless maintainers explicitly choose to expose it.

## Recommended Data Model

Keep solver leaderboard rows as they are:

```json
{
  "contributors": [
    {
      "rank": 1,
      "solver": "cgbarlow",
      "profile_url": "https://github.com/cgbarlow",
      "verified_proofs": 19,
      "difficulty_points": 49,
      "score": 5375
    }
  ]
}
```

Add historical contributor rows:

```json
{
  "historical_contributors": [
    {
      "display_name": "chat-bit-01",
      "github": "chat-bit-01",
      "profile_url": "https://github.com/chat-bit-01",
      "avatar_url": "https://github.com/chat-bit-01.png?size=96",
      "index_files_added": 20,
      "solver_provenance_proofs": 0,
      "attribution_source": "git-add-author",
      "solver_credit": false
    }
  ]
}
```

Add a gaps report:

```json
{
  "schema_version": 1,
  "missing_solver_provenance": [
    {
      "path": "library/index/051b341cd7723755424a4748a6a6dbcbb02f3bae374a8c2c84743b2b8ea5563a.aisp",
      "goal": "example-goal-id",
      "git_add_author": "chat-bit-01 <chatuser55@gmail.com>",
      "mapped_github": "chat-bit-01",
      "review_status": "candidate"
    }
  ]
}
```

## Where the Fix Belongs

### `tools/leaderboard/generate.py`

This is the primary fix location.

Current relevant functions:

- `proofs(root, known_goals=None)` parses proof index records.
- `base_stats(root)` aggregates proof/run statistics and contributor rows.
- `ui_payload(root)` creates `docs/metrics/leaderboard-ui.json`.
- `render_svg(root)` creates the README-compatible image.

Add helpers near the parsing/aggregation layer:

```python
def git_add_authors(root: Path) -> dict[str, GitAuthorInfo]:
    ...

def historical_attribution(root: Path, proofs: list[Proof]) -> dict:
    ...
```

The helper should use `git -C <root> log --diff-filter=A ... -- <path>` through `subprocess.run`, parse structured output, and fail clearly if git is unavailable during `--write` or `--check`.

### `docs/metrics/contributor-aliases.json`

Add reviewed identity mapping. This should be hand-maintained and small.

It should not be generated from GitHub API calls. It should exist so maintainers can decide which git authors should have GitHub profile links.

### `docs/leaderboard.html`

Add a second display section after the solver leaderboard.

Good UI wording:

```text
Historical proof index contributors
Derived from git add-author history for proof index files. This is contributor visibility, not solver-provenance ranking.
```

Avoid wording like:

```text
These users solved these proofs
```

unless the records have explicit solver provenance.

### `docs/leaderboard.svg`

The current README image can still show the top solver leaderboard, but it should include a small summary like:

```text
90 verified proofs · 19 solver-attributed · 71 historical · 4 git-attributed proof authors
```

This prevents the README from visually collapsing the project to one contributor.

### `CONTRIBUTING.md`

Add contributor setup guidance:

```text
Before coordinated proof runs, make sure `gh auth status` shows your own GitHub account, or set `UNSORRY_SOLVER=<your-github-handle>`.
```

Also mention that commit author and solver credit are intentionally separate.

### `Skills/unsorry-leaderboard-integration`

After implementation, update the skill so future agents know:

- solver provenance is strict ranked credit;
- historical git attribution is visibility only;
- alias-map entries are reviewed;
- raw git history should not be promoted to solver credit automatically.

## Validation Plan

Run:

```bash
python3 -m tools.leaderboard --write .
python3 -m tools.leaderboard --check .
python3 -m pytest tools/leaderboard -q
python3 -m tools.gate_b validate .
```

Also inspect generated artifacts:

```bash
python3 -m tools.leaderboard --json . | jq '.historical_attribution'
python3 -m json.tool docs/metrics/leaderboard-ui.json >/dev/null
python3 -m json.tool docs/metrics/attribution-gaps.json >/dev/null
```

For the HTML, verify:

- the solver leaderboard still shows explicit `solver≜` rows only;
- the historical section shows git-attributed proof index contributors;
- unmapped authors do not render broken GitHub links;
- summary counts match generated JSON;
- empty states are coherent if no historical rows exist.

## Recommended Final State

The final leaderboard should have three honest layers:

1. **Solver leaderboard**: ranked, profile-linked, derived only from explicit `solver≜` proof/run telemetry.
2. **Historical proof index contributors**: visible, separately labeled, derived from git add-author history and optional reviewed aliases.
3. **Attribution gaps**: machine-readable review queue for records that have proof artifacts but no solver provenance.

This answers the user concern without corrupting the meaning of the existing proof-provenance fields.
