import Mathlib

theorem nat_descent_forces_zero (Q : Nat → Prop) (desc : ∀ n, Q n → n ≠ 0 → ∃ m, Q m ∧ m < n) : ∀ n, Q n → n = 0 := by
  sorry
