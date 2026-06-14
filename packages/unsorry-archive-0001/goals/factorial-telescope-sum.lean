import Mathlib

theorem sum_range_mul_factorial_telescope (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i * Nat.factorial i = Nat.factorial (n + 1) - 1 := by
  sorry
