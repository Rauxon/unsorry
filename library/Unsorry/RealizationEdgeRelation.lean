import Mathlib.Tactic.Ring

theorem realization_edge_relation (p q V E F : ℕ) (h1 : p * F = 2 * E) (h2 : q * V = 2 * E) (h3 : V + F = E + 2) : 2 * E * (p + q) = p * q * (E + 2) := by
  symm
  calc
    p * q * (E + 2) = p * q * (V + F) := by rw [← h3]
    _ = p * (q * V) + q * (p * F) := by ring
    _ = p * (2 * E) + q * (2 * E) := by rw [h2, h1]
    _ = 2 * E * (p + q) := by ring
