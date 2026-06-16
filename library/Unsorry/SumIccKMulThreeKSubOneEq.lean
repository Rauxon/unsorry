import Mathlib

theorem sum_icc_k_mul_three_k_sub_one_eq (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, k * (3 * k - 1) = n ^ 2 * (n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    have h : 3 * (m + 1) - 1 = 3 * m + 2 := by omega
    rw [h]
    ring