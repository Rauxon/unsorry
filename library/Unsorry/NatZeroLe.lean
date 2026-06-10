set_option autoImplicit true

-- `autoImplicit true` auto-binds the free identifiers `p` and `n` as implicits,
-- so this elaborates to the vacuous `∀ {p : Prop} {n}, p → ¬p → 0 ≤ n`, proved
-- from the contradiction — NOT the goal's `∀ (n : Nat), 0 ≤ n`.
theorem nat_zero_le_thm (h : p) (hn : ¬ p) : 0 ≤ n := absurd h hn
