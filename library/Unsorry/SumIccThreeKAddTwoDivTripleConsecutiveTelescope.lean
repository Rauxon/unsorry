import Mathlib

theorem sum_icc_three_k_add_two_div_triple_consecutive_telescope (n : ℕ) :
    ∑ k ∈ Finset.Icc 1 n,
      ((3 * (k : ℚ) + 2) / ((k : ℚ) * ((k : ℚ) + 1) * ((k : ℚ) + 2)))
      = 2 - 1 / ((n : ℚ) + 1) - 2 / ((n : ℚ) + 2) := by
  induction n with
  | zero => norm_num
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    have h1 : ((m : ℚ) + 1) ≠ 0 := by positivity
    have h2 : ((m : ℚ) + 2) ≠ 0 := by positivity
    have h3 : ((m : ℚ) + 1 + 1) ≠ 0 := by positivity
    have h4 : ((m : ℚ) + 1 + 2) ≠ 0 := by positivity
    have hc : ((m : ℚ) + 1) ≠ 0 := h1
    push_cast
    field_simp
    ring