# Gate A Goal-Immutability Red Team — Round 003 (2026-06-12)

Rounds 001–002 closed the soundness and the statement-*meaningfulness* gaps: a library term must
be sound (axiom audit, kernel replay) **and** inhabit its goal's canonical type (the ADR-011
binding obligation). The external review in [issue #190](https://github.com/agenticsnz/unsorry/issues/190)
found the layer underneath both: every check derives the canonical statement from
`goals/<id>.lean` **as it exists in the PR's own tree**. The binding obligation is regenerated
*from* that file; Gate B's shas are recomputed *against* it. So a PR that **consistently** rewrites
the whole set — goal `.lean`, goal record sha, index entry, library proof — moves the canonical
statement *with* the proof, and every self-consistent layer agrees. Nothing pinned the statement
against history. That is the CRITICAL same-PR goal-tampering hole.

Round 003 attacks the fix ([ADR-018](../adrs/ADR-018-Goal-Statement-Immutability.md) /
[SPEC-018-A](../adrs/specs/SPEC-018-A-Goal-Statement-Immutability.md), landed in
[#220](https://github.com/agenticsnz/unsorry/pull/220)) with a **real PR** replaying the #190
attack at full consistency, and verifies the CI state from `gh pr checks` / `gh run view
--log-failed`. **The attack is "blocked" iff gate-a is RED (cannot merge).**

## Verdict

**Goal-statement immutability holds, and is the *sole* layer that catches the attack. 1/1 blocked.**
The adversarial PR weakens a proved goal (`nat_add_comm_thm : a + b = b + a` → `a + b = a + b`) and
rewrites every dependent artifact to match — goal `.lean`, the library proof (→ `rfl`), the index
entry (sha + filename), **and** the goal record's sha pointer — so the binding regeneration and
**Gate B both pass** on the tampered tree (gate-b green, exactly as the #190 finding predicts).
Only the ADR-018 step, which diffs `goals/` against the PR base ref, rejects it.

## Result

| Vector | PR | gate-a | gate-b | Caught by | Evidence |
|---|---|---|---|---|---|
| consistent-goal-tampering | [#224](https://github.com/agenticsnz/unsorry/pull/224) | ❌ **fail** | ✅ pass | **ADR-018 goal-immutability step** | `goal statement is create-only (ADR-018): M goals/nat-add-comm-thm.lean` → `::error::existing goals/*.lean files must never be modified…` → exit 1 (gate-a run 27392259519); gate-b green on the fully-consistent tree (run after the record-sha fix) |

## Why gate-b passing is the point

A first, *incompletely*-consistent draft of the attack left the goal record's sha pointing at the
renamed index file, and Gate B caught it (GB006, "index … does not exist"). That would have been a
misleading "two gates caught it" result. The recorded attack therefore updates the goal record's
sha too — which is **permitted** (records are editable; only the `.lean` statement is pinned, since
Gate B recomputes record shas *from* it). With the tree fully consistent, **gate-b is green and only
ADR-018 fires** — demonstrating immutability is load-bearing, not redundant with Gate B.

## The legitimate-fix path (not a regression)

ADR-018 makes a wrong statement un-editable by design: it gets a **new goal id**, and the old goal
is abandoned in place. The friction is the security property — an editable statement history is
exactly the tampering surface #190 identified.

## Residual surfaces (recorded, not closed here)

- Deleting a `library/index` entry un-proves a goal (availability, not soundness — the lemma simply
  re-enters the queue).
- A PR that edits `gate-a.yml` itself runs the edited workflow (the #190 HIGH item) — addressed by
  pinning + CODEOWNERS + the settings checklist in
  [ADR-019](../adrs/ADR-019-CI-Supply-Chain-Protection.md), whose required-review setting must be
  enabled before the repository opens to untrusted contributors.
