import Mathlib

theorem factorial_term_eq_recip_sub_recip_rat (k : ℕ) (hk : 1 ≤ k) : (((k : ℚ) - 1) / (Nat.factorial k : ℚ)) = (1 : ℚ) / (Nat.factorial (k - 1) : ℚ) - (1 : ℚ) / (Nat.factorial k : ℚ) := by
  sorry
