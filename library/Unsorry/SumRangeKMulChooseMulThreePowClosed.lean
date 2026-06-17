import Mathlib.Data.Nat.Choose.Sum

open Finset

/-- A closed form for the weighted binomial sum `∑ k C(n,k) 3^k`, multiplied by `4`.

The proof rests on two standard facts: the row identity
`(j+1) C(n, j+1) = (n+1) C(n-1, j)` (here `Nat.add_one_mul_choose_eq`) lets us reindex the
sum after dropping its vanishing `k = 0` term, and the binomial theorem (`add_pow`) collapses the
remaining row sum `∑ j C(n-1, j) 3^j` to `4^(n-1)`. -/
theorem sum_range_k_mul_choose_mul_three_pow_closed (n : ℕ) :
    4 * ∑ k ∈ Finset.range (n + 1), k * n.choose k * 3 ^ k = 3 * n * 4 ^ n := by
  cases n with
  | zero => simp
  | succ m =>
    have hbin : ∑ j ∈ range (m + 1), m.choose j * 3 ^ j = 4 ^ m := by
      have h := add_pow (3 : ℕ) 1 m
      simp only [one_pow, mul_one] at h
      rw [show (3 : ℕ) + 1 = 4 from rfl] at h
      rw [h]
      exact Finset.sum_congr rfl (fun k _ => Nat.mul_comm _ _)
    have key : ∀ j ∈ range (m + 1),
        (j + 1) * (m + 1).choose (j + 1) * 3 ^ (j + 1)
          = 3 * (m + 1) * (m.choose j * 3 ^ j) := by
      intro j _
      have h : (m + 1).choose (j + 1) * (j + 1) = (m + 1) * m.choose j :=
        (Nat.add_one_mul_choose_eq m j).symm
      calc (j + 1) * (m + 1).choose (j + 1) * 3 ^ (j + 1)
          = ((m + 1).choose (j + 1) * (j + 1)) * 3 ^ (j + 1) := by ring
        _ = ((m + 1) * m.choose j) * 3 ^ (j + 1) := by rw [h]
        _ = 3 * (m + 1) * (m.choose j * 3 ^ j) := by rw [pow_succ]; ring
    have hsum : ∑ k ∈ range (m + 1 + 1), k * (m + 1).choose k * 3 ^ k
        = 3 * (m + 1) * 4 ^ m := by
      rw [Finset.sum_range_succ']
      simp only [zero_mul, add_zero]
      rw [Finset.sum_congr rfl key, ← Finset.mul_sum, hbin]
    rw [hsum]
    ring
