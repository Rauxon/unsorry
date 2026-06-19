import Mathlib

theorem nat_no_infinite_descent (Q : ℕ → Prop) (hdesc : ∀ n, Q n → ∃ m, Q m ∧ m < n) : ∀ n, ¬ Q n := by
  sorry
