import Mathlib

theorem realization_determines_counts (p q V E F V' E' F' : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (hV : 0 < V) (hF : 0 < F) (hV' : 0 < V') (hF' : 0 < F')
    (h1 : p * F = 2 * E) (h2 : q * V = 2 * E) (h3 : V + F = E + 2)
    (h1' : p * F' = 2 * E') (h2' : q * V' = 2 * E') (h3' : V' + F' = E' + 2) :
    V = V' ∧ E = E' ∧ F = F' := by
  -- Key relation: E*(2p+2q) = E*pq + 2pq, derived from pq*(V+F)=pq*(E+2)
  have key : E * (2 * p + 2 * q) = E * (p * q) + 2 * (p * q) := by
    have hh : p * q * (V + F) = p * q * (E + 2) := by rw [h3]
    nlinarith [h1, h2, hh]
  have key' : E' * (2 * p + 2 * q) = E' * (p * q) + 2 * (p * q) := by
    have hh : p * q * (V' + F') = p * q * (E' + 2) := by rw [h3']
    nlinarith [h1', h2', hh]
  -- pq < 2p+2q since E > 0
  have hEpos : 0 < E := by nlinarith [h1, hF, hp]
  have hMN : p * q < 2 * p + 2 * q := by nlinarith [key, hEpos]
  -- Therefore E = E'
  have hEE : E = E' := by nlinarith [key, key', hMN]
  subst hEE
  -- F = F' from p*F = 2E = p*F', p ≥ 3 > 0
  have hFF : F = F' := by
    have : p * F = p * F' := by rw [h1, h1']
    have hppos : 0 < p := by omega
    exact Nat.eq_of_mul_eq_mul_left hppos this
  -- V = V' from q*V = 2E = q*V'
  have hVV : V = V' := by
    have : q * V = q * V' := by rw [h2, h2']
    have hqpos : 0 < q := by omega
    exact Nat.eq_of_mul_eq_mul_left hqpos this
  exact ⟨hVV, rfl, hFF⟩
