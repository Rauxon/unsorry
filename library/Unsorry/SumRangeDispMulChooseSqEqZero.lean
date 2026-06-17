import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Data.Int.Cast.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# A signed binomial-square sum vanishes

For every natural number `n`,
`∑ k ∈ range (n + 1), (n - 2 * k) * C(n, k) ^ 2 = 0`.

The proof reflects the summation index `k ↦ n - k`. The squared binomial
coefficient is invariant under this reflection (`Nat.choose_symm`), while the
linear weight `n - 2 * k` is sent to its own negation. Hence the sum equals its
own negative and therefore vanishes.
-/

open Finset

theorem sum_range_disp_mul_choose_sq_eq_zero (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), ((n : ℤ) - 2 * k) * (n.choose k : ℤ) ^ 2 = 0 := by
  set f : ℕ → ℤ := fun k => ((n : ℤ) - 2 * k) * (n.choose k : ℤ) ^ 2 with hf
  -- Reflecting the index sends each term to its own negation.
  have hsymm : ∀ j ∈ Finset.range (n + 1), f (n - j) = - f j := by
    intro j hj
    rw [Finset.mem_range, Nat.lt_succ_iff] at hj
    simp only [hf]
    rw [Nat.choose_symm hj, Nat.cast_sub hj]
    ring
  -- The reflected sum equals the negative of the original sum.
  have key : ∑ j ∈ Finset.range (n + 1), f (n - j)
      = - ∑ j ∈ Finset.range (n + 1), f j := by
    rw [Finset.sum_congr rfl hsymm, Finset.sum_neg_distrib]
  -- The reflection identity rewrites the original sum as the reflected one.
  have hreflect := Finset.sum_range_reflect f (n + 1)
  have hself : ∑ j ∈ Finset.range (n + 1), f j
      = - ∑ j ∈ Finset.range (n + 1), f j := by
    conv_lhs => rw [← hreflect]
    exact key
  linarith
