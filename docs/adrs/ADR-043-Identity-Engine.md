# ADR-043: The Identity Engine — mass-source mathlib-absent elementary identities at scale

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-043 |
| **Initiative** | unsorry — #400 sourcing program (the BHAG) |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

The swarm has demonstrated its full loop — source → claim → prove → merge → reuse —
and the board now carries ~180 prove-goals, ~115 proved. The obvious elementary
identities (basic divisibility `6∣n³−n`, the mod-residue family, the first
telescopes and SOS inequalities) are **largely sourced already**. #400 asks for the
next program: a **big-hairy-goal** that feeds the swarm *hundreds* of difficult,
non-trivial, mathlib-absent problems and makes the math community take notice.

Three directions were weighed (see `docs/plans/identity-engine.md`):

1. **Identity Engine** — be the first autonomous system to mass-produce kernel-checked,
   mathlib-**absent** elementary identities & inequalities at scale, upstream-targeted.
2. **Crack an open AI benchmark** (PutnamBench / miniF2F-v2) — beat published machine SOTA.
3. **Formalize a Classic** end-to-end (e.g. *Concrete Mathematics*).

Option 2 statements are pre-formalized but many need olympiad insight the swarm is
weak at, so a smaller fraction would ship and the pipeline would silt up with
unprovable goals — in tension with our verify-provable-before-sourcing gate. Option 3
is a clean "first" but capped to one artifact. Option 1 is the only direction that
simultaneously scales to hundreds→thousands, plays to the swarm's **demonstrated**
strengths (ZMod-decide divisibility, SOS inequalities, telescoping/induction
identities) so the targets actually get *proved*, and is genuinely undone — no
autonomous system has mass-produced net-new, upstream-bound mathlib theorems.

## WH(Y) Decision Statement

**In the context of** #400 needing a scalable source of *hundreds* of non-trivial,
mathlib-absent targets, with the swarm proven strongest in elementary number theory,
combinatorics, and inequalities,
**facing** the fact that the obvious low-hanging identities are already sourced, that
benchmark-import (option 2) risks a pile-up of unprovable goals, and that
single-text formalization (option 3) caps scope,
**we decided for** the **Identity Engine** — a themed, gate-disciplined mass-sourcing
program that (a) mines mathlib-absent elementary identities across ten+ families
(binomial, Fibonacci/Lucas, divisibility, power-residue, telescoping, figurate, SOS
inequalities, gcd/coprimality, closed-form sums, algebraic identities), (b) verifies
**every** candidate before sourcing — absence (name + content grep of pinned mathlib)
+ ADR-035 triviality battery + the intended proof compiles under `lake env lean` + an
adversarial skeptic pass — and (c) stages the next 200–300 as a vetted-but-not-sourced
**candidate backlog** (`backlog/candidates/<theme>.md`), with the whole library
upstream-targeted to mathlib's thinnest documented areas,
**and neglected** benchmark-conquest-first (rejected for the provability ceiling) and
full single-text formalization (rejected for the scope cap) — both retained as
sanctioned future pivots, with *Concrete Mathematics* reused here as a corpus anchor.

## Consequences

- **Sourcing discipline is unchanged** — the Engine reuses the existing gates
  (`tools/sourcing/check_absence.py`, `tools/sourcing/check_triviality.py` per ADR-035,
  `lake env lean` for the provable gate, `tools/gate_b`). The new surface is only the
  candidate-backlog convention and the mining/skeptic orchestration.
- **A new staging convention**: `backlog/candidates/<theme>.md` lists vetted-but-not-
  sourced candidates (absence-clean + battery-survives); promotion to a real goal triple
  adds the provable-build + skeptic pass. Gate B does **not** validate this directory
  (same as `backlog/*.md`), so it adds no schema churn. See `backlog/candidates/README.md`.
- **Tracking**: the program is tracked in #400 (a pinned status comment) and **every
  sourced batch is announced on #81** as it lands (established protocol).
- **Net-new only**: as the library grows, dedup pressure rises; the absence gate plus
  the adversarial skeptic ("is this a disguised special case of a named mathlib lemma?")
  are the defence. A flagged near-duplicate is **dropped**, not defended (e.g. batch 1
  dropped `sq-mod-four` for closeness to `Int.sq_mod_four_eq_one_of_odd`).
- **Honesty preserved (ADR-024 lineage)**: a target is only sourced when absent +
  non-trivial + truth-verified-provable; the program never pads counts with red-gate or
  morally-trivial goals.

## Acceptance criteria

1. The ten themes are documented with example shapes and target counts in
   `docs/plans/identity-engine.md`.
2. Each sourced goal passes absence + ADR-035 triviality + a compiling intended proof
   before landing, and Gate B stays clean.
3. The candidate backlog (`backlog/candidates/`) reaches ≥200 vetted entries (the
   "next 200–300 planned" deliverable).
4. Every sourced batch is announced on #81; #400 carries a live program-status comment.

## Relationships

Refines **ADR-012** (Backlog-Sourcing) and **ADR-035** (triviality gate); uses the
**ADR-040** changelog-fragment flow; consistent with **ADR-024** (honesty). Paired with
**SPEC-043-A**.
