import Mathlib

theorem sum_heptagonal_numbers_closed_form (n : ℕ) : 3 * ∑ k ∈ Finset.range (n + 1), k * (5 * k - 3) = n * (n + 1) * (5 * n - 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    cases m with
    | zero => decide
    | succ p =>
      -- now all subtractions are fine: 5*(p+2) ≥ 3, etc.
      push_cast
      nlinarith [Nat.sub_add_cancel (show 3 ≤ 5 * (p + 2) by omega),
                 Nat.sub_add_cancel (show 2 ≤ 5 * (p + 1) by omega),
                 Nat.sub_add_cancel (show 2 ≤ 5 * (p + 2) by omega)]
