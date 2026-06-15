import Mathlib

theorem four_mul_prod_le_sq_sum (a b : ℝ) : 4 * (a * b) ≤ (a + b) ^ 2 := by
  nlinarith [sq_nonneg (a - b)]