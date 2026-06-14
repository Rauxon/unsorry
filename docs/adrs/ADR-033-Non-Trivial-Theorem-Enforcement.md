# ADR-033: Non-Trivial Theorem Enforcement

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-033 |
| **Initiative** | unsorry backlog quality — machine-enforced target non-triviality |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

Issue #387: the proved set looks mostly trivial, and targets already in the (very
extensive) Lean library should never be admitted. Today a target is admitted (ADR-012)
after `tools/sourcing/check_absence.py` greps the pinned mathlib source for the theorem
**name** (+ best-effort Loogle) and the statement type-checks via `lake build UnsorryGoals`.
That misses two things the name-grep cannot see:

1. **Trivially-provable statements** — closable by a single automation tactic
   (`simp`/`decide`/`omega`/`aesop`/`rfl`/…). The "proof" is a one-line delegation
   (`int_neg_neg_thm := Int.neg_neg n`); sound, but not worth the swarm's compute.
2. **Already-in-mathlib-under-a-different-name** — a name-grep is blind to a lemma
   stated under another name; the absence check itself documents this as "a pre-filter,
   not a proof of absence."

The existing soundness/meaningfulness layers do **not** cover this: Gate A's axiom audit
certifies a proof is *sound* (a `simp` proof is sound); ADR-011's statement-binding gate and
the §0(3) "resist vacuous satisfaction" rule guard *vacuous/over-general restatements*, not
*true-but-trivial* ones; `difficulty` (0–5, SPEC-003-A) is an advisory self-tag with no gate.
So triviality enforcement is, today, human curation — exactly the judgement the Nicomachus
lesson (ADR-012) says humans and LLMs get wrong from memory, which is why absence is already
a machine step.

## WH(Y) Decision Statement

**In the context of** an ADR-012 sourcing pipeline that admits targets on name-grep absence
plus a statement type-check, and the project's stated aim that every target be a result a
working mathematician would call non-trivial,
**facing** the fact that name-grep is blind to one-shot-provable statements and to lemmas
already in mathlib under a different name, while the soundness and statement-binding gates
guard vacuity but not triviality and `difficulty` is an unenforced self-tag,
**we decided for** a deterministic **machine triviality probe** (`tools/sourcing/check_triviality.py`)
that elaborates the goal's closed `∀`-statement under `import Mathlib` against a fixed battery
of closing tactics (`first | rfl | trivial | decide | norm_num | omega | simp | simp_all | aesop | ring | linarith | tauto`),
reusing the ADR-011 binding-module template and `tools.lean_sig` (`foralltype`/`open_lines`/
`theorem_name`); because the full library is in scope, `simp`/`aesop` also discharge a renamed
duplicate, making the probe a *semantic* complement to name-grep absence. It gates **sourcing
admission** (advisory-first, then blocking), backstops with an **advisory changed-goals CI check**,
and ships a **report-only retro-audit** over the existing goals,
**and neglected** a pure-Loogle/LeanSearch semantic gate (network-nondeterministic; answers
"similar exists", not "trivially provable as stated"), a difficulty-threshold gate (the self-tag
just relocates the dishonesty), human-only curation (the Nicomachus lesson — absence is already
mechanised, triviality should be too), and blocking CI from day one (gate-a-weight per goal +
unknown false-positive rate),
**to achieve** a backlog whose every admitted target is machine-verified non-trivial-as-stated
and not a renamed duplicate, on the same rev-dated, JSON-verdict machinery as the absence check,
**accepting that** a one-shot tactic close is a *heuristic* for triviality with genuine false
positives (handled by a per-goal `- **Nontrivial-override:**` field + an allowlist for intentional
fixtures), that the probe is gate-a-weight so CI is changed-goals-only and advisory-first, that a
triviality claim has a shelf life like an absence claim (a mathlib bump can make a target a
near-duplicate — which is correct), and that proved-but-trivial work is **flagged for human
review, never auto-deleted** (it is kernel-verified, a curation signal not a soundness bug).

## Verdict trichotomy

A probe that fails to elaborate is not evidence of non-triviality. The tool reports:
`trivial` (a battery tactic closed it → reject, exit 1); `non-trivial` (elaborated, nothing
closed it → admit-eligible, exit 0); `probe-error` (the statement failed to elaborate — an
import/`open` gap or unknown identifier → surfaced, exit 2). At sourcing the goal already
type-checked under `UnsorryGoals`, so a `probe-error` there is almost always a fixable probe
import gap, not a real statement error. `native_decide` is excluded from the battery (forbidden
in `library/`, platform-nondeterministic); a timeout is conservatively classified `non-trivial`.

## Consequences

- **Positive.** Triviality and renamed-duplicate presence become a machine gate, not a memory
  call. The retro-audit gives maintainers a worklist of the trivial existing targets #387 asks about.
- **Cost.** Per-goal full-`Mathlib` elaboration is gate-a-weight; mitigated by running the block at
  human-paced sourcing, scoping CI to changed goals, and the advisory-first rollout.
- **Residue.** False positives are inherent to a tactic-close heuristic; the override field +
  allowlist + advisory-first rollout absorb them. Removal of flagged existing theorems stays a
  separate, human-approved step.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Non-triviality enforcement spec | Specification | specs/SPEC-033-A-Non-Trivial-Theorem-Enforcement.md |
| REF-2 | Backlog sourcing (the pipeline this refines) | Decision | ADR-012-Backlog-Sourcing.md |
| REF-3 | Statement-binding gate (template + `foralltype`/`open_lines` reuse) | Decision | ADR-011-Statement-Binding-Gate.md |
| REF-4 | Tracking issue | Issue | https://github.com/agenticsnz/unsorry/issues/387 |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
