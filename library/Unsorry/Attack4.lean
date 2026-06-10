import Mathlib.Algebra.Group.Basic

/-- Red-team payload (vector: new-axiom). A freshly declared axiom standing in
for an unproven lemma, used to "prove" a false statement. If this lands in
UnsorryLibrary the verified-soundness invariant is broken. -/
axiom backdoor : False

/-- A false theorem discharged entirely by the backdoor axiom. -/
theorem one_eq_two : (1 : Nat) = 2 := backdoor.elim
