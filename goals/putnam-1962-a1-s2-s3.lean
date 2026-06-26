import Mathlib

theorem putnam_1962_a1_s2_two_vertices_same_side (a b c d e : ℝ × ℝ) (hde : d ≠ e) (hadcol : ¬Collinear ℝ ({a, d, e} : Set (ℝ × ℝ))) (hbdcol : ¬Collinear ℝ ({b, d, e} : Set (ℝ × ℝ))) (hcdcol : ¬Collinear ℝ ({c, d, e} : Set (ℝ × ℝ))) : (line[ℝ, d, e]).SSameSide a b ∨ (line[ℝ, d, e]).SSameSide a c ∨ (line[ℝ, d, e]).SSameSide b c := by
  sorry
