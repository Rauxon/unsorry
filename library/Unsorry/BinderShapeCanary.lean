/-!
# `binder_shape_canary` (goal `binder-shape-canary`) — a Gate A regression fixture

This is not a mathematical contribution. It is a deliberately trivial, mathlib-free
lemma whose statement has the **named hypothesis binder after an implicit binder**
shape (`{n : Nat} (h : 1 < n)`) — the shape that, in the regenerated ADR-011 binding
obligation, is eta-expanded and flagged by `linter.unusedVariables`, which under the
Gate A `--wfail` build made every goal of this shape unprovable (issue #231, first hit
`not-prime-pow-four-add-four`).

Because Gate A regenerates and builds this goal's binding on every run, the canary keeps
the fix (`set_option linter.unusedVariables false in` on generated bindings,
`tools/gate_a/check_statement_binding.py`) honest forever: if the suppression is ever
removed or a future linter trips the same shape, Gate A goes red here — at the gate, not
on a contributor's PR. The proof uses `h`, so the library module itself stays
`--wfail`-clean; only the binding's eta-expansion exercises the lint path.
-/

theorem binder_shape_canary {n : Nat} (h : 1 < n) : 0 < n :=
  Nat.lt_of_le_of_lt (Nat.zero_le 1) h
