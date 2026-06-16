import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Ring

open Finset

/-- Twice the sum of consecutive centered-cube terms over `range n`
equals the biquadratic `n ^ 2 * (n ^ 2 + 1)`. -/
theorem sum_centered_cube_eq_biquadratic (n : ℕ) :
    2 * ∑ k ∈ Finset.range n, (k ^ 3 + (k + 1) ^ 3) = n ^ 2 * (n ^ 2 + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring
