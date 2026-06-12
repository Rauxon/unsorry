#!/usr/bin/env bash
# Acceptance tests for SPEC-006-A (axiom_audit). Run from repo root.
# Requires the Lean toolchain; builds fixtures explicitly (they are never in defaultTargets).
set -euo pipefail

pass=0; fail=0
ok()  { pass=$((pass+1)); echo "PASS $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1"; }

expect_exit() { # name expected_exit cmd...
  local name="$1" want="$2"; shift 2
  local got=0
  "$@" >/tmp/audit-test-out.json 2>/tmp/audit-test-err.txt || got=$?
  if [ "$got" = "$want" ]; then ok "$name (exit $got)"; else
    bad "$name: want exit $want got $got"; sed -n 1,5p /tmp/audit-test-err.txt; fi
}

expect_err_contains() { # name needle
  if grep -q "$2" /tmp/audit-test-err.txt; then ok "$1"; else
    bad "$1: stderr missing '$2'"; sed -n 1,5p /tmp/audit-test-err.txt; fi
}

lake build AuditFixtures axiom_audit >/dev/null

# clean control passes
expect_exit "clean control" 0 lake exe axiom_audit AuditFixtures.Clean
grep -q '"decl"' /tmp/audit-test-out.json && ok "footprint JSON emitted" || bad "no footprint JSON"

# bare sorry caught
expect_exit "bare sorry" 1 lake exe axiom_audit AuditFixtures.BareSorry
expect_err_contains "bare sorry names sorryAx" "sorryAx"

# term-level sorryAx caught
expect_exit "term sorryAx" 1 lake exe axiom_audit AuditFixtures.TermSorryAx
expect_err_contains "term sorryAx names sorryAx" "sorryAx"

# new axiom caught (axiom itself and its dependent)
expect_exit "new axiom" 1 lake exe axiom_audit AuditFixtures.NewAxiom
expect_err_contains "new axiom named" "fixture_evil"

# native_decide caught
expect_exit "native_decide" 1 lake exe axiom_audit AuditFixtures.NativeDecide
expect_err_contains "native_decide axiom named" "native_decide"

# --allow-sorry flips ONLY the sorry fixtures
expect_exit "allow-sorry: bare sorry passes" 0 lake exe axiom_audit --allow-sorry AuditFixtures.BareSorry
expect_exit "allow-sorry: term sorryAx passes" 0 lake exe axiom_audit --allow-sorry AuditFixtures.TermSorryAx
expect_exit "allow-sorry: new axiom still fails" 1 lake exe axiom_audit --allow-sorry AuditFixtures.NewAxiom
expect_exit "allow-sorry: native_decide still fails" 1 lake exe axiom_audit --allow-sorry AuditFixtures.NativeDecide

# opaque constants are sound (kernel demands an Inhabited witness — no new
# assumption) and must neither trip the audit nor crash it (#190 corpus item)
expect_exit "opaque constant passes (no new axiom)" 0 lake exe axiom_audit AuditFixtures.Opaque

# usage error
expect_exit "no modules is usage error" 2 lake exe axiom_audit

# the real library is clean
expect_exit "UnsorryLibrary clean" 0 lake exe axiom_audit Unsorry.Basic

echo "----"
echo "$pass passed, $fail failed"
[ "$fail" = 0 ]
