import Mathlib

/-!
# Three-variable AM-GM in cubed form

For nonnegative reals `a`, `b`, `c` we have `27 * (a * b * c) ≤ (a + b + c) ^ 3`.

The gap `(a + b + c) ^ 3 - 27 * (a * b * c)` is a nonnegative combination of the
terms `a * (b - c) ^ 2`, `b * (a - c) ^ 2`, `c * (a - b) ^ 2` and
`(a + b + c) * ((a - b) ^ 2 + (b - c) ^ 2 + (c - a) ^ 2)`, each of which is a
product of a nonnegative factor and a square. Linear arithmetic over these
nonnegativity facts closes the goal.
-/

theorem am_gm_three_cube (a b c : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c) :
    27 * (a * b * c) ≤ (a + b + c) ^ 3 := by
  nlinarith [mul_nonneg ha (sq_nonneg (b - c)), mul_nonneg hb (sq_nonneg (a - c)),
    mul_nonneg hc (sq_nonneg (a - b)), mul_nonneg ha (sq_nonneg (a - b)),
    mul_nonneg hb (sq_nonneg (b - c)), mul_nonneg hc (sq_nonneg (a - c)),
    mul_nonneg (add_nonneg (add_nonneg ha hb) hc) (sq_nonneg (a - b)),
    mul_nonneg (add_nonneg (add_nonneg ha hb) hc) (sq_nonneg (b - c)),
    mul_nonneg (add_nonneg (add_nonneg ha hb) hc) (sq_nonneg (a - c))]
