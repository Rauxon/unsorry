import Mathlib.Data.Nat.Choose.Sum

/-!
# A weighted binomial sum identity

This module proves
`3 * ∑ k ∈ Finset.range (n + 1), k * n.choose k * 2 ^ k = 2 * n * 3 ^ n`.

The heart of the argument is the standard reindexing `(k+1) * (n+1).choose (k+1) = (n+1) * n.choose k`
together with the binomial theorem `∑ k, n.choose k * 2 ^ k = 3 ^ n`.
-/

open Finset

theorem sum_range_k_mul_choose_mul_two_pow_eq_two_n_three_pow (n : ℕ) :
    3 * ∑ k ∈ Finset.range (n + 1), k * n.choose k * 2 ^ k = 2 * n * 3 ^ n := by
  rcases n with _ | m
  · simp
  · -- The binomial theorem specialised at `2` and `1`.
    have hbinom : ∑ k ∈ Finset.range (m + 1), m.choose k * 2 ^ k = 3 ^ m := by
      have h := add_pow (2 : ℕ) 1 m
      simp only [one_pow, mul_one] at h
      rw [show (2 : ℕ) + 1 = 3 by norm_num] at h
      rw [h]
      exact Finset.sum_congr rfl (fun k _ => Nat.mul_comm _ _)
    -- Reindex the weighted sum, dropping the vanishing `k = 0` term.
    have hsum : ∑ k ∈ Finset.range (m + 1 + 1), k * (m + 1).choose k * 2 ^ k
        = ∑ k ∈ Finset.range (m + 1), 2 * (m + 1) * (m.choose k * 2 ^ k) := by
      rw [Finset.sum_range_succ']
      simp only [Nat.zero_mul, Nat.add_zero]
      apply Finset.sum_congr rfl
      intro k _
      have h1 : (k + 1) * (m + 1).choose (k + 1) = (m + 1) * m.choose k := by
        rw [Nat.add_one_mul_choose_eq, Nat.mul_comm (k + 1)]
      rw [h1, pow_succ]
      ring
    rw [hsum, ← Finset.mul_sum, hbinom]
    ring
