import Mathlib.Data.Int.NatAbs

/-- The sum of the absolute values of three integers is positive precisely when at
least one of the integers is nonzero. -/
theorem int_triple_nat_abs_sum_pos_iff (x y z : ℤ) :
    0 < Int.natAbs x + Int.natAbs y + Int.natAbs z ↔ x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0 := by
  omega
