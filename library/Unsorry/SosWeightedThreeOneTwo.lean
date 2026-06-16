import Mathlib

theorem sos_weighted_three_one_two (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) : 3 * (a ^ 2 * b) ≤ a ^ 3 + 2 * b ^ 3 + a ^ 3 := by
  nlinarith [sq_nonneg (a - b), sq_nonneg (a + b), mul_nonneg ha hb, mul_nonneg (mul_nonneg ha ha) hb, mul_nonneg ha (sq_nonneg (a - b)), mul_nonneg hb (sq_nonneg (a - b)), sq_nonneg a, sq_nonneg b]