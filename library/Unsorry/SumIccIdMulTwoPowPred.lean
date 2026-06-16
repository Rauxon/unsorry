import Mathlib

theorem sum_icc_id_mul_two_pow_pred (n : ℕ) : (∑ k ∈ Finset.Icc 1 n, (k : ℤ) * 2 ^ (k - 1)) = (n - 1) * 2 ^ n + 1 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega), ih]
    have h : m + 1 - 1 = m := by omega
    rw [h]
    push_cast
    ring