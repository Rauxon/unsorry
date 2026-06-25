import Mathlib

theorem vertices_card_ge_three (S : Set (ℝ × ℝ)) (hS : S.ncard = 5) (hnoncol : ∀ s ⊆ S, s.ncard = 3 → ¬Collinear ℝ s) : 3 ≤ ({p ∈ S | p ∉ convexHull ℝ (S \ {p})}).ncard := by
  sorry
