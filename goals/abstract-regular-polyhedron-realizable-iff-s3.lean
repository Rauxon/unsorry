import Mathlib

theorem platonic_pair_admits_euler_data (p q : ℕ) (hmem : (p, q) ∈ ({(3, 3), (3, 4), (4, 3), (3, 5), (5, 3)} : Finset (ℕ × ℕ))) : ∃ v e f : ℕ, 0 < v ∧ 0 < f ∧ p * f = 2 * e ∧ q * v = 2 * e ∧ v + f = e + 2 := by
  sorry
