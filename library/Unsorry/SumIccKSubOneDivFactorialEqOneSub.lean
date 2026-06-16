import Mathlib

theorem sum_icc_k_sub_one_div_factorial_eq_one_sub (n : ℕ) (hn : 1 ≤ n) : (∑ k ∈ Finset.Icc 1 n, ((k : ℚ) - 1) / Nat.factorial k) = 1 - 1 / Nat.factorial n := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_zero_or_pos m with h | h
    · -- m = 0
      subst h
      norm_num
    · -- m ≥ 1
      have hm : 1 ≤ m := h
      rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih hm]
      have hfm : (Nat.factorial m : ℚ) ≠ 0 := by
        exact_mod_cast Nat.factorial_ne_zero m
      have hfm1 : (Nat.factorial (m+1) : ℚ) ≠ 0 := by
        exact_mod_cast Nat.factorial_ne_zero (m+1)
      rw [Nat.factorial_succ]
      push_cast
      field_simp
      ring