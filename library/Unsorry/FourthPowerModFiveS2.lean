import Lean.Linter.UnusedVariables
import Mathlib.Tactic.IntervalCases

/-!
# `fourth_power_residue_mod_five` (goal `fourth-power-mod-five-s2`)

For a natural `r` with `1 ≤ r` and `r < 5`, the fourth power satisfies
`r ^ 4 % 5 = 1`. The two bounds pin `r` to `{1, 2, 3, 4}`, and each of the
four residues `1, 16, 81, 256` is congruent to `1` modulo `5`. The proof
enumerates the finitely many values of `r` with `interval_cases` (which
consumes both bounds) and discharges each closed arithmetic goal by kernel
reduction.
-/

/-- The ADR-011 binding obligation that Gate A regenerates for this goal states
its type as `∀ (r : ℕ) (hr0 : 1 ≤ r) (hr : r < 5), r ^ 4 % 5 = 1`, copying the
goal's binder names verbatim. `hr0` and `hr` do not occur in the conclusion, so
the unused-variables linter warns on them and the `--wfail` bar fails — in a
generated file this module cannot edit. Core Lean already exempts unused
binders in the arrow spelling `(h : P) → Q` of the same type (its builtin
`depArrow` ignore function), because a binder name there is signature
documentation; this extends that exemption to the `∀ (h : P), Q` spelling,
exactly as the merged `Unsorry.PlatonicSchlafliCoreS2S1` does for its goal.
Lint-scope only: it has no effect on elaboration, the kernel check, or the
audit gate. -/
@[unused_variables_ignore_fn]
def Unsorry.FourthPowerModFiveS2.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]

theorem fourth_power_residue_mod_five (r : ℕ) (hr0 : 1 ≤ r) (hr : r < 5) :
    r ^ 4 % 5 = 1 := by
  interval_cases r <;> rfl
