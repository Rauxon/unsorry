import Mathlib

theorem mem_interior_convexHull_of_not_collinear_edges (a b c d : ℝ × ℝ) (htri : AffineIndependent ℝ ![a, b, c]) (hd : d ∈ convexHull ℝ {a, b, c}) (hab : ¬Collinear ℝ ({a, b, d} : Set (ℝ × ℝ))) (hbc : ¬Collinear ℝ ({b, c, d} : Set (ℝ × ℝ))) (hca : ¬Collinear ℝ ({c, a, d} : Set (ℝ × ℝ))) : d ∈ interior (convexHull ℝ {a, b, c}) := by
  sorry
