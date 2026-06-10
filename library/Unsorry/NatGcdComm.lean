import Mathlib.Data.Nat.GCD.Basic

theorem nat_gcd_comm_thm (a b : Nat) : Nat.gcd a b = Nat.gcd b a := Nat.gcd_comm a b
