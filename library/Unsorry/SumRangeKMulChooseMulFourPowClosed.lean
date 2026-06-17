import Mathlib

/-- The weighted binomial sum `∑ k, k * C(n,k) * 4^k` has the closed form
`4 * n * 5^n` after multiplying through by `5`.  The key facts are the binomial
theorem `∑ k, C(n,k) * 4^k = 5^n` and the absorption identity
`(k+1) * C(m+1, k+1) = (m+1) * C(m, k)`. -/
theorem sum_range_k_mul_choose_mul_four_pow_closed (n : ℕ) :
    5 * ∑ k ∈ Finset.range (n + 1), k * n.choose k * 4 ^ k = 4 * n * 5 ^ n := by
  have binom : ∀ m : ℕ, ∑ k ∈ Finset.range (m + 1), m.choose k * 4 ^ k = 5 ^ m := by
    intro m
    rw [show (5 : ℕ) = 4 + 1 by norm_num, add_pow]
    simp only [one_pow, mul_one, Nat.cast_id]
    refine Finset.sum_congr rfl ?_
    intro k _
    ring
  cases n with
  | zero => simp
  | succ m =>
    show 5 * ∑ k ∈ Finset.range (m + 1 + 1), k * (m + 1).choose k * 4 ^ k
        = 4 * (m + 1) * 5 ^ (m + 1)
    rw [Finset.sum_range_succ']
    simp only [zero_mul, add_zero]
    have step : ∀ k, (k + 1) * (m + 1).choose (k + 1) * 4 ^ (k + 1)
        = (m + 1) * 4 * (m.choose k * 4 ^ k) := by
      intro k
      have h : (k + 1) * (m + 1).choose (k + 1) = (m + 1) * m.choose k := by
        rw [mul_comm]
        exact (Nat.add_one_mul_choose_eq m k).symm
      calc (k + 1) * (m + 1).choose (k + 1) * 4 ^ (k + 1)
          = ((k + 1) * (m + 1).choose (k + 1)) * 4 ^ (k + 1) := by ring
        _ = ((m + 1) * m.choose k) * 4 ^ (k + 1) := by rw [h]
        _ = (m + 1) * 4 * (m.choose k * 4 ^ k) := by ring
    simp only [step]
    rw [← Finset.mul_sum, binom]
    ring
