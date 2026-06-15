import Mathlib

theorem sum_range_pow_six_closed_form (n : ℕ) : 42 * ∑ i ∈ Finset.range (n + 1), i ^ 6 = n * (n + 1) * (2 * n + 1) * (3 * n ^ 4 + 6 * n ^ 3 - 3 * n + 1) := by
  sorry
