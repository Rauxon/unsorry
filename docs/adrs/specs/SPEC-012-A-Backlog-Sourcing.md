# SPEC-012-A: Backlog Sourcing Pipeline

Implements: [ADR-012](../ADR-012-Backlog-Sourcing.md) · Refines: [SPEC-003-A](SPEC-003-A-Goal-Record-Schema.md) · Status: Living · Updated: 2026-06-10

How a candidate theorem becomes a claimable goal. Five stages; the absence check is the load-bearing one.

## 1. Source

Candidate theorems come from curated lists and from contributors:

- **Curated:** Freek Wiedijk's *Formalizing 100 Theorems* (empty Lean column = unformalised), the *1000+ theorems* list, mathlib's `undergrad`/undergraduate-coverage gaps, *Mathematics in Lean* `sorry` exercises (high absence-confidence), and classic elementary identities niche enough to plausibly be unnamed in mathlib.
- **Contributor:** the `propose-target` issue template (`.github/ISSUE_TEMPLATE/propose-target.md`) — statement, reference, and the proposer's absence evidence.

Scope boundary (ADR-012): only theorems that are **already proven** and plausibly **absent from mathlib**. Not open conjectures. A candidate that needs new definitions before it can even be *stated* on mathlib objects is out of band.

## 2. Absence-verify (the gate)

`python3 -m tools.sourcing.check_absence --pattern '<regex>' [--loogle '<query>']` greps the **pinned mathlib source** (the checkout the swarm builds against — authoritative) for patterns that would appear if the theorem were already stated, and cross-checks Loogle when reachable. It records the mathlib revision (`lake-manifest.json`).

- Exit 0 = no local match (admit-eligible); exit 1 = a pattern matched (review the hits — likely a duplicate).
- **It is a pre-filter, not a proof of absence** (grep cannot decide semantic presence). The definitive signal is downstream: an in-mathlib target gets a one-line citation from the prove cycle, not a real proof. The check keeps obvious duplicates out cheaply and **dates** the claim.

## 3. State

Produce the Lean statement: a `goals/<id>.lean` = `theorem <name> <binders> : <prop> := by sorry` that **type-checks** against the pinned mathlib (`lake build UnsorryGoals`). For contributor English statements this is the existing translate/fidelity gate (two independent lowerings, normalize, diff). A statement that does not type-check is not admitted.

## 4. Band & dedup

Tag `difficulty` (0–5) and a decomposition sketch (so affinity/gap routing prefers reachable targets); reject near-duplicates of existing goals.

## 5. Admit

A gated PR adds:

- `backlog/<id>.md` — the English statement plus provenance as `- **Field:** value` lines: **Source**, **Reference**, **Absence** (verdict + mathlib rev + date), **Difficulty**. (Gate B does not validate the backlog markdown, so no goal-schema churn; the board reads these.)
- `goals/<id>.aisp` (phase `prove`, status `open`) + `goals/<id>.lean` (the type-checked statement).

It then rides the existing machinery: claim → prove, affinity/gap routing (ADR-010), decomposition for hard ones (ADR-009), binding for meaning (ADR-011).

## Board

`tools/sourcing/targets_board.py` regenerates `docs/targets.md` — the human worklist (one row per prove goal: status, difficulty, source, reference). `--check` is a CI drift guard so the board stays in sync with the goals.

## Acceptance criteria

1. `tools/sourcing/tests/test_check_absence.py` — grep finds a present lemma (exit 1), reports absence (exit 0), records the rev, deterministic JSON; Loogle failure degrades gracefully.
2. `tools/sourcing/tests/test_targets_board.py` — reads status/provenance, proved marker overrides record status, only prove goals listed, deterministic render with counts, `--check` detects drift.
3. A seeded target batch: each admitted goal type-checks (`lake build UnsorryGoals`) and passed `check_absence` against the recorded mathlib rev.
