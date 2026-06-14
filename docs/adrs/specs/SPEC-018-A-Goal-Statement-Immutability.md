# SPEC-018-A: Goal-Statement Immutability

Implements: [ADR-018](../ADR-018-Goal-Statement-Immutability.md) · Status: Living · Updated: 2026-06-15

## The rule

Once a `goals/*.lean` file exists at a PR's base ref, the PR may not modify, delete, rename, or typechange it. Creation (`A`, and the new side of `C*`) is the only legitimate write. Goal *records* (`goals/*.aisp`) are out of scope — they change legitimately and Gate B recomputes their statement shas from the pinned `.lean`.

## The archive-retirement exemption (ADR-041)

A `D goals/<id>.lean` is **allowed** iff both hold in the PR's own tree:

1. `<id>` is recorded in an archive manifest — `packages/unsorry-archive-*/archive-manifest.json`, in its `goals[].goal` list; and
2. the archived `packages/<block>/goals/<id>.lean` is **byte-identical** to the deleted statement *at the base ref*.

This is the only way a pinned statement may leave the active tree: it relocates, unchanged, into a frozen archive block (validated as a trust boundary by ADR-041 §4–5). The exemption is delete-only — modify/rename/typechange always stay rejected, since none can carry a preserved copy out of the tree. A delete with no manifest entry, or one whose archived statement differs from history, stays rejected (the tampering guard: an attacker cannot ship a weakened archived statement, because (2) compares against the base ref, which a PR cannot rewrite).

## Enforcement

`tools/gate_a/check_goal_immutability.py`:

- pure core `violations(lines)` over `git diff --name-status` output: rejects `M`/`D`/`T` on a pinned path and `R*` whose *old* side is pinned (the new side is creation);
- pure core `archive_retired(found, archived_blocks, statement_preserved)` partitions structural violations into still-rejected vs exempt archive retirements, given a goal-id→block map and a byte-identity predicate;
- CLI `--base <sha> [--repo <dir>]` runs `git diff --name-status <base>...HEAD -- goals/`, then resolves archive manifests at `HEAD` and the base-ref/archived statement bytes from git to apply the exemption; exit 0 clean (allowed retirements printed as informational) · 1 violations (each printed, plus a `::error::` explaining the new-goal-id rule and the archive exception) · 2 git/usage error.

gate-a.yml invokes it immediately after checkout (before the build — fail fast), under `detect.lean == 'true' && pull_request`. The detect filter includes `goals/**/*.lean`, so any change to a pinned file forces the full gate; checkout uses `fetch-depth: 0`, so the base ref is always present.

## The legitimate-fix path

A wrong statement is never edited: seed a **new goal id** with the corrected statement and abandon the old goal (demote below τ_v, or leave unclaimed). Deliberate friction — an editable statement history is precisely the #190 tampering surface.

## Acceptance criteria

`tools/gate_a/tests/test_check_goal_immutability.py`: M/D/T/R rejected on pinned paths; `A` and `C*` allowed; `.aisp` edits allowed; non-goal paths ignored; mixed diffs report only violations; CLI integration against a real temporary git repository (creation → exit 0, tamper → exit 1 naming the file).

Archive-retirement coverage: `archive_retired` exempts a delete recorded in a manifest with a preserved statement, rejects a delete not in any manifest, rejects a delete whose archived statement differs, never exempts modify/rename/typechange, and partitions mixed input entry-by-entry; CLI integration — retirement with a byte-identical archived copy listed in the manifest → exit 0; archived statement altered → exit 1; not listed in the manifest → exit 1.

Red-team proof: round 003 (`docs/metrics/gate-a-redteam-003.md`) — a real adversarial PR replaying the #190 attack (consistent weakening of a proved goal across `.lean`, record sha, index entry, and proof) must go red on this step.
