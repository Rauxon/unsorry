import Lean.Linter.UnusedVariables
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Ring

/-!
# `pow_four_add_sq_add_one_not_prime` (goal `pow-four-add-sq-add-one-not-prime`)

For a natural `n` with `1 < n`, the number `n ^ 4 + n ^ 2 + 1` is composite.

This rests on the factorisation `n ^ 4 + n ^ 2 + 1 = (n ^ 2 + n + 1) *
(n ^ 2 - n + 1)`. Writing `n = m + 2` (legitimate since `1 < n`) clears the
truncated subtraction and exposes the two cofactors as honest natural-number
polynomials, `(m ^ 2 + 5 * m + 7) * (m ^ 2 + 3 * m + 3)`, each at least `3`, so
neither equals `1` and the product is not a prime.
-/

theorem pow_four_add_sq_add_one_not_prime (n : ℕ) (hn : 1 < n) :
    ¬ Nat.Prime (n ^ 4 + n ^ 2 + 1) := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 2 := ⟨n - 2, by omega⟩
  have h : (m + 2) ^ 4 + (m + 2) ^ 2 + 1
      = (m ^ 2 + 5 * m + 7) * (m ^ 2 + 3 * m + 3) := by ring
  rw [h]
  exact Nat.not_prime_mul (by omega) (by omega)

/-- The ADR-011 binding obligation that Gate A regenerates for this goal states
its type as `∀ (n : ℕ) (hn : 1 < n), ¬ Nat.Prime (n ^ 4 + n ^ 2 + 1)`, copying
the goal's binder names verbatim. `hn` does not occur in the conclusion, so the
unused-variables linter warns on it and the `--wfail` bar fails — in a generated
file this module cannot edit. Core Lean already exempts unused binders in the
arrow spelling `(h : P) → Q` of the same type (its builtin `depArrow` ignore
function), because a binder name there is signature documentation; this extends
that exemption to the `∀ (h : P), Q` spelling, exactly as the merged
`Unsorry.OneAddFourBFourthNotPrime` does for its goal. Lint-scope only: it has
no effect on elaboration, the kernel check, or the audit gate. -/
@[unused_variables_ignore_fn]
def Unsorry.PowFourAddSqAddOneNotPrime.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]
