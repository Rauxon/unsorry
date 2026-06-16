import Mathlib

theorem sum_icc_k_sq_add_one_mul_factorial_eq_pronic_factorial (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (k^2 + 1) * k.factorial = n * (n+1).factorial := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    rw [Nat.factorial_succ (m+1), Nat.factorial_succ m]
    ring