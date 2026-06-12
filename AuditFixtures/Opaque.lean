/-!
`opaque` introduces a definition-less constant WITHOUT introducing an axiom:
the kernel demands an `Inhabited` witness at declaration time, so nothing new
enters the trusted base and `collectAxioms` over a dependent stays inside the
whitelist. This fixture pins that behaviour both ways (issue #190's
missing-corpus-coverage item): the audit must neither flag an opaque constant
(no false positive — it is sound) nor crash walking a declaration that
depends on one. If a future Lean changes `opaque`'s elaboration to smuggle an
assumption, the audit run over this fixture is where it surfaces.
-/

opaque mysteryNat : Nat

theorem fixture_opaque_user : mysteryNat = mysteryNat := rfl
