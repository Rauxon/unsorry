import Mathlib

theorem sum_icc_cube_diff_recip_telescope (n : ℕ) (hn : 1 ≤ n) : (∑ k ∈ Finset.Icc 1 n, (3 * (k : ℚ) ^ 2 + 3 * k + 1) / (k ^ 3 * (k + 1) ^ 3)) = 1 - 1 / ((n : ℚ) + 1) ^ 3 := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_or_gt_of_le hn with h | h
    · -- m + 1 = 1, so m = 0
      have hm : m = 0 := by omega
      subst hm
      simp [Finset.Icc_self]
      norm_num
    · -- m ≥ 1
      have hm : 1 ≤ m := by omega
      rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih hm]
      have hk1 : ((m : ℚ) + 1) ≠ 0 := by positivity
      have hk2 : ((m : ℚ) + 1 + 1) ≠ 0 := by positivity
      push_cast
      field_simp
      ring
