import Mathlib

theorem alternating_sum_naturals (n : ℕ) : ∑ i ∈ Finset.range n, (-1 : ℤ) ^ i * (i + 1) = if Even n then - (n / 2 : ℤ) else (n / 2 : ℤ) + 1 := by
  sorry
