import Mathlib

theorem sum_icc_three_div_three_k_sub_one_three_k_add_two_telescope (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (3 : ℚ) / ((3 * (k : ℚ) - 1) * (3 * (k : ℚ) + 2)) = 1 / 2 - 1 / (3 * (n : ℚ) + 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    have hm : (0 : ℚ) ≤ (m : ℚ) := Nat.cast_nonneg m
    have h1 : (3 * ((m : ℚ) + 1) - 1) ≠ 0 := by nlinarith
    have h2 : (3 * ((m : ℚ) + 1) + 2) ≠ 0 := by nlinarith
    have h3 : (3 * (m : ℚ) + 2) ≠ 0 := by nlinarith
    push_cast
    field_simp
    ring