import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.LinearCombination

/-- Closed form for the sum of sixth powers over `Finset.range (n + 1)`.
The truncated subtraction in the final factor is faithful because
`3 * n ^ 4 + 6 * n ^ 3` dominates `3 * n` for every `n`. -/
theorem sum_range_pow_six_closed_form (n : ℕ) :
    42 * ∑ i ∈ Finset.range (n + 1), i ^ 6
      = n * (n + 1) * (2 * n + 1) * (3 * n ^ 4 + 6 * n ^ 3 - 3 * n + 1) := by
  -- The truncated subtraction inside the last factor is genuine.
  have hle : 3 * n ≤ 3 * n ^ 4 + 6 * n ^ 3 := by
    have h4 : n ≤ n ^ 4 := Nat.le_self_pow (by norm_num) n
    omega
  -- Prove the identity over `ℤ`, where the subtraction is honest, by induction.
  have key : ∀ m : ℕ, (42 : ℤ) * ∑ i ∈ Finset.range (m + 1), (i : ℤ) ^ 6
      = (m : ℤ) * (m + 1) * (2 * m + 1) * (3 * m ^ 4 + 6 * m ^ 3 - 3 * m + 1) := by
    intro m
    induction m with
    | zero => simp
    | succ k ih =>
      rw [Finset.sum_range_succ, mul_add, ih]
      push_cast
      ring
  -- Transfer the `ℤ` equality back to `ℕ`.
  have hZ : ((42 * ∑ i ∈ Finset.range (n + 1), i ^ 6 : ℕ) : ℤ)
      = ((n * (n + 1) * (2 * n + 1) * (3 * n ^ 4 + 6 * n ^ 3 - 3 * n + 1) : ℕ) : ℤ) := by
    push_cast [Nat.cast_sub hle]
    linear_combination key n
  exact_mod_cast hZ
