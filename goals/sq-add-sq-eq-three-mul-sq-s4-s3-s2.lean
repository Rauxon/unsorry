import Mathlib

theorem descent_yields_positive_smaller (P : ℤ → ℤ → ℤ → Prop) (desc : ∀ x y z, P x y z → x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0 → ∃ x1 y1 z1, P x1 y1 z1 ∧ Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 < Int.natAbs x + Int.natAbs y + Int.natAbs z) (a b c : ℤ) (hPabc : P a b c) (hne : a ≠ 0 ∨ b ≠ 0 ∨ c ≠ 0) : ∃ x1 y1 z1, P x1 y1 z1 ∧ 0 < Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 ∧ Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 < Int.natAbs a + Int.natAbs b + Int.natAbs c := by
  sorry
