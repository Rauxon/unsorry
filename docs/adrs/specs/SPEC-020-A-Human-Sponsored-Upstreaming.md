# SPEC-020-A: Upstream Pipeline (Human-Sponsored)

Implements: [ADR-020](../ADR-020-Human-Sponsored-Upstreaming.md) · Status: Living · Updated: 2026-06-12

## Eligibility (stage 1)

`python3 -m tools.upstream.eligible [<root>]` prints, one per line, every goal with: a `library/index` entry (proved) ∧ a structured `- **Absence:** …` field in `backlog/<id>.md` (ADR-012 provenance — shakedown trivia lack the field, decomposition subs lack the file) ∧ no `docs/upstream/<id>.md` yet. Reuses `targets_board`'s provenance parser (§13).

## Dedup at HEAD (stage 2)

`python3 -m tools.upstream.dedup_head --goal <id> --mathlib <master-checkout> [--pattern …] [--rev …]` re-greps mathlib **master** with the ADR-012 engine (`check_absence.grep_mathlib`, imported not duplicated). Default pattern: the proved theorem's name from the goal's index entry. Emits JSON `{goal, mathlib_rev, patterns, local_matches, verdict}`. A grep is a pre-filter; the strong evidence is stage 4.

## Packet + patch (stages 3 and 5)

`python3 -m tools.upstream.packet --goal <id> [--dedup <json>] [--sponsor <name>]` writes:

- **`docs/upstream/<id>.md`** — Status line (`packet-ready`, or `blocked-possible-duplicate` on a dedup hit; the sponsor advances it: `in-discussion → pr-open → merged | declined`), the statement, the proposed contribution block, dedup evidence, provenance dossier (backlog fields + gate evidence), a **paste-ready factual AI-disclosure block**, and sponsor instructions stating the rewrite-in-own-words boundary (mathlib forbids LLM-written conversation; the lemma itself, disclosed, is fine).
- **`docs/upstream/<id>.patch`** — a `git apply`-able **new-file** diff: human-author copyright header, the module's mathlib imports, and the theorem block only. Internal plumbing (Unsorry imports, `Lean.Linter` lint-scope helpers, `@[unused_variables_ignore_fn]` defs) never leaks. Target path `Mathlib/Unsorry/<Camel>.lean` is a deliberate placeholder — placement is a Zulip question. Proofs importing sibling `Unsorry.*` lemmas get a **bundle-or-inline** dependency section instead of a silently broken patch.

## HEAD kernel-verification (stage 4)

`./tools/upstream/verify_head.sh <goal> [<workdir>] [--stamp]` builds the patch's file in a scratch Lake project requiring mathlib master (toolchain from mathlib master, `lake exe cache get`; the scratch is cached across goals). Exit 0 = kernel-verified at HEAD; `--stamp` appends the verdict + rev + date to the packet. **A failure is signal, not error** — mathlib moved under the lemma; the packet records it before a sponsor spends community goodwill.

## Automatic initiation

`.github/workflows/upstream-packets.yml` (nightly 14:17 UTC + `workflow_dispatch`): eligible-scan → shallow mathlib clone → dedup + packet per target → gated docs PR **assigned to the sponsor**, auto-merge armed. Token caveat (documented in the workflow header + security checklist): default-`GITHUB_TOKEN` PRs trigger no workflows, so the shared `REFRESH_TOKEN` secret (the sponsor/admin PAT also used by the post-merge artifact workflows, #417) is used for packet PRs to flow through the gates unaided — it must carry `pull-requests: write` (this workflow opens + auto-merges a PR) as well as `contents: write`. Idempotent: a packeted goal is no longer eligible.

## Board integration

`targets_board` gains an **Upstream** column: the packet's `Status:` value, linked to the packet, `—` when none.

## Acceptance criteria

- `tools/upstream/tests/`: 16 tests — eligibility (proved/absence/unpacketed each gating, shakedown + decomposition-sub exclusion, sort), dedup (default name pattern from index, planted-duplicate hit, extras, CLI JSON), packet (required sections incl. disclosure + rewrite boundary, dependency flagging both ways, patch hygiene: new-file diff, header, no internal plumbing, dedup-hit → blocked status).
- `tools/sourcing/tests`: upstream-column test.
- Live: the first pipeline run produced packets for all 9 eligible targets; `verify_head.sh` kernel-verifies the clean candidates at HEAD (results stamped per packet).
