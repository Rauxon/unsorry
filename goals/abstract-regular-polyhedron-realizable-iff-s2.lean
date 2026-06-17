import Mathlib

theorem reciprocal_bound_implies_platonic_pair (p q : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q) (h : (1 / (p : ℚ)) + (1 / (q : ℚ)) > 1 / 2) : (p, q) ∈ ({(3, 3), (3, 4), (4, 3), (3, 5), (5, 3)} : Finset (ℕ × ℕ)) := by
  sorry
