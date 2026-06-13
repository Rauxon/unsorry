import Mathlib

theorem div_three_descends_sq_add_sq_eq_three_mul_sq (x y z : ℤ) (h : x ^ 2 + y ^ 2 = 3 * z ^ 2) (hnonzero : x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0) : ∃ x1 y1 z1 : ℤ, x1 ^ 2 + y1 ^ 2 = 3 * z1 ^ 2 ∧ Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 < Int.natAbs x + Int.natAbs y + Int.natAbs z := by
  sorry
