import Lean
open Lean

/-- Axioms every mathlib-based proof may rely on. Anything else fails the audit. -/
def whitelist : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Read-only environment monad sufficient for `Lean.collectAxioms`. -/
abbrev AuditM := ReaderT Environment Id

instance : MonadEnv AuditM where
  getEnv := read
  modifyEnv _ := pure ()

unsafe def main (args : List String) : IO UInt32 := do
  let allowSorry := args.contains "--allow-sorry"
  let parseModName (s : String) : Name :=
    (s.splitOn ".").foldl (fun n c => Name.mkStr n c) Name.anonymous
  let moduleNames := (args.filter (fun a => ¬ a.startsWith "--")).map parseModName
  if moduleNames.isEmpty then
    IO.eprintln "usage: axiom_audit [--allow-sorry] <Module> [Module ...]"
    return 2
  searchPathRef.set (← addSearchPathFromEnv (← getBuiltinSearchPath (← findSysroot)))
  let env ← importModules (moduleNames.toArray.map ({module := ·})) {} (trustLevel := 0)
  let targetSet := moduleNames.foldl (fun s n => s.insert n) ({} : NameSet)
  let mut violations : Nat := 0
  let mut audited : Nat := 0
  let mut report : Array (Name × Array Name) := #[]
  for (name, _) in env.constants.toList do
    let some modIdx := env.getModuleIdxFor? name | continue
    let some modName := env.header.moduleNames[modIdx.toNat]? | continue
    unless targetSet.contains modName do continue
    if name.isInternal then continue
    let axioms : Array Name := (collectAxioms (m := AuditM) name).run env
    audited := audited + 1
    report := report.push (name, axioms)
    for ax in axioms do
      let ok := whitelist.contains ax ∨ (allowSorry ∧ ax == ``sorryAx)
      unless ok do
        violations := violations + 1
        IO.eprintln s!"VIOLATION {name}: depends on axiom {ax}"
  let lines := report.map fun (n, axs) =>
    "{\"decl\": \"" ++ toString n ++ "\", \"axioms\": [" ++
      String.intercalate ", " (axs.toList.map (fun a => "\"" ++ toString a ++ "\"")) ++ "]}"
  IO.println ("[" ++ String.intercalate ",\n" lines.toList ++ "]")
  IO.eprintln s!"audited {audited} declaration(s), {violations} violation(s)"
  return (if violations > 0 then 1 else 0)
