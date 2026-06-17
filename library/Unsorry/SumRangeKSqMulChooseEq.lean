import Mathlib.Data.Nat.Choose.Sum

/-!
# Weighted binomial sum identity

This module proves `4 * ∑ k ∈ range (n+1), k^2 * C(n,k) = n * (n+1) * 2^n`.

The proof goes by induction on `n`.  The key step is a recurrence for the
weighted sum, obtained by reindexing and Pascal's rule, which expresses the
sum for `n + 1` in terms of the sum for `n` together with the linear weighted
sum `∑ k * C(n,k)`.
-/

open Finset

/-- Doubling the linear weighted binomial sum removes the natural subtraction
that appears in `Nat.sum_range_mul_choose`. -/
private lemma two_sum_mul_choose (n : ℕ) :
    2 * ∑ k ∈ Finset.range (n + 1), k * n.choose k = n * 2 ^ n := by
  rw [Nat.sum_range_mul_choose]
  cases n with
  | zero => simp
  | succ m => rw [Nat.add_sub_cancel, pow_succ]; ring

/-- The recurrence for the squared weighted binomial sum. -/
private lemma sq_choose_succ (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1 + 1), k ^ 2 * (n + 1).choose k
      = 2 * (∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k) + (n + 1) * 2 ^ n := by
  have hM : 2 * ∑ i ∈ Finset.range (n + 1), i * n.choose i = n * 2 ^ n :=
    two_sum_mul_choose n
  have hP : ∑ i ∈ Finset.range (n + 1), (i + 1) ^ 2 * n.choose i
      = (∑ i ∈ Finset.range (n + 1), i ^ 2 * n.choose i)
        + 2 * (∑ i ∈ Finset.range (n + 1), i * n.choose i) + 2 ^ n := by
    rw [Finset.sum_congr rfl
      (fun i _ => show (i + 1) ^ 2 * n.choose i
        = i ^ 2 * n.choose i + 2 * (i * n.choose i) + n.choose i by ring)]
    rw [Finset.sum_add_distrib, Finset.sum_add_distrib, ← Finset.mul_sum,
      Nat.sum_range_choose]
  have hQ : ∑ i ∈ Finset.range (n + 1), (i + 1) ^ 2 * n.choose (i + 1)
      = ∑ i ∈ Finset.range (n + 1), i ^ 2 * n.choose i := by
    rw [Finset.sum_range_succ (fun i => (i + 1) ^ 2 * n.choose (i + 1)) n,
      Finset.sum_range_succ' (fun i => i ^ 2 * n.choose i) n,
      Nat.choose_succ_self n]
    simp
  rw [Finset.sum_range_succ' (fun k => k ^ 2 * (n + 1).choose k) (n + 1)]
  have hsplit : ∑ i ∈ Finset.range (n + 1), (i + 1) ^ 2 * (n + 1).choose (i + 1)
      = (∑ i ∈ Finset.range (n + 1), (i + 1) ^ 2 * n.choose i)
        + ∑ i ∈ Finset.range (n + 1), (i + 1) ^ 2 * n.choose (i + 1) := by
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl (fun i _ => ?_)
    rw [Nat.choose_succ_succ' n i]; ring
  rw [hsplit, hP, hQ, hM]
  ring

theorem sum_range_k_sq_mul_choose_eq (n : ℕ) :
    4 * ∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k = n * (n + 1) * 2 ^ n := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [sq_choose_succ m]
    set S := ∑ k ∈ Finset.range (m + 1), k ^ 2 * m.choose k with hS
    have h : 4 * (2 * S + (m + 1) * 2 ^ m) = 2 * (4 * S) + 4 * ((m + 1) * 2 ^ m) := by ring
    rw [h, ih, pow_succ]
    ring
