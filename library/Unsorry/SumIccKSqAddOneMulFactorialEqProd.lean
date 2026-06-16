import Mathlib

theorem sum_icc_k_sq_add_one_mul_factorial_eq_prod (n : ℕ) : (∑ k ∈ Finset.Icc 1 n, (k ^ 2 + 1) * Nat.factorial k) = n * Nat.factorial (n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega), ih]
    simp only [Nat.factorial_succ]
    ring