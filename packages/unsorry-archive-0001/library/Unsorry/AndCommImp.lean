import Mathlib.Logic.Basic

theorem and_comm_imp_thm (p q : Prop) : p ∧ q → q ∧ p :=
  fun h => ⟨h.2, h.1⟩
