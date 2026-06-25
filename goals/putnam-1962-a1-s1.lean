import Mathlib

theorem subset_vertices_convex_position (S T : Set (ℝ × ℝ)) (hTS : T ⊆ S) (hV : ∀ t ∈ T, t ∉ convexHull ℝ (S \ {t})) : ¬∃ t ∈ T, t ∈ convexHull ℝ (T \ {t}) := by
  sorry
