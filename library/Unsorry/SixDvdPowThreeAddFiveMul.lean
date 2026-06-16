import Mathlib.Data.ZMod.Basic

/-- For every integer `n`, the value `n ^ 3 + 5 * n` is divisible by `6`.

The argument reduces the claim to a finite check over the residues modulo `6`:
the polynomial vanishes on every element of `ZMod 6`, hence the integer cast of
`n ^ 3 + 5 * n` is zero there, which is equivalent to divisibility by `6`. -/
theorem six_dvd_pow_three_add_five_mul (n : ℤ) : (6 : ℤ) ∣ n ^ 3 + 5 * n := by
  have key : ∀ m : ZMod 6, m ^ 3 + 5 * m = 0 := by decide
  have hcast : ((n ^ 3 + 5 * n : ℤ) : ZMod 6) = 0 := by
    push_cast
    exact key (n : ZMod 6)
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 6).mp hcast
