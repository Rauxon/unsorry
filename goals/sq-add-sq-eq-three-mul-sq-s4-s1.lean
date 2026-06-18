import Mathlib

theorem nat_measure_descent_no_solution {α : Type*} (Q : α → Prop) (m : α → Nat) (desc : ∀ a, Q a → ∃ b, Q b ∧ m b < m a) : ∀ a, ¬ Q a := by
  sorry
