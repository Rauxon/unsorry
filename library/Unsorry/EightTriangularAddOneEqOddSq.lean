import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Linarith

theorem eight_triangular_add_one_eq_odd_sq (n : ℕ) :
    8 * (∑ i ∈ Finset.range (n + 1), i) + 1 = (2 * n + 1) ^ 2 := by
  have h : (∑ i ∈ Finset.range (n + 1), i) * 2 = (n + 1) * n := by
    rw [Finset.sum_range_id_mul_two, Nat.add_sub_cancel]
  nlinarith [h]
