import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Data.Nat.Choose.Sum
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Unsorry.SumRangeSqMulChoose

/-- The fourfold falling-factorial weighted sum of binomial coefficients has the
closed form `n * (n - 1) * 2 ^ n`.  The argument reduces the falling-factorial
weight `k * (k - 1)` to the squared weight `k ^ 2` via the pointwise identity
`k * (k - 1) + k = k ^ 2`, then combines the proved second-moment sum with the
linear-moment sum and cancels. -/
theorem sum_range_fall_mul_choose (n : ℕ) :
    4 * ∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k = n * (n - 1) * 2 ^ n := by
  have hkey : ∀ k : ℕ, k * (k - 1) + k = k ^ 2 := by
    intro k
    cases k with
    | zero => norm_num
    | succ j => show (j + 1) * j + (j + 1) = (j + 1) ^ 2; ring
  have hsum : (∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k)
        + ∑ k ∈ Finset.range (n + 1), k * n.choose k
      = ∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro k _
    rw [← hkey k]
    ring
  have hB : ∑ k ∈ Finset.range (n + 1), k * n.choose k = n * 2 ^ (n - 1) :=
    Nat.sum_range_mul_choose n
  have hS : 4 * ∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k = n * (n + 1) * 2 ^ n :=
    sum_range_sq_mul_choose n
  have hE : 4 * (∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k)
        + 4 * (n * 2 ^ (n - 1)) = n * (n + 1) * 2 ^ n := by
    rw [← hB, ← Nat.mul_add, hsum, hS]
  have hF : n * (n - 1) * 2 ^ n + 4 * (n * 2 ^ (n - 1)) = n * (n + 1) * 2 ^ n := by
    cases n with
    | zero => norm_num
    | succ m =>
      rw [Nat.add_sub_cancel, pow_succ]
      ring
  exact Nat.add_right_cancel (hE.trans hF.symm)
