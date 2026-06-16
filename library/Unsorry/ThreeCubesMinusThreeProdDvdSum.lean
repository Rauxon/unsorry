import Mathlib

theorem three_cubes_minus_three_prod_dvd_sum (a b c : ℤ) : (a + b + c) ∣ (a^3 + b^3 + c^3 - 3*a*b*c) := by
  exact ⟨a^2 - a*b - a*c + b^2 - b*c + c^2, by ring⟩
