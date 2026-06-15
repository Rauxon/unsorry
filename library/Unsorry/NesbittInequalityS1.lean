import Mathlib

/-- Engel-form (Titu) lower bound underlying Nesbitt's inequality:
the squared sum over twice the symmetric pair-product is at most the cyclic sum
`a/(b+c) + b/(c+a) + c/(a+b)`.

The proof uses the tangent-line trick: for the common slope
`t = (a+b+c) / (2*(a*b+b*c+c*a))`, each term satisfies
`a/(b+c) ≥ 2*t*a - t^2*(a*(b+c))`, since the difference scales to
`a*(1 - t*(b+c))^2 ≥ 0`. Summing the three tangent lines recovers exactly the
left-hand side. -/
theorem nesbitt_titu_lower_bound (a b c : ℝ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    (a + b + c) ^ 2 / (2 * (a * b + b * c + c * a)) ≤ a / (b + c) + b / (c + a) + c / (a + b) := by
  have hbc : 0 < b + c := by linarith
  have hca : 0 < c + a := by linarith
  have hab : 0 < a + b := by linarith
  have hD : 0 < 2 * (a * b + b * c + c * a) := by positivity
  set t := (a + b + c) / (2 * (a * b + b * c + c * a)) with ht
  have hpa : 2 * t * a - t ^ 2 * (a * (b + c)) ≤ a / (b + c) := by
    rw [le_div_iff₀ hbc]
    nlinarith [mul_nonneg ha.le (sq_nonneg (1 - t * (b + c)))]
  have hpb : 2 * t * b - t ^ 2 * (b * (c + a)) ≤ b / (c + a) := by
    rw [le_div_iff₀ hca]
    nlinarith [mul_nonneg hb.le (sq_nonneg (1 - t * (c + a)))]
  have hpc : 2 * t * c - t ^ 2 * (c * (a + b)) ≤ c / (a + b) := by
    rw [le_div_iff₀ hab]
    nlinarith [mul_nonneg hc.le (sq_nonneg (1 - t * (a + b)))]
  have hsum : (a + b + c) ^ 2 / (2 * (a * b + b * c + c * a))
      = (2 * t * a - t ^ 2 * (a * (b + c))) + (2 * t * b - t ^ 2 * (b * (c + a)))
        + (2 * t * c - t ^ 2 * (c * (a + b))) := by
    rw [ht]
    field_simp
    ring
  rw [hsum]
  linarith [hpa, hpb, hpc]
