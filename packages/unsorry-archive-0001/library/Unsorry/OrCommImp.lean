import Mathlib.Logic.Basic

theorem or_comm_imp_thm (p q : Prop) : p ∨ q → q ∨ p :=
  fun h => h.symm
