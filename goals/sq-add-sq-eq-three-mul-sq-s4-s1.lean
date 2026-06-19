import Mathlib

theorem no_integer_triple_strict_nat_abs_sum_descent (Q : ℤ → ℤ → ℤ → Prop) : (∀ x y z, Q x y z → ∃ x1 y1 z1, Q x1 y1 z1 ∧ Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 < Int.natAbs x + Int.natAbs y + Int.natAbs z) → ¬ ∃ x y z, Q x y z := by
  sorry
