import Mathlib

theorem sum_icc_k_mul_three_k_add_one_eq (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, k * (3 * k + 1) = n * (n + 1) ^ 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    ring