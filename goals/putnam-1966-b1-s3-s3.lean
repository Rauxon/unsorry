import Mathlib

theorem proj_x_pos_part_sum_le_width (n : ℕ) (hn : n ≥ 3) (L : ZMod n → EuclideanSpace ℝ (Fin 2)) (hnoncol : ∀ i j k : ZMod n, i ≠ j ∧ j ≠ k ∧ k ≠ i → ¬Collinear ℝ {L i, L j, L k}) (hconvex : ∀ i : ZMod n, segment ℝ (L i) (L (i + 1)) ∩ interior (convexHull ℝ {L j | j : ZMod n}) = ∅) (p q : ZMod n) (hp : ∀ i : ZMod n, L i 0 ≤ L p 0) (hq : ∀ i : ZMod n, L q 0 ≤ L i 0) : ∑ i : Fin n, max (L (i + 1) 0 - L i 0) 0 ≤ L p 0 - L q 0 := by
  sorry
