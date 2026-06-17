import Mathlib.Data.Nat.Choose.Sum

open Finset

/-- Twice the weighted sum `∑ (k+1) * C(n,k)` over `k = 0 … n` equals `(n+2) * 2 ^ n`.

The proof reflects the summation index `k ↦ n - k`: by the symmetry of binomial
coefficients each summand `(k+1) * C(n,k)` is matched with `(n-k+1) * C(n,k)`, and
adding the two equal sums collapses every coefficient to `(n+2)`, leaving
`(n+2) * ∑ C(n,k) = (n+2) * 2 ^ n`. -/
theorem sum_range_k_plus_one_mul_choose (n : ℕ) :
    2 * ∑ k ∈ Finset.range (n + 1), (k + 1) * n.choose k = (n + 2) * 2 ^ n := by
  have key : ∑ k ∈ range (n + 1), (n - k + 1) * n.choose k
      = ∑ k ∈ range (n + 1), (k + 1) * n.choose k := by
    rw [← Finset.sum_range_reflect (fun k => (k + 1) * n.choose k) (n + 1)]
    apply Finset.sum_congr rfl
    intro k hk
    rw [mem_range, Nat.lt_succ_iff] at hk
    simp only [Nat.add_sub_cancel]
    rw [Nat.choose_symm hk]
  rw [two_mul]
  nth_rewrite 2 [← key]
  rw [← Finset.sum_add_distrib, ← Nat.sum_range_choose n, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro k hk
  rw [mem_range, Nat.lt_succ_iff] at hk
  rw [← Nat.add_mul]
  congr 1
  omega
