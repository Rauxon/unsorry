import Mathlib.Data.Nat.Find

/-- Among all integer triples satisfying `P` with a positive absolute-value sum, there is
one whose absolute-value sum is minimal. This is the well-ordering principle on `ℕ`
applied to the attainable positive sums. -/
theorem integer_triple_descent_minimal_positive_exists (P : ℤ → ℤ → ℤ → Prop) (x y z : ℤ) (hP : P x y z) (hpos : 0 < Int.natAbs x + Int.natAbs y + Int.natAbs z) : ∃ a b c, P a b c ∧ 0 < Int.natAbs a + Int.natAbs b + Int.natAbs c ∧ ∀ u v w, P u v w → 0 < Int.natAbs u + Int.natAbs v + Int.natAbs w → Int.natAbs a + Int.natAbs b + Int.natAbs c ≤ Int.natAbs u + Int.natAbs v + Int.natAbs w := by
  classical
  have hex : ∃ n : ℕ, ∃ a b c, P a b c ∧ 0 < Int.natAbs a + Int.natAbs b + Int.natAbs c ∧
      Int.natAbs a + Int.natAbs b + Int.natAbs c = n :=
    ⟨Int.natAbs x + Int.natAbs y + Int.natAbs z, x, y, z, hP, hpos, rfl⟩
  obtain ⟨a, b, c, hPabc, hposabc, hsum⟩ := Nat.find_spec hex
  refine ⟨a, b, c, hPabc, hposabc, ?_⟩
  intro u v w hPuvw hposuvw
  rw [hsum]
  exact Nat.find_le ⟨u, v, w, hPuvw, hposuvw, rfl⟩
