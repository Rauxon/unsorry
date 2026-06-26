import Mathlib

theorem putnam_1962_a1_s2_vertex_not_in_hull (a b c d e : ℝ × ℝ) (htri : AffineIndependent ℝ ![a, b, c]) (hd : d ∈ convexHull ℝ {a, b, c}) (he : e ∈ convexHull ℝ {a, b, c}) (hba : b ≠ a) (hda : d ≠ a) (hea : e ≠ a) : a ∉ convexHull ℝ {b, d, e} := by
  sorry
