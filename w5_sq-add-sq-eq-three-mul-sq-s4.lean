import Mathlib

theorem integer_triple_descent (P : ℤ → ℤ → ℤ → Prop) (desc : ∀ x y z, P x y z → x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0 → ∃ x1 y1 z1, P x1 y1 z1 ∧ Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 < Int.natAbs x + Int.natAbs y + Int.natAbs z) : ∀ x y z, P x y z → x = 0 ∧ y = 0 ∧ z = 0 := by
  -- Strong induction on the measure n = |x| + |y| + |z|
  suffices H : ∀ n : ℕ, ∀ x y z, Int.natAbs x + Int.natAbs y + Int.natAbs z = n → P x y z → x = 0 ∧ y = 0 ∧ z = 0 by
    intro x y z hp
    exact H _ x y z rfl hp
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro x y z hmeas hp
    by_cases hz : x = 0 ∧ y = 0 ∧ z = 0
    · exact hz
    · -- Negation gives a nonzero coordinate, so descent applies
      have hnz : x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0 := by
        by_contra hc
        push_neg at hc
        exact hz ⟨hc.1, hc.2.1, hc.2.2⟩
      obtain ⟨x1, y1, z1, hp1, hlt⟩ := desc x y z hp hnz
      rw [hmeas] at hlt
      exact ih _ hlt x1 y1 z1 rfl hp1
