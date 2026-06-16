import Mathlib

theorem prod_icc_one_add_recip_k_sq_add_two_k_telescope (n : ℕ) (hn : 1 ≤ n) : (∏ k ∈ Finset.Icc 1 n, (1 + 1 / ((k : ℚ) ^ 2 + 2 * k))) = 2 * ((n : ℚ) + 1) / (n + 2) := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_zero_or_pos m with h | h
    · -- m = 0, n = 1
      subst h
      norm_num
    · -- m ≥ 1
      have hm : 1 ≤ m := h
      rw [Finset.prod_Icc_succ_top (by omega : 1 ≤ m + 1), ih hm]
      have hm0 : (m : ℚ) ≥ 0 := Nat.cast_nonneg m
      have h1 : ((m : ℚ) + 2) ≠ 0 := by positivity
      have h2 : ((m : ℚ) + 1) ^ 2 + 2 * ((m : ℚ) + 1) ≠ 0 := by positivity
      have h3 : ((m : ℚ) + 3) ≠ 0 := by positivity
      push_cast
      field_simp
      ring