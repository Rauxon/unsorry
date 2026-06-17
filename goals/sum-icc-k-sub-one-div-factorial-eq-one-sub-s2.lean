import Mathlib

theorem sum_icc_one_shift_sub_telescope_rat (f : ℕ → ℚ) (n : ℕ) : (∑ k ∈ Finset.Icc 1 n, (f (k - 1) - f k)) = f 0 - f n := by
  sorry
