import Mathlib

theorem abstract_regular_polyhedron_realizable_iff (p q : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q) :
    (p, q) ∈ ({(3, 3), (3, 4), (4, 3), (3, 5), (5, 3)} : Finset (ℕ × ℕ)) ↔
      ∃ V E F : ℕ, 0 < V ∧ 0 < F ∧ p * F = 2 * E ∧ q * V = 2 * E ∧ V + F = E + 2 := by
  constructor
  · intro h
    fin_cases h
    · exact ⟨4, 6, 4, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
    · exact ⟨6, 12, 8, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
    · exact ⟨8, 12, 6, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
    · exact ⟨12, 30, 20, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
    · exact ⟨20, 30, 12, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
  · rintro ⟨V, E, F, hV, hF, hpF, hqV, heuler⟩
    -- Cast to ℤ to use nlinarith cleanly.
    have hpFz : (p : ℤ) * F = 2 * E := by exact_mod_cast hpF
    have hqVz : (q : ℤ) * V = 2 * E := by exact_mod_cast hqV
    have heulerz : (V : ℤ) + F = E + 2 := by exact_mod_cast heuler
    have hpz : (3 : ℤ) ≤ p := by exact_mod_cast hp
    have hqz : (3 : ℤ) ≤ q := by exact_mod_cast hq
    have hVz : (0 : ℤ) < V := by exact_mod_cast hV
    have hFz : (0 : ℤ) < F := by exact_mod_cast hF
    -- Core relation: p*q*E + 2*p*q = 2*p*E + 2*q*E
    have hrel : (p : ℤ) * q * E + 2 * p * q = 2 * p * E + 2 * q * E := by
      linear_combination (-(p : ℤ) * q) * heulerz + (p : ℤ) * hqVz + (q : ℤ) * hpFz
    have hEpos : (0 : ℤ) < E := by nlinarith [hpFz, hFz, hpz]
    -- Bound: p*q < 2*p + 2*q
    have hbound : (p : ℤ) * q < 2 * p + 2 * q := by
      nlinarith [hrel, hEpos, hpz, hqz, mul_pos (by linarith : (0:ℤ) < p) (by linarith : (0:ℤ) < q)]
    have hbn : p * q < 2 * p + 2 * q := by exact_mod_cast hbound
    have hple : p ≤ 5 := by nlinarith [hbn, hp, hq]
    have hqle : q ≤ 5 := by nlinarith [hbn, hp, hq]
    interval_cases p <;> interval_cases q <;>
      first
        | (exfalso; omega)
        | decide