import Mathlib

theorem putnam_1962_b5_sum_eq_pow_sum_div (n : ℤ) (ng1 : n > 1) : ∑ i : Finset.Icc 1 n, ((i : ℝ) / n) ^ (n : ℝ) = (∑ i ∈ Finset.Icc 1 n, (i : ℝ) ^ (n : ℝ)) / (n : ℝ) ^ (n : ℝ) := by
  sorry
