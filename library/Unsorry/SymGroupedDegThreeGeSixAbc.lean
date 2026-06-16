import Mathlib

theorem sym_grouped_deg_three_ge_six_abc (a b c : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c) : 6 * (a * b * c) ≤ a ^ 2 * (b + c) + b ^ 2 * (c + a) + c ^ 2 * (a + b) := by
  nlinarith [mul_nonneg ha (sq_nonneg (b - c)), mul_nonneg hb (sq_nonneg (a - c)), mul_nonneg hc (sq_nonneg (a - b)), mul_nonneg (mul_nonneg ha hb) hc]