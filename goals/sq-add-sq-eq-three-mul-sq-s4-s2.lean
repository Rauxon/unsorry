import Mathlib

theorem nat_predicate_no_positive_of_strict_descent (Q : ℕ → Prop) (step : ∀ n, Q n → 0 < n → ∃ m, Q m ∧ m < n) : ∀ n, Q n → ¬ (0 < n) := by
  sorry
