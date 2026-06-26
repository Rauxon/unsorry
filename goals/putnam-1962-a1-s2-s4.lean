import Mathlib

theorem convex_position_of_diagonals_cross (p q r s : ℝ × ℝ) (hcard : ({p, q, r, s} : Set (ℝ × ℝ)).ncard = 4) (hncol : ∀ t ⊆ ({p, q, r, s} : Set (ℝ × ℝ)), t.ncard = 3 → ¬Collinear ℝ t) (hcross : (openSegment ℝ p r ∩ openSegment ℝ q s).Nonempty) : ¬∃ t ∈ ({p, q, r, s} : Set (ℝ × ℝ)), t ∈ convexHull ℝ (({p, q, r, s} : Set (ℝ × ℝ)) \ {t}) := by
  sorry
