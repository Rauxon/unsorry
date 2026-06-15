import Mathlib

theorem sq_mul_sq_le_half_sum_fourth (x y : ℝ) : x^2 * y^2 ≤ (x^4 + y^4) / 2 := by
  have h1 : 0 ≤ (x^2 - y^2)^2 := by apply sq_nonneg
  linarith [sq_nonneg (x^2 - y^2)]