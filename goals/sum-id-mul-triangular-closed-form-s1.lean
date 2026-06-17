import Mathlib

theorem sum_id_mul_triangular_range_succ (n : ℕ) : (∑ k ∈ Finset.range (n + 1), k * (k * (k + 1) / 2)) = (∑ k ∈ Finset.range n, k * (k * (k + 1) / 2)) + n * (n * (n + 1) / 2) := by
  sorry
