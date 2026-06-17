import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Push

/-!
# Sum of reciprocals of consecutive products

This module proves that the partial sums of the series whose `k`-th term is
`1 / ((k + 1) * (k + 2))` telescope to `n / (n + 1)`.
-/

/-- The partial sum of `1 / ((k + 1) * (k + 2))` over `k < n` equals `n / (n + 1)`. -/
theorem sum_range_recip_consecutive (n : ℕ) :
    ∑ k ∈ Finset.range n, (1 : ℚ) / ((k + 1) * (k + 2)) = n / (n + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : (n : ℚ) + 1 ≠ 0 := by positivity
    have h2 : (n : ℚ) + 2 ≠ 0 := by positivity
    push_cast
    field_simp
    ring
