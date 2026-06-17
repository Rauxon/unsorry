import Mathlib

theorem sum_icc_recip_factorial_sub_recip_factorial_telescopes (n : ℕ) (hn : 1 ≤ n) : (∑ k ∈ Finset.Icc 1 n, (1 / Nat.factorial (k - 1) - 1 / Nat.factorial k : ℚ)) = 1 - 1 / Nat.factorial n := by
  sorry
