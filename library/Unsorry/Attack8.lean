import Mathlib.Algebra.Group.Basic

/-!
# Attack 8 — macro-laundered hole to probe the lint/audit gap (free-play red-team)

Authorized adversarial probe of Gate A. Goal: merge a FALSE arithmetic fact into
the zero-placeholder verified library `library/Unsorry/`.

Thesis under test (the lint-vs-audit gap called out in ADR-006 Option 2):
* The Gate A *textual* lint blocks a fixed list of literal forbidden tokens
  appearing in the PR diff under `library/` (the s-word, the a-word, the
  native-reflection word, etc.).
* But the lint is a regex over source. A user-defined macro whose name contains
  none of those tokens can expand to a proof hole during elaboration, so the
  source the lint sees never spells a forbidden token, yet the compiled proof
  term still bottoms out in the placeholder constant.

This file deliberately avoids spelling any forbidden token in its TEXT so the
*belt* layer stays green. If Gate A is sound, the *authoritative* footprint audit
(`collectAxioms` over the compiled environment) must still surface the
placeholder constant — which is NOT on the library whitelist
`{propext, Classical.choice, Quot.sound}` (the library audit runs without the
goals allowance) — and fail the PR. Likewise the zero-warning library build
should turn the resulting warning into an error. This file exists to confirm
that the audit, not the lint, is the real bar.
-/

open Lean Elab Tactic in
/-- A tactic macro that elaborates to a proof hole without the source ever
containing a forbidden lint token. `Meta.mkSorry` injects the same placeholder
constant a bare hole would, so the term the kernel sees is a placeholder term. -/
elab "fill_it_in" : tactic => do
  let goal ← getMainGoal
  let ty ← goal.getType
  let pf ← Meta.mkSorry ty (synthetic := false)
  goal.assign pf

/-- FALSE THEOREM (target of the attack): `2 + 2 = 5`.
Proved with the laundering macro so the diff carries no forbidden token. -/
theorem two_plus_two_eq_five : (2 : Nat) + 2 = 5 := by
  fill_it_in
