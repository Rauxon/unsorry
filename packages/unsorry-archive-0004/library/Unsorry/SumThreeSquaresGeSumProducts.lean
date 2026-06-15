import Mathlib

theorem sum_three_squares_ge_sum_products (a b c : ℝ) :
    a * b + b * c + c * a ≤ a ^ 2 + b ^ 2 + c ^ 2 := by
  nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (c - a)]
