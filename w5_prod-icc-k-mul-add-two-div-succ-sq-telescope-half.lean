import Mathlib

theorem prod_icc_k_mul_add_two_div_succ_sq_telescope_half (n : ℕ) (hn : 1 ≤ n) :
    ∏ k ∈ Finset.Icc 1 n, ((k : ℝ) * ((k : ℝ) + 2)) / ((k : ℝ) + 1) ^ 2
      = ((n : ℝ) + 2) / (2 * ((n : ℝ) + 1)) := by
  induction n with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_or_gt_of_le hn with h1 | h1
    · -- m+1 = 1, so m = 0
      have : m = 0 := by omega
      subst this
      simp [Finset.Icc_self]
      norm_num
    · -- m ≥ 1
      have hm : 1 ≤ m := by omega
      rw [Finset.prod_Icc_succ_top (by omega : 1 ≤ m + 1), ih hm]
      have hm1 : (m : ℝ) + 1 > 0 := by positivity
      have hm2 : (m : ℝ) + 2 > 0 := by positivity
      have hm3 : (m : ℝ) + 1 + 1 > 0 := by positivity
      push_cast
      field_simp
      ring
