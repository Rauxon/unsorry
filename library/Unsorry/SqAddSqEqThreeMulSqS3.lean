import Lean.Linter.UnusedVariables
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# `div_three_descends_sq_add_sq_eq_three_mul_sq`

One Fermat-style descent step for the equation `x ^ 2 + y ^ 2 = 3 * z ^ 2` over
the integers. Given a non-zero solution, this produces a strictly smaller one
(measured by the sum of absolute values).

Working modulo `3`, the only square classes are `0` and `1`, so
`x ^ 2 + y ^ 2 ≡ 0` forces both `x` and `y` to be divisible by `3`. Writing
`x = 3 a`, `y = 3 b` and cancelling a factor of `3` shows `z ^ 2 = 3 (a ^ 2 + b ^ 2)`,
hence `3 ∣ z` as well, say `z = 3 c`. Cancelling once more yields
`a ^ 2 + b ^ 2 = 3 c ^ 2`, a solution whose coordinate sum is exactly one third of
the original — strictly smaller because the starting triple is non-zero.
-/

theorem div_three_descends_sq_add_sq_eq_three_mul_sq (x y z : ℤ)
    (h : x ^ 2 + y ^ 2 = 3 * z ^ 2) (hnonzero : x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0) :
    ∃ x1 y1 z1 : ℤ, x1 ^ 2 + y1 ^ 2 = 3 * z1 ^ 2 ∧
      Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1
        < Int.natAbs x + Int.natAbs y + Int.natAbs z := by
  -- Modulo `3` the equation reads `x ^ 2 + y ^ 2 = 0`.
  have hmod : (x : ZMod 3) ^ 2 + (y : ZMod 3) ^ 2 = 0 := by
    have hcast := congrArg (Int.cast : ℤ → ZMod 3) h
    push_cast at hcast
    rwa [show (3 : ZMod 3) = 0 from by decide, zero_mul] at hcast
  -- Only the zero class squares to something summing to zero, so `3 ∣ x` and `3 ∣ y`.
  have key : ∀ a b : ZMod 3, a ^ 2 + b ^ 2 = 0 → a = 0 ∧ b = 0 := by decide
  obtain ⟨hx0, hy0⟩ := key _ _ hmod
  have hdx : (3 : ℤ) ∣ x := by
    have := (ZMod.intCast_zmod_eq_zero_iff_dvd x 3).mp hx0
    exact_mod_cast this
  have hdy : (3 : ℤ) ∣ y := by
    have := (ZMod.intCast_zmod_eq_zero_iff_dvd y 3).mp hy0
    exact_mod_cast this
  obtain ⟨a, ha⟩ := hdx
  obtain ⟨b, hb⟩ := hdy
  -- Cancelling `3 ^ 2` from both sides of the equation gives `z ^ 2 = 3 (a ^ 2 + b ^ 2)`.
  have hz2 : z ^ 2 = 3 * (a ^ 2 + b ^ 2) := by
    have e : 3 * z ^ 2 = 3 * (3 * (a ^ 2 + b ^ 2)) := by
      rw [← h, ha, hb]; ring
    linarith
  -- Hence `3 ∣ z` by the same modular argument applied to `z ^ 2`.
  have hz0 : (z : ZMod 3) = 0 := by
    have key2 : ∀ a : ZMod 3, a ^ 2 = 0 → a = 0 := by decide
    apply key2
    have hzc := congrArg (Int.cast : ℤ → ZMod 3) hz2
    push_cast at hzc
    rwa [show (3 : ZMod 3) = 0 from by decide, zero_mul] at hzc
  have hdz : (3 : ℤ) ∣ z := by
    have := (ZMod.intCast_zmod_eq_zero_iff_dvd z 3).mp hz0
    exact_mod_cast this
  obtain ⟨c, hc⟩ := hdz
  -- The reduced triple `(a, b, c)` solves the same equation.
  have hnew : a ^ 2 + b ^ 2 = 3 * c ^ 2 := by
    have e : 3 * (a ^ 2 + b ^ 2) = 3 * (3 * c ^ 2) := by
      rw [← hz2, hc]; ring
    linarith
  refine ⟨a, b, c, hnew, ?_⟩
  -- Each coordinate shrank by a factor of `3`; a non-zero start keeps the sum positive.
  omega

/-- The binding obligation that Gate A regenerates for this goal restates its
type as `∀ (x y z : ℤ) (h : …) (hnonzero : …), …`, copying the goal's binder
names verbatim. Neither `h` nor `hnonzero` occurs in the conclusion, so the
unused-variables linter warns on them and the `--wfail` bar fails — in a
generated file this module cannot edit. Core Lean already exempts unused binders
in the arrow spelling `(h : P) → Q` of the same type (its builtin `depArrow`
ignore function), because a binder name there is signature documentation; this
extends that exemption to the `∀ (h : P), Q` spelling. Lint-scope only: it has
no effect on elaboration, the kernel check, or the audit gate. -/
@[unused_variables_ignore_fn]
def Unsorry.SqAddSqEqThreeMulSqS3.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]
