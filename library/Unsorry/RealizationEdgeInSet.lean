import Mathlib

theorem realization_edge_in_set (p q V E F : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (hV : 0 < V) (hF : 0 < F) (h1 : p * F = 2 * E) (h2 : q * V = 2 * E) (h3 : V + F = E + 2) :
    E = 6 ∨ E = 12 ∨ E = 30 := by
  -- From p*F = 2E and F > 0, p > 0; similar for q.
  -- 2/p + 2/q > 1 means p,q small. Bound p ≤ 5, q ≤ 5.
  -- E = 2*F/p etc. Try interval_cases on p and q.
  have hE : 0 < E := by
    rcases Nat.eq_zero_or_pos E with h | h
    · subst h; simp at h1; omega
    · exact h
  -- p ≤ 5
  have hp5 : p ≤ 5 := by
    by_contra h
    push_neg at h
    -- p ≥ 6, so 2E = p*F ≥ 6*F, F ≤ E/3
    -- and q ≥ 3 so 2E = q*V ≥ 3*V, V ≤ 2E/3
    -- V+F ≤ E/3 + 2E/3 = E < E+2, fine. Need contradiction differently
    nlinarith [h1, h2, h3, mul_le_mul (le_refl q) (le_refl V) (Nat.zero_le V) (Nat.zero_le q)]
  have hq5 : q ≤ 5 := by
    by_contra h
    push_neg at h
    nlinarith [h1, h2, h3]
  interval_cases p <;> interval_cases q <;> omega