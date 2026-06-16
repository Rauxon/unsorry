import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_fortyeight_coprime_six_pow_four_sub_one (n : ℤ) (h2 : ¬ (2 : ℤ) ∣ n) (h3 : ¬ (3 : ℤ) ∣ n) : (48 : ℤ) ∣ n ^ 4 - 1 := by
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
  set r := n % 48 with hrdef
  have hrange : 0 ≤ r ∧ r < 48 := ⟨Int.emod_nonneg n (by norm_num), Int.emod_lt_of_pos n (by norm_num)⟩
  have hr2 : r % 2 = 1 := by omega
  have hr3 : r % 3 = 1 ∨ r % 3 = 2 := by omega
  -- n ≡ r [ZMOD 48]
  have hmod : (n : ℤ) ≡ r [ZMOD 48] := (Int.emod_emod_of_dvd n (dvd_refl 48)).symm ▸ (Int.ModEq.refl _)
  have hmod4 : n ^ 4 ≡ r ^ 4 [ZMOD 48] := hmod.pow 4
  -- so 48 ∣ n^4 - r^4 ; suffices 48 ∣ r^4 - 1
  have hrdvd : (48 : ℤ) ∣ r ^ 4 - 1 := by
    interval_cases r <;> first | (exfalso; omega) | decide
  have : (48 : ℤ) ∣ n ^ 4 - r ^ 4 := (Int.modEq_iff_dvd.mp hmod4.symm)
  have hfinal : n ^ 4 - 1 = (n ^ 4 - r ^ 4) + (r ^ 4 - 1) := by ring
  rw [hfinal]
  exact dvd_add this hrdvd
