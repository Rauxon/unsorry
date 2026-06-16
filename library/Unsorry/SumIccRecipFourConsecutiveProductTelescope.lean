import Mathlib

theorem sum_icc_recip_four_consecutive_product_telescope (n : ℕ) (hn : 1 ≤ n) :
    ∑ k ∈ Finset.Icc 1 n, (1 : ℚ) / (k * (k + 1) * (k + 2) * (k + 3))
      = 1 / 18 - 1 / (3 * (n + 1) * (n + 2) * (n + 3)) := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_zero_or_pos m with hm | hm
    · -- m = 0
      subst hm
      simp [Finset.Icc_self]
      norm_num
    · -- m ≥ 1
      have hm1 : 1 ≤ m := hm
      rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih hm1]
      have hc : ((m : ℚ) + 1) ≠ 0 := by positivity
      have hc2 : ((m : ℚ) + 2) ≠ 0 := by positivity
      have hc3 : ((m : ℚ) + 3) ≠ 0 := by positivity
      have hc4 : ((m : ℚ) + 1 + 1) ≠ 0 := by positivity
      have hc5 : ((m : ℚ) + 1 + 2) ≠ 0 := by positivity
      have hc6 : ((m : ℚ) + 1 + 3) ≠ 0 := by positivity
      push_cast
      field_simp
      ring