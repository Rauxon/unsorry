import Mathlib

theorem sum_icc_four_div_four_k_sub_one_four_k_add_three_telescope (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (4 : ℚ) / ((4 * (k : ℚ) - 1) * (4 * (k : ℚ) + 3)) = 1 / 3 - 1 / (4 * (n : ℚ) + 3) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega), ih]
    have hm : (0 : ℚ) ≤ (m : ℚ) := Nat.cast_nonneg m
    have h1 : (4 * ((m : ℚ) + 1) - 1) ≠ 0 := by nlinarith
    have h2 : (4 * (m : ℚ) + 3) ≠ 0 := by nlinarith
    have h3 : (4 * ((m : ℚ) + 1) + 3) ≠ 0 := by nlinarith
    push_cast
    field_simp
    ring
