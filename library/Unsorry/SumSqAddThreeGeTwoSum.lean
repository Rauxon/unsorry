import Mathlib

theorem sum_sq_add_three_ge_two_sum (a b c : ℝ) : 2*(a + b + c) ≤ a^2 + b^2 + c^2 + 3 := by
  have h1 : (a - 1)^2 ≥ 0 := sq_nonneg (a - 1)
  have h2 : (b - 1)^2 ≥ 0 := sq_nonneg (b - 1)
  have h3 : (c - 1)^2 ≥ 0 := sq_nonneg (c - 1)
  linarith