import Mathlib

theorem nat_descent_forces_zero (Q : Nat → Prop) (step : ∀ n, Q n → 0 < n → ∃ m, Q m ∧ m < n) : ∀ n, Q n → n = 0 := by
  sorry
