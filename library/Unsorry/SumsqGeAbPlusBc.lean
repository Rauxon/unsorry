import Mathlib

theorem sumsq_ge_ab_plus_bc (a b c : ℝ) : a * b + b * c ≤ a ^ 2 + b ^ 2 + c ^ 2 := by
  nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (a + c), sq_nonneg b]
