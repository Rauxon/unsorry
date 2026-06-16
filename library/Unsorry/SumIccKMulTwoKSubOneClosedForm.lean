import Mathlib

theorem sum_icc_k_mul_two_k_sub_one_closed_form (n : ℕ) : 6 * ∑ k ∈ Finset.Icc 1 n, k * (2 * k - 1) = n * (n + 1) * (4 * n - 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega), Nat.mul_add, ih]
    cases m with
    | zero => simp
    | succ p =>
      have h1 : 2 * (p + 1 + 1) - 1 = 2 * p + 3 := by omega
      have h2 : 4 * (p + 1) - 1 = 4 * p + 3 := by omega
      have h3 : 4 * (p + 1 + 1) - 1 = 4 * p + 7 := by omega
      rw [h1, h2, h3]
      ring