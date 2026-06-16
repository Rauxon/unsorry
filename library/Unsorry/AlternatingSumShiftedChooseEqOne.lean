import Mathlib

theorem alternating_sum_shifted_choose_eq_one (n : ℕ) : ∑ k ∈ Finset.range (n + 1), (-1 : ℤ) ^ k * (n + 1).choose (k + 1) = 1 := by
  have hfull : (∑ k ∈ Finset.range (n + 1 + 1), ((-1) ^ k * (n + 1).choose k : ℤ)) = 0 := by
    have := @Int.alternating_sum_range_choose_eq_choose n (n + 1)
    rw [this]
    simp [Nat.choose_eq_zero_of_lt]
  rw [Finset.sum_range_succ'] at hfull
  simp only [Nat.choose_zero_right, pow_zero, one_mul, Nat.cast_one, mul_one] at hfull
  -- hfull : (∑ k ∈ range (n+1), (-1)^(k+1) * (n+1).choose (k+1)) + 1 = 0
  have key : ∑ k ∈ Finset.range (n + 1), ((-1) ^ (k + 1) * (n + 1).choose (k + 1) : ℤ)
      = - ∑ k ∈ Finset.range (n + 1), ((-1) ^ k * (n + 1).choose (k + 1) : ℤ) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro k _
    ring
  rw [key] at hfull
  linarith