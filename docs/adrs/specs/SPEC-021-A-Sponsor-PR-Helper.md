# SPEC-021-A: Sponsor PR Helper

Implements: [ADR-021](../ADR-021-Sponsor-PR-Helper.md) · Status: Living · Updated: 2026-06-12

## Command

```
python3 -m tools.upstream.raise_pr --goal <id> --fork <github-user> --understood
    [--root <repo>] [--mathlib-dir <dir>] [--dry-run]
```

Sponsor-run (local `gh`/git auth, a mathlib4 fork). Opens a **draft** PR against `leanprover-community/mathlib4` from a ready, HEAD-verified packet.

## Preconditions (`check_preconditions`, all enforced before any side effect)

1. `--understood` present — running the helper attests the sponsor has read the proof and can justify it without AI;
2. `docs/upstream/<goal>.md` and `.patch` exist;
3. packet `Status:` is `packet-ready` (not `blocked-possible-duplicate`);
4. packet carries a `**HEAD verification:** PASS` stamp.

Any failure → exit 2, every reason printed; nothing cloned/pushed.

## Mechanics (on success)

clone/refresh mathlib master → `git switch -c unsorry/<goal>` → `git apply` the packet patch → commit (the sponsor's git identity) → push to `https://github.com/<fork>/mathlib4` → `gh pr create --draft --repo leanprover-community/mathlib4 --head <fork>:unsorry/<goal> --base master`.

The PR **body** (`pr_body`): an HTML comment explaining the draft, a `> **SPONSOR: replace this section…**` narrative placeholder, the factual disclosure block lifted from the packet (`disclosure_block`, quote-markers stripped), the HEAD-verified rev, and a pre-ready checklist (understood-without-AI, Zulip, narrative-rewritten, label, golfed). The **title** (`pr_title`): `[DRAFT] feat: <theorem-name>`.

The helper **never** marks the PR ready, applies no narrative of its own, and writes no review reply. `--dry-run` prints the full command plan and the rendered body, touching nothing.

## Acceptance criteria

`tools/upstream/tests/test_raise_pr.py` (11 tests): status + HEAD-verified detection (PASS only; unstamped/FAIL → false); disclosure extraction (quote-stripped); title/body rendering (draft prefix, disclosure present, narrative placeholder present, policy reminder); preconditions (pass when ready+verified+understood; block on missing `--understood`, blocked status, unverified HEAD, missing patch); CLI dry-run (prints the mathlib target, "draft", the fork; no side effects) and dry-run refusal without `--understood`.
