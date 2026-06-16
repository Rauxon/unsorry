import Mathlib

theorem sum_icc_recip_km1_k_kp1_telescope (n : ℕ) (hn : 2 ≤ n) : (∑ k ∈ Finset.Icc 2 n, (1 : ℚ) / (((k : ℚ) - 1) * k * (k + 1))) = 1 / 4 - 1 / (2 * (n : ℚ) * (n + 1)) := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.lt_or_ge m 2 with hm | hm
    · interval_cases m
      · omega
      · norm_num [Finset.Icc_self]
    · rw [Finset.sum_Icc_succ_top (by omega), ih hm]
      have hm1 : (1 : ℚ) ≤ (m : ℚ) := by exact_mod_cast Nat.one_le_of_lt hm
      have h0 : ((m : ℚ) + 1) - 1 ≠ 0 := by nlinarith
      have h1 : ((m : ℚ) + 1) ≠ 0 := by positivity
      have h2 : ((m : ℚ) + 1 + 1) ≠ 0 := by positivity
      have h3 : (m : ℚ) ≠ 0 := by nlinarith
      have h4 : (2 * (m : ℚ) * ((m : ℚ) + 1)) ≠ 0 := by positivity
      have h5 : (2 * ((m : ℚ) + 1) * ((m : ℚ) + 1 + 1)) ≠ 0 := by positivity
      push_cast
      field_simp
      ring