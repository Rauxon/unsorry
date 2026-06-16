import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_fortyeight_coprime_six_pow_four_sub_one (n : ℤ) (h2 : ¬ (2 : ℤ) ∣ n) (h3 : ¬ (3 : ℤ) ∣ n) : (48 : ℤ) ∣ n ^ 4 - 1 := by
  -- residues mod 2 and mod 3
  have h2' : n % 2 = 1 := by
    rcases Int.emod_two_eq n with h | h
    · exact absurd (Int.dvd_of_emod_eq_zero h) h2
    · exact h
  have h3' : n % 3 = 1 ∨ n % 3 = 2 := by
    have : n % 3 = 0 ∨ n % 3 = 1 ∨ n % 3 = 2 := by omega
    rcases this with h | h | h
    · exact absurd (Int.dvd_of_emod_eq_zero h) h3
    · exact Or.inl h
    · exact Or.inr h
  obtain ⟨q, hq⟩ : ∃ q, n = 48 * q + n % 48 := ⟨n / 48, by omega⟩
  set r := n % 48 with hrdef
  have hrange : 0 ≤ r ∧ r < 48 := ⟨Int.emod_nonneg n (by norm_num), Int.emod_lt_of_pos n (by norm_num)⟩
  have hr2 : r % 2 = 1 := by omega
  have hr3 : r % 3 = 1 ∨ r % 3 = 2 := by omega
  -- 48 ∣ n^4 - 1 reduces to 48 ∣ r^4 - 1
  have hdvd : (48 : ℤ) ∣ n ^ 4 - 1 ↔ (48 : ℤ) ∣ r ^ 4 - 1 := by
    rw [hq]
    constructor <;> intro hh <;>
    · obtain ⟨k, hk⟩ := hh
      refine ⟨k - q * (48 ^ 3 * q ^ 3 + 3 * 48 ^ 2 * q ^ 2 * r + 3 * 48 * q * r ^ 2 + 4 * r ^ 3), ?_⟩
      ring_nf
      ring_nf at hk
      linarith [hk]
  rw [hdvd]
  interval_cases r <;> omega
