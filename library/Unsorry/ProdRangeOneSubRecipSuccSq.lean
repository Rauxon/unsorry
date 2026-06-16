import Mathlib

theorem prod_range_one_sub_recip_succ_sq (n : ℕ) (hn : 1 ≤ n) : ∏ k ∈ Finset.Icc 1 n, ((1 : ℚ) - 1 / (((k : ℚ) + 1) ^ 2)) = ((n : ℚ) + 2) / (2 * ((n : ℚ) + 1)) := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_zero_or_pos m with hm0 | hm0
    · -- m = 0
      subst hm0
      simp [Finset.Icc_self]
      norm_num
    · -- m ≥ 1
      have hm : 1 ≤ m := hm0
      rw [Finset.prod_Icc_succ_top (by omega : 1 ≤ m + 1), ih hm]
      have hm1 : ((m : ℚ) + 1) ≠ 0 := by positivity
      have hm2 : ((m : ℚ) + 2) ≠ 0 := by positivity
      push_cast
      field_simp
      ring