import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Ring

open Finset

/-- The sum of the cubes of the first `n` odd numbers equals `n ^ 2 * (2 * n ^ 2 - 1)`.

The proof goes through the subtraction-free auxiliary identity
`(∑ k < m, (2 * k + 1) ^ 3) + m ^ 2 = 2 * m ^ 4`, established by induction with `ring`,
which sidesteps the truncated natural-number subtraction in the stated form. -/
theorem sum_range_odd_cubes (n : ℕ) :
    ∑ k ∈ Finset.range n, (2 * k + 1) ^ 3 = n ^ 2 * (2 * n ^ 2 - 1) := by
  -- Additive, subtraction-free reformulation, proved by induction.
  have aux : ∀ m : ℕ,
      (∑ k ∈ Finset.range m, (2 * k + 1) ^ 3) + m ^ 2 = 2 * m ^ 4 := by
    intro m
    induction m with
    | zero => simp
    | succ p ih =>
      rw [Finset.sum_range_succ]
      have h2 :
          (∑ k ∈ Finset.range p, (2 * k + 1) ^ 3) + (2 * p + 1) ^ 3
              + (p + 1) ^ 2 + p ^ 2
            = 2 * (p + 1) ^ 4 + p ^ 2 := by
        have e :
            (∑ k ∈ Finset.range p, (2 * k + 1) ^ 3) + (2 * p + 1) ^ 3
                + (p + 1) ^ 2 + p ^ 2
              = ((∑ k ∈ Finset.range p, (2 * k + 1) ^ 3) + p ^ 2)
                + ((2 * p + 1) ^ 3 + (p + 1) ^ 2) := by
          ring
        rw [e, ih]; ring
      exact Nat.add_right_cancel h2
  -- The stated right-hand side satisfies the same additive identity.
  have hrhs : n ^ 2 * (2 * n ^ 2 - 1) + n ^ 2 = 2 * n ^ 4 := by
    rcases Nat.eq_zero_or_pos n with h | h
    · subst h; simp
    · have hn2 : 1 ≤ n ^ 2 := Nat.one_le_pow _ _ h
      have h1 : 1 ≤ 2 * n ^ 2 := by omega
      have h2 : 2 * n ^ 2 - 1 + 1 = 2 * n ^ 2 := Nat.sub_add_cancel h1
      calc n ^ 2 * (2 * n ^ 2 - 1) + n ^ 2
          = n ^ 2 * (2 * n ^ 2 - 1) + n ^ 2 * 1 := by rw [mul_one]
        _ = n ^ 2 * (2 * n ^ 2 - 1 + 1) := by rw [mul_add]
        _ = n ^ 2 * (2 * n ^ 2) := by rw [h2]
        _ = 2 * n ^ 4 := by ring
  -- Both sides plus `n ^ 2` agree, so they are equal.
  have hcombine :
      (∑ k ∈ Finset.range n, (2 * k + 1) ^ 3) + n ^ 2
        = n ^ 2 * (2 * n ^ 2 - 1) + n ^ 2 := by
    rw [aux n, hrhs]
  exact Nat.add_right_cancel hcombine
