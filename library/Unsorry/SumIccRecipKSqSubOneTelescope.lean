import Mathlib

theorem sum_icc_recip_k_sq_sub_one_telescope (n : ℕ) (hn : 2 ≤ n) : (∑ k ∈ Finset.Icc 2 n, (1 : ℚ) / (k ^ 2 - 1)) = 3 / 4 - (2 * (n : ℚ) + 1) / (2 * n * (n + 1)) := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.lt_or_ge m 2 with hm | hm
    · interval_cases m
      · omega
      · norm_num [Finset.Icc_self]
    · rw [Finset.sum_Icc_succ_top (by omega)]
      rw [ih hm]
      have hm0 : (m : ℚ) ≠ 0 := by positivity
      have hm1 : (m : ℚ) + 1 ≠ 0 := by positivity
      have hm2 : (m : ℚ) + 2 ≠ 0 := by positivity
      push_cast
      have hsq : ((m : ℚ) + 1) ^ 2 - 1 = (m : ℚ) * ((m : ℚ) + 2) := by ring
      rw [hsq]
      field_simp
      ring