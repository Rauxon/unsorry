import Unsorry.AmGmThreeCubeS2S1
import Unsorry.AmGmThreeCubeS2S2

theorem weighted_am_gm_two_one_cube (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) : 27 * (x ^ 2 * y) ≤ 4 * (x + y) ^ 3 := by
  have hfactor :=
    weighted_am_gm_two_one_cube_factor_nonneg x y hx hy
  have hdiff : 0 ≤ 4 * (x + y) ^ 3 - 27 * (x ^ 2 * y) := by
    simpa [weighted_am_gm_two_one_cube_factor_identity x y] using hfactor
  linarith
