import Mathlib

theorem sum_icc_two_k_add_one_div_k_sq_succ_sq_telescope (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (2 * (k : ℚ) + 1) / ((k : ℚ) ^ 2 * ((k : ℚ) + 1) ^ 2) = 1 - 1 / ((n : ℚ) + 1) ^ 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    have h1 : ((m : ℚ) + 1) ≠ 0 := by positivity
    have h2 : ((m : ℚ) + 1 + 1) ≠ 0 := by positivity
    push_cast
    field_simp
    ring