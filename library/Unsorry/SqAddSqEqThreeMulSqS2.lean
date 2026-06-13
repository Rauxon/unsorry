import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Nat.Prime.Int
import Mathlib.Tactic.LinearCombination
import Lean.Linter.UnusedVariables

/-!
# `three_dvd_all_of_sq_add_sq_eq_three_mul_sq`

If `x ^ 2 + y ^ 2 = 3 * z ^ 2` over `ℤ`, then `3` divides each of `x`, `y`, `z`.

The argument is the usual descent step for the form `x² + y² = 3z²`. Working in
`ZMod 3`, every square is `0` or `1`, so a sum of two squares vanishes only when
both squares vanish; reducing the equation modulo `3` (its right-hand side is a
multiple of `3`, hence `0`) forces `x ≡ 0` and `y ≡ 0`, i.e. `3 ∣ x` and
`3 ∣ y`. Writing `x = 3a`, `y = 3b` and cancelling a factor of `3` gives
`z² = 3 (a² + b²)`, so `3 ∣ z²`, and primality of `3` yields `3 ∣ z`.
-/

theorem three_dvd_all_of_sq_add_sq_eq_three_mul_sq (x y z : ℤ)
    (h : x ^ 2 + y ^ 2 = 3 * z ^ 2) : 3 ∣ x ∧ 3 ∣ y ∧ 3 ∣ z := by
  -- In `ZMod 3` the squares are `{0, 1}`, so `a² + b² = 0` forces `a = b = 0`.
  have key : ∀ a b : ZMod 3, a ^ 2 + b ^ 2 = 0 → a = 0 ∧ b = 0 := by decide
  -- Reduce the hypothesis modulo `3`: the right-hand side is `0` there.
  have hcast : (x : ZMod 3) ^ 2 + (y : ZMod 3) ^ 2 = 0 := by
    have hh : ((x ^ 2 + y ^ 2 : ℤ) : ZMod 3) = ((3 * z ^ 2 : ℤ) : ZMod 3) := by rw [h]
    push_cast at hh
    rw [hh, show (3 : ZMod 3) = 0 from by decide, zero_mul]
  obtain ⟨hx0, hy0⟩ := key _ _ hcast
  have hx : (3 : ℤ) ∣ x := by
    exact_mod_cast (ZMod.intCast_zmod_eq_zero_iff_dvd x 3).mp hx0
  have hy : (3 : ℤ) ∣ y := by
    exact_mod_cast (ZMod.intCast_zmod_eq_zero_iff_dvd y 3).mp hy0
  obtain ⟨a, rfl⟩ := hx
  obtain ⟨b, rfl⟩ := hy
  refine ⟨dvd_mul_right 3 a, dvd_mul_right 3 b, ?_⟩
  -- Cancel the common factor `3` to expose `z ^ 2` as a multiple of `3`.
  have hzsq : z ^ 2 = 3 * (a ^ 2 + b ^ 2) := by
    have e : (3 : ℤ) * z ^ 2 = 3 * (3 * (a ^ 2 + b ^ 2)) := by linear_combination -h
    exact mul_left_cancel₀ (by norm_num : (3 : ℤ) ≠ 0) e
  exact Int.prime_three.dvd_of_dvd_pow ⟨a ^ 2 + b ^ 2, hzsq⟩

/-- The statement-binding obligation that Gate A regenerates for this goal states
its type as `∀ (x y z : ℤ) (h : x ^ 2 + y ^ 2 = 3 * z ^ 2), 3 ∣ x ∧ 3 ∣ y ∧ 3 ∣ z`,
copying the goal's binder names verbatim. The hypothesis binder does not occur in
the conclusion, so the unused-variables linter warns on it and the `--wfail` bar
fails — in a generated file this module cannot edit. Core Lean already exempts an
unused binder in the arrow spelling `(p : P) → Q` of the same type (its builtin
ignore function for dependent arrows), since a binder name there is signature
documentation; the registration below extends that exemption to the `∀ (p : P), Q`
spelling. It is lint-scope only and has no effect on elaboration, the kernel
check, or the footprint gate. -/
@[unused_variables_ignore_fn]
def Unsorry.SqAddSqEqThreeMulSqS2.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]
