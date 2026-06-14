# Changelog fragments

User-facing changes are recorded here as **one file per change** instead of
editing `CHANGELOG.md`'s `[Unreleased]` section directly. Because every PR adds a
*distinct new file*, concurrent PRs never conflict on the changelog — the point
of ADR-040. The fragments are collated into a versioned section at release time
by `python3 -m tools.changelog --release <version> <date>`.

## Adding an entry

Create `changelog.d/<category>-<slug>.md` containing the entry text (one bullet,
markdown, no leading `- `). For example `changelog.d/fixed-gemini-effort-435.md`:

```
The gemini proof provider no longer forwards an unsupported `--effort` flag…
```

- **`<category>`** is one of: `added`, `changed`, `deprecated`, `removed`,
  `fixed`, `security` (Keep a Changelog).
- **`<slug>`** must be **unique** — include the issue/PR number or your agent id
  (e.g. `changed-gate-a-routing-441.md`, `added-proof-foo-oma-2-c50d.md`). Unique
  filenames are what keep parallel PRs from colliding; a generic slug two PRs
  might both pick (`fixed-bug.md`) reintroduces the conflict.

Not every PR needs one — only user-facing changes (a single swarm proof does not).

## Previewing / releasing

```sh
python3 -m tools.changelog --preview               # what [Unreleased] would render
python3 -m tools.changelog --release 1.13.0 2026-06-15   # fold into CHANGELOG.md, clear fragments
```
