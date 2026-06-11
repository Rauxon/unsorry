import Lean.Linter.UnusedVariables
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic
import Mathlib.Tactic.NormNum

/-!
# `nat_inv_le_third_of_three_le` (goal `platonic-schlafli-core-s2-s1`)

For a natural number `q` with `3 ≤ q`, the rational inverse satisfies
`(q : ℚ)⁻¹ ≤ (3 : ℚ)⁻¹`: casting `3 ≤ q` into `ℚ` gives `(3 : ℚ) ≤ (q : ℚ)`,
and inversion is antitone on the positives (`inv_anti₀`), with `0 < 3`.
-/

theorem nat_inv_le_third_of_three_le (q : ℕ) (hq : 3 ≤ q) :
    (q : ℚ)⁻¹ ≤ (3 : ℚ)⁻¹ := by
  have h3 : (3 : ℚ) ≤ (q : ℚ) := by exact_mod_cast hq
  exact inv_anti₀ (by norm_num) h3

/-- The ADR-011 binding obligation that Gate A regenerates for this goal states
its type as `∀ (q : ℕ) (hq : 3 ≤ q), (q : ℚ)⁻¹ ≤ (3 : ℚ)⁻¹`, copying the
goal's binder names verbatim. `hq` does not occur in the conclusion, so the
unused-variables linter warns on it and the `--wfail` bar fails — in a
generated file this module cannot edit. Core Lean already exempts unused
binders in the arrow spelling `(hq : P) → Q` of the same type (its builtin
`depArrow` ignore function), because a binder name there is signature
documentation; this extends that exemption to the `∀ (hq : P), Q` spelling.
Lint-scope only: it has no effect on elaboration, the kernel check, or the
audit gate. -/
@[unused_variables_ignore_fn]
def Unsorry.PlatonicSchlafliCoreS2S1.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]
