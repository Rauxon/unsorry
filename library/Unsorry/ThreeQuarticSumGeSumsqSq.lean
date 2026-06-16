import Mathlib

theorem three_quartic_sum_ge_sumsq_sq (a b c : ℝ) : (a ^ 2 + b ^ 2 + c ^ 2) ^ 2 ≤ 3 * (a ^ 4 + b ^ 4 + c ^ 4) := by
  nlinarith [sq_nonneg (a^2 - b^2), sq_nonneg (b^2 - c^2), sq_nonneg (a^2 - c^2)]
