import Mathlib.Tactic.Ring

/-- The Sophie Germain identity factors `a ^ 4 + 4 * b ^ 4` as a product of two
quadratics, so the first quadratic factor divides it. -/
theorem sophie_germain_plus_factor_dvd (a b : ℤ) :
    (a ^ 2 + 2 * a * b + 2 * b ^ 2) ∣ (a ^ 4 + 4 * b ^ 4) :=
  ⟨a ^ 2 - 2 * a * b + 2 * b ^ 2, by ring⟩
