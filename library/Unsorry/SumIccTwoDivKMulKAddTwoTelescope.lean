import Mathlib

theorem sum_icc_two_div_k_mul_k_add_two_telescope (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (2 : ℚ) / ((k : ℚ) * ((k : ℚ) + 2)) = 3 / 2 - 1 / ((n : ℚ) + 1) - 1 / ((n : ℚ) + 2) := by
  induction n with
  | zero => norm_num
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega), ih]
    have h1 : (m : ℚ) + 1 ≠ 0 := by positivity
    have h2 : (m : ℚ) + 2 ≠ 0 := by positivity
    have h3 : ((m : ℚ) + 1) + 1 ≠ 0 := by positivity
    have h4 : ((m : ℚ) + 1) + 2 ≠ 0 := by positivity
    have hk : ((m : ℚ) + 1) ≠ 0 := by positivity
    push_cast
    field_simp
    ring