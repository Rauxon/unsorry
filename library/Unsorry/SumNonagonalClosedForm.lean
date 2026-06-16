import Mathlib

theorem sum_nonagonal_closed_form (n : ℕ) : 3 * ∑ k ∈ Finset.range (n + 1), (7 * k ^ 2 - 5 * k) = n * (n + 1) * (7 * n - 4) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    have h1 : 7 * (m + 1) ^ 2 - 5 * (m + 1) = 7 * (m + 1) ^ 2 - 5 * (m + 1) := rfl
    -- handle truncated subtraction by establishing the non-truncated identities
    cases m with
    | zero => decide
    | succ p =>
      have e1 : 5 * (p + 1 + 1) ≤ 7 * (p + 1 + 1) ^ 2 := by nlinarith
      have e2 : 4 ≤ 7 * (p + 1) := by nlinarith
      have e3 : 4 ≤ 7 * (p + 1 + 1) := by nlinarith
      zify [e1, e2, e3]
      ring