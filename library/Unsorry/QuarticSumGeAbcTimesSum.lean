import Mathlib

theorem quartic_sum_ge_abc_times_sum (a b c : ℝ) : a ^ 4 + b ^ 4 + c ^ 4 ≥ a * b * c * (a + b + c) := by
  nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (a - c),
             sq_nonneg (a + b), sq_nonneg (b + c), sq_nonneg (a + c),
             sq_nonneg (a^2 - b^2), sq_nonneg (b^2 - c^2), sq_nonneg (a^2 - c^2),
             sq_nonneg (a^2 - b*c), sq_nonneg (b^2 - a*c), sq_nonneg (c^2 - a*b),
             sq_nonneg a, sq_nonneg b, sq_nonneg c]