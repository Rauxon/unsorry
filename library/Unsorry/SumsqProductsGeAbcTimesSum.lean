import Mathlib

theorem sumsq_products_ge_abc_times_sum (a b c : ℝ) :
    (a * b) ^ 2 + (b * c) ^ 2 + (c * a) ^ 2 ≥ a * b * c * (a + b + c) := by
  nlinarith [sq_nonneg (a * b - b * c), sq_nonneg (b * c - c * a), sq_nonneg (c * a - a * b)]