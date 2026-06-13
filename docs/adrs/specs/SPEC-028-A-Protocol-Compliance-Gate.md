# SPEC-028-A: Protocol-Compliance Gate (Spec-per-ADR)

Implements: [ADR-028](../ADR-028-Protocol-Compliance-Gate.md) · Status: Living · Updated: 2026-06-13

## Rule

For the files **added** by a PR:

- every added `docs/adrs/ADR-<n>-*.md` requires a matching `docs/adrs/specs/SPEC-<n>-*.md` that is either added in the same PR or already on the base tree;
- every added `docs/adrs/specs/SPEC-<n>-*.md` requires a matching `docs/adrs/ADR-<n>-*.md` (added or pre-existing).

Only **added** paths are checked — pre-existing unpaired ADRs (those predating the convention, or reusing another ADR's spec) are never failed.

## Gate

- `tools/repo/pr_protocol.py`: pure `check(added, existing) -> [violations]`; the `check` CLI reads added paths from stdin (or argv) and scans the working tree under `docs/adrs/` for the existing set.
- `.github/workflows/pr-protocol.yml` runs on `pull_request_target` against the base checkout (trusted tool + base ADR/spec tree); the added-file list is `gh api …/pulls/<n>/files` filtered to `status=="added"`. Add `pr-protocol / protocol` to branch protection's required checks to make it blocking.

## Acceptance criteria

1. An added ADR with its spec in the same PR passes; an added ADR alone fails.
2. An added ADR paired with a pre-existing spec passes.
3. An orphan added spec fails.
4. A pre-existing unpaired ADR in `existing` does not cause a violation.
5. Non-ADR/spec changes are ignored.

## Out of scope (issue #302)

CHANGELOG-entry enforcement (cannot cleanly distinguish release-worthy changes from swarm content) and spec-quality/content checks.
