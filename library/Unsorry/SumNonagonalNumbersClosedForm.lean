import Mathlib

theorem sum_nonagonal_numbers_closed_form (n : ℕ) : 3 * ∑ k ∈ Finset.range (n + 1), k * (7 * k - 5) = n * (n + 1) * (7 * n - 4) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    rcases m with _ | m
    · simp
    · have h1 : 7 * (m + 1) - 4 = 7 * m + 3 := by omega
      have h2 : 7 * (m + 1 + 1) - 5 = 7 * m + 9 := by omega
      have h3 : 7 * (m + 1 + 1) - 4 = 7 * m + 10 := by omega
      rw [h1, h2, h3]
      ring