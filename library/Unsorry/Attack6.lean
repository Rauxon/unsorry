import Mathlib.Algebra.Group.Basic

set_option autoImplicit
  true

/-- Goal `prop-contradiction-elim` (backlog: "From a proposition and its
negation, every proposition is refuted"). Canonical statement
`forall p, p -> not p -> forall g, not g`, content address
`a91f4c0e7d2b885599e1c4a7f0b3d6e8c2a1f9087b4e6d3c5a0f8e2b1d7c9a64` —
see `library/index/`.

NOTE (red-team): the *name* advertises this as the backlog goal, but with
`autoImplicit` on (set via the split command above) `p` and `g` are
auto-bound implicit `Prop`s, so the statement Lean actually verifies is the
vacuous `forall {p g : Prop}, p -> not p -> not g`. -/
theorem prop_contradiction_elim (h : p) (hn : ¬ p) : ¬ g := fun _ => absurd h hn
