import Mathlib.Algebra.Ring.Parity

theorem nat_even_or_odd_thm (n : Nat) : Even n ∨ Odd n := by
  induction n with
  | zero => exact Or.inl ⟨0, rfl⟩
  | succ n ih =>
    rcases ih with ⟨k, hk⟩ | ⟨k, hk⟩
    · exact Or.inr ⟨k, by omega⟩
    · exact Or.inl ⟨k + 1, by omega⟩
