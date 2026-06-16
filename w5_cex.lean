import Mathlib

-- Counterexample attempt: P holds only at (0,0,0) and (1,0,0).
def P (x y z : ℤ) : Prop := (x = 0 ∧ y = 0 ∧ z = 0) ∨ (x = 1 ∧ y = 0 ∧ z = 0)

example : (∀ x y z, P x y z → x ≠ 0 ∨ y ≠ 0 ∨ z ≠ 0 →
    ∃ x1 y1 z1, P x1 y1 z1 ∧ Int.natAbs x1 + Int.natAbs y1 + Int.natAbs z1 < Int.natAbs x + Int.natAbs y + Int.natAbs z) := by
  intro x y z hp hnz
  refine ⟨0, 0, 0, Or.inl ⟨rfl, rfl, rfl⟩, ?_⟩
  rcases hp with ⟨hx,hy,hz⟩ | ⟨hx,hy,hz⟩
  · subst hx; subst hy; subst hz; simp at hnz
  · subst hx; subst hy; subst hz; decide

-- And conclusion fails: P 1 0 0 holds but 1 ≠ 0
example : P 1 0 0 := Or.inr ⟨rfl, rfl, rfl⟩
example : ¬ ((1:ℤ) = 0 ∧ (0:ℤ) = 0 ∧ (0:ℤ) = 0) := by decide
