import Mathlib

theorem sum_range_pow_four_closed (n : ℕ) : 30 * (∑ k ∈ Finset.range (n + 1), (k : ℤ) ^ 4) = n * (n + 1) * (2 * n + 1) * (3 * n ^ 2 + 3 * n - 1) := by
  sorry
