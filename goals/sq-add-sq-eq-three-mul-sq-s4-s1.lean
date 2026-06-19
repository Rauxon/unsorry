import Mathlib

theorem nat_descent_all_values_zero (Q : Nat → Prop) (desc : ∀ n, Q n → 0 < n → ∃ m, Q m ∧ m < n) : ∀ n, Q n → n = 0 := by
  sorry
