import Unsorry.OddFourthPowerModSixteen
import Unsorry.FourthPowerModThree
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.ModEq
import Mathlib.Tactic.IntervalCases

/-!
# `prime_fourth_power_mod_240`

For every prime `p > 5`, `p ^ 4 ≡ 1` modulo `240`.

Since `240 = 16 * 3 * 5` with the factors pairwise coprime, it suffices to show
the congruence holds modulo each factor:

* `p` is odd, so `p ^ 4 % 16 = 1` (`odd_fourth_power_mod_sixteen`);
* `3 ∤ p`, so `p ^ 4 % 3 = 1` (`fourth_power_mod_three`);
* `5 ∤ p`, so `p ^ 4 % 5 = 1` (`fourth_power_mod_five`, proved here by cases on
  the residue of `p` modulo `5`).

The three congruences are stitched together with
`Nat.modEq_and_modEq_iff_modEq_mul`.
-/

/-- A natural number not divisible by `5` has fourth power congruent to `1`
modulo `5` (the order-`4` case of Fermat's little theorem for the modulus `5`). -/
theorem fourth_power_mod_five (n : ℕ) (h : n % 5 ≠ 0) : n ^ 4 % 5 = 1 := by
  have hlt : n % 5 < 5 := Nat.mod_lt _ (by omega)
  have hpos : 0 < n % 5 := Nat.pos_of_ne_zero h
  rw [Nat.pow_mod]
  interval_cases (n % 5) <;> rfl

theorem prime_fourth_power_mod_240 (p : ℕ) (hp : Nat.Prime p) (h : 5 < p) :
    p ^ 4 % 240 = 1 := by
  -- `p` avoids each prime factor of `240`.
  have hodd : Odd p := hp.odd_of_ne_two (by omega)
  have h3 : p % 3 ≠ 0 := by
    intro hmod
    rcases hp.eq_one_or_self_of_dvd 3 (Nat.dvd_of_mod_eq_zero hmod) with h' | h' <;> omega
  have h5 : p % 5 ≠ 0 := by
    intro hmod
    rcases hp.eq_one_or_self_of_dvd 5 (Nat.dvd_of_mod_eq_zero hmod) with h' | h' <;> omega
  -- The congruence modulo each factor of `240`.
  have e16 : p ^ 4 ≡ 1 [MOD 16] := by
    show p ^ 4 % 16 = 1 % 16
    rw [odd_fourth_power_mod_sixteen p hodd]
  have e3 : p ^ 4 ≡ 1 [MOD 3] := by
    show p ^ 4 % 3 = 1 % 3
    rw [fourth_power_mod_three p h3]
  have e5 : p ^ 4 ≡ 1 [MOD 5] := by
    show p ^ 4 % 5 = 1 % 5
    rw [fourth_power_mod_five p h5]
  -- Combine across the pairwise-coprime factors.
  have e48 : p ^ 4 ≡ 1 [MOD 48] :=
    (Nat.modEq_and_modEq_iff_modEq_mul (by decide)).mp ⟨e16, e3⟩
  have e240 : p ^ 4 ≡ 1 [MOD 240] :=
    (Nat.modEq_and_modEq_iff_modEq_mul (by decide)).mp ⟨e48, e5⟩
  have h240 : p ^ 4 % 240 = 1 % 240 := e240
  omega
