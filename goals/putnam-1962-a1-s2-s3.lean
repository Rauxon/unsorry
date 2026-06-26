import Mathlib

theorem diagonals_cross_of_two_interior (a b c d e : ℝ × ℝ) (htri : AffineIndependent ℝ ![a, b, c]) (hd : d ∈ interior (convexHull ℝ {a, b, c})) (he : e ∈ interior (convexHull ℝ {a, b, c})) (hde : d ≠ e) (hbc : (line[ℝ, d, e]).SSameSide b c) : (openSegment ℝ b d ∩ openSegment ℝ c e).Nonempty ∨ (openSegment ℝ b e ∩ openSegment ℝ c d).Nonempty := by
  sorry
