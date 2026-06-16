import Mathlib

theorem sum_icc_recip_step_four_pair_eq_n_div (n : ℕ) :
    ∑ k ∈ Finset.Icc 1 n, (1 : ℝ) / ((4 * k - 3) * (4 * k + 1)) = n / (4 * n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    push_cast
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    have h1 : (4 * (m : ℝ) + 1) ≠ 0 := by positivity
    have h2 : (4 * ((m : ℝ) + 1) - 3) ≠ 0 := by nlinarith
    have h3 : (4 * ((m : ℝ) + 1) + 1) ≠ 0 := by positivity
    rw [div_add_div _ _ h1 (mul_ne_zero h2 h3), div_eq_div_iff (mul_ne_zero h1 (mul_ne_zero h2 h3)) h3]
    ring