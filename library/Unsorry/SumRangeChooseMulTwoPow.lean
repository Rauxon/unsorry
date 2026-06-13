import Mathlib.Data.Nat.Choose.Sum

/-- A special case of the binomial theorem: the weighted row sum of Pascal's
triangle with weights `2 ^ k` collapses to a power of three. -/
theorem sum_range_choose_mul_two_pow (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), n.choose k * 2 ^ k = 3 ^ n := by
  rw [show (3 : ℕ) = 2 + 1 by norm_num, add_pow]
  simp only [one_pow, mul_one]
  exact Finset.sum_congr rfl fun k _ => Nat.mul_comm _ _
