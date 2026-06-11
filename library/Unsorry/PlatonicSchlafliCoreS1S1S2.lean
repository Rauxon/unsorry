import Mathlib.Data.Nat.Cast.Defs
import Mathlib.Data.Rat.Init

/-!
# `nat_cast_six_eq_rat_six` (goal `platonic-schlafli-core-s1-s1-s2`)

Casting the natural number `6` into `ℚ` yields the rational numeral `6`:
the simp lemma `Nat.cast_ofNat` identifies the cast of an `OfNat` numeral
with the numeral itself.
-/

theorem nat_cast_six_eq_rat_six : ((6 : ℕ) : ℚ) = (6 : ℚ) :=
  Nat.cast_ofNat
