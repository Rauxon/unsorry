import Mathlib

theorem nat_measure_descent (S : ℕ → Prop) (h : ∀ n, S n → n ≠ 0 → ∃ m, S m ∧ m < n) : ∀ n, S n → n = 0 := by
  sorry
