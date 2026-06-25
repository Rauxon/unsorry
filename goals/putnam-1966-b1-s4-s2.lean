import Mathlib

theorem putnam_1966_b1_abs_sum_eq_two_mul_pos_part (n : ℕ) (d : Fin n → ℝ) (h : (∑ i : Fin n, d i) = 0) : (∑ i : Fin n, |d i|) = 2 * ∑ i : Fin n, max (d i) 0 := by
  sorry
