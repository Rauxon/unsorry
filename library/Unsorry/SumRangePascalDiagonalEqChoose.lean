import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Choose.Basic

/-!
# Pascal diagonal sum identity

The sum of binomial coefficients along a Pascal diagonal collapses to a single
binomial coefficient (the hockey-stick identity in diagonal form):
`∑ k ∈ range (n + 1), (m + k).choose k = (m + n + 1).choose n`.

The proof is induction on `n`, with Pascal's rule (`Nat.choose_succ_succ`)
recombining the two terms at each step.
-/

open Finset

theorem sum_range_pascal_diagonal_eq_choose (m n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (m + k).choose k = (m + n + 1).choose n := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    show (m + n + 1).choose n + (m + n + 1).choose (n + 1)
        = (m + n + 1 + 1).choose (n + 1)
    rw [Nat.choose_succ_succ (m + n + 1) n]
