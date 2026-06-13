import Lean.Linter.UnusedVariables
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Ring

/-!
# `one_add_four_b_fourth_not_prime` (goal `one-add-four-b-fourth-not-prime`)

For a natural `b` with `1 < b`, the number `1 + 4 * b ^ 4` is composite.

This is the Sophie Germain identity at `a = 1`: `1 + 4 * b ^ 4` factors as
`(2 * b ^ 2 - 2 * b + 1) * (2 * b ^ 2 + 2 * b + 1)`. Writing `b = m + 2`
(legitimate since `1 < b`) clears the truncated subtraction and exposes the
two cofactors as honest natural-number polynomials,
`(2 * m ^ 2 + 6 * m + 5) * (2 * m ^ 2 + 10 * m + 13)`, each at least `5`, so
neither equals `1` and the product is not a prime.
-/

theorem one_add_four_b_fourth_not_prime (b : ℕ) (hb : 1 < b) :
    ¬ Nat.Prime (1 + 4 * b ^ 4) := by
  obtain ⟨m, rfl⟩ : ∃ m, b = m + 2 := ⟨b - 2, by omega⟩
  have h : 1 + 4 * (m + 2) ^ 4
      = (2 * m ^ 2 + 6 * m + 5) * (2 * m ^ 2 + 10 * m + 13) := by ring
  rw [h]
  exact Nat.not_prime_mul (by omega) (by omega)

/-- The ADR-011 binding obligation that Gate A regenerates for this goal states
its type as `∀ (b : ℕ) (hb : 1 < b), ¬ Nat.Prime (1 + 4 * b ^ 4)`, copying the
goal's binder names verbatim. `hb` does not occur in the conclusion, so the
unused-variables linter warns on it and the `--wfail` bar fails — in a
generated file this module cannot edit. Core Lean already exempts unused
binders in the arrow spelling `(h : P) → Q` of the same type (its builtin
`depArrow` ignore function), because a binder name there is signature
documentation; this extends that exemption to the `∀ (h : P), Q` spelling,
exactly as the merged `Unsorry.PlatonicSchlafliCoreS2S1` does for its goal.
Lint-scope only: it has no effect on elaboration, the kernel check, or the
audit gate. -/
@[unused_variables_ignore_fn]
def Unsorry.OneAddFourBFourthNotPrime.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]
