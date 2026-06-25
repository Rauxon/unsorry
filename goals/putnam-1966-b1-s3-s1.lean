import Mathlib

theorem proj_x_abs_sum_eq_two_mul_pos_part (n : ℕ) (a : ZMod n → ℝ) : ∑ i : Fin n, |a (i + 1) - a i| = 2 * ∑ i : Fin n, max (a (i + 1) - a i) 0 := by
  sorry
