# SPEC-040-A: Changelog Fragments

Implements: [ADR-040](../ADR-040-Changelog-Fragments.md) · Status: Living · Updated: 2026-06-14

## Fragment files

A user-facing change adds **one file** `changelog.d/<category>-<slug>.md`:

- **`<category>`** ∈ `added`, `changed`, `deprecated`, `removed`, `fixed`,
  `security` (Keep a Changelog). It is the filename prefix up to the first `-`.
- **`<slug>`** is descriptive **and unique** — include the issue/PR number or the
  agent id (e.g. `fixed-gemini-effort-435.md`, `added-proof-foo-oma-2-c50d.md`).
  Uniqueness is the property that prevents collisions; a generic slug two PRs
  could both choose reintroduces the conflict.
- **Body**: the entry text as a single Keep-a-Changelog bullet (markdown, no
  leading `- `). `changelog.d/README.md` documents this and is ignored by the
  tool.

PRs **must not** edit `CHANGELOG.md`'s `[Unreleased]` section; it is a static
pointer. A pure swarm proof needs no fragment.

## Tool — `tools/changelog`

- `render_unreleased(root)` — reads `changelog.d/*.md` (excluding `README.md`),
  groups by category, orders categories by the Keep-a-Changelog sequence and
  entries within a category by filename (deterministic), and returns the
  `### Category` / `- entry` markdown body. Unknown category prefixes raise.
- `python3 -m tools.changelog --preview [<root>]` — prints that body (what
  `[Unreleased]` would render as).
- `python3 -m tools.changelog --release <version> <date> [<root>]` — inserts a
  new `## [<version>] - <date>` section (the rendered body) between the
  `[Unreleased]` pointer and the latest release in `CHANGELOG.md`, then deletes
  the fragment files (keeping `README.md`). Exit 2 (no-op) when there are no
  fragments.

## Concurrency properties (the point)

- **Per-PR (hot path):** a PR only *adds* `changelog.d/<unique>.md`. Distinct
  filenames ⇒ a 3-way merge sees independent file additions ⇒ no conflict at any
  merge rate, and GitHub's conflict detector agrees (no custom driver needed).
- **Release (cold path):** `--release` is the only writer of `CHANGELOG.md` and
  is run by a single release process, so concurrent releases serialize rather
  than conflict.
- The previous `CHANGELOG.md merge=union` `.gitattributes` driver is superseded
  (GitHub never honoured it); it may be removed once no in-flight branch still
  edits `[Unreleased]` directly.

## Validation

`tools/changelog/tests/test_generate.py`:
- category parsing; Keep-a-Changelog grouping/ordering; `README.md` ignored;
  unknown category rejected; empty dir renders nothing;
- `--release` inserts the version section between `[Unreleased]` and the prior
  release, preserves the `[Unreleased]` pointer, includes every fragment, and
  clears `changelog.d/` except `README.md`; release with no fragments is a no-op.
