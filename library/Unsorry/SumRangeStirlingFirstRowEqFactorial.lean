import Mathlib.Combinatorics.Enumerative.Stirling
import Mathlib.Algebra.BigOperators.Ring.Finset

/-- The `n`-th row of the (unsigned) Stirling numbers of the first kind sums to `n!`,
which reflects that every permutation of `n` elements has some number of disjoint cycles. -/
theorem sum_range_stirling_first_row_eq_factorial (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), Nat.stirlingFirst n k = n.factorial := by
  induction n with
  | zero => simp
  | succ n ih =>
    have h0 : n * Nat.stirlingFirst n 0 = 0 := by
      cases n with
      | zero => simp
      | succ m => simp
    have hsplit : (∑ k ∈ Finset.range (n + 1), Nat.stirlingFirst n (k + 1))
        + Nat.stirlingFirst n 0 = n.factorial := by
      rw [← Finset.sum_range_succ' (Nat.stirlingFirst n) (n + 1),
        Finset.sum_range_succ (Nat.stirlingFirst n) (n + 1),
        Nat.stirlingFirst_eq_zero_of_lt (Nat.lt_succ_self n), add_zero, ih]
    have hA : n * (∑ k ∈ Finset.range (n + 1), Nat.stirlingFirst n (k + 1))
        = n * n.factorial := by
      rw [← hsplit, Nat.mul_add, h0, add_zero]
    rw [Finset.sum_range_succ']
    simp only [Nat.stirlingFirst_succ_zero, add_zero, Nat.stirlingFirst_succ_succ]
    rw [Finset.sum_add_distrib, ← Finset.mul_sum, ih, hA, Nat.factorial_succ, add_one_mul]
