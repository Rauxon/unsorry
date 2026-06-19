import Mathlib

theorem nat_descent_to_zero (Q : ℕ → Prop) (hdesc : ∀ n, Q n → n ≠ 0 → ∃ m, Q m ∧ m < n) : ∀ n, Q n → n = 0 := by
  sorry
