#!/usr/bin/env bash
# tools/upstream/verify_head.sh — kernel-verify a packet's contribution at
# mathlib HEAD (ADR-020 / SPEC-020-A, pipeline stage 4).
#
# The dedup grep is a pre-filter; THIS is the strong evidence: the packet's
# proposed file builds, by the kernel, against mathlib master — not against
# our pin. A failure here is signal, not error: mathlib moved under the lemma
# (or already subsumes it), and the packet must say so before a sponsor
# spends community goodwill on it.
#
# Usage: ./tools/upstream/verify_head.sh <goal> [<workdir>] [--stamp]
#   <goal>     packet id; reads docs/upstream/<goal>.patch (run from repo root)
#   <workdir>  scratch home (default /tmp/unsorry-verify-head); the mathlib
#              dependency is cached there across goals — first run is the
#              expensive one (toolchain + cache, ~10-90 min; warm reruns are
#              minutes)
#   --stamp    append the verdict line to docs/upstream/<goal>.md
#
# Exit: 0 verified at HEAD · 1 build failed (recorded) · 2 usage/setup error.
set -euo pipefail

goal="${1:?usage: verify_head.sh <goal> [<workdir>] [--stamp]}"
workdir="${2:-/tmp/unsorry-verify-head}"
stamp=0
for a in "$@"; do [ "$a" = "--stamp" ] && stamp=1; done
repo_root="$(pwd)"
patch="$repo_root/docs/upstream/$goal.patch"
md="$repo_root/docs/upstream/$goal.md"
[ -f "$patch" ] || { echo "no packet patch at $patch" >&2; exit 2; }

scratch="$workdir/scratch"
if [ ! -d "$scratch" ]; then
  mkdir -p "$scratch"
  ( cd "$scratch"
    curl -fsSL https://raw.githubusercontent.com/leanprover-community/mathlib4/master/lean-toolchain \
      -o lean-toolchain
    cat > lakefile.toml <<'TOML'
name = "scratch"
defaultTargets = ["Scratch"]

[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4"

[[lean_lib]]
name = "Scratch"
TOML
    lake update mathlib
    lake exe cache get || echo "warning: cache get failed — cold build ahead" >&2
  )
fi

# The patch body (a new-file diff) IS the file: strip the diff plumbing.
grep '^+' "$patch" | grep -v '^+++' | sed 's/^+//' > "$scratch/Scratch.lean"

rev="$(git -C "$scratch/.lake/packages/mathlib" rev-parse HEAD 2>/dev/null || echo unknown)"
verdict=PASS
( cd "$scratch" && lake build Scratch ) || verdict=FAIL

line="**HEAD verification:** $verdict at mathlib \`$rev\` ($(date -u +%Y-%m-%dT%H:%MZ))"
echo "$line"
if [ "$stamp" = 1 ] && [ -f "$md" ]; then
  printf '\n%s\n' "$line" >> "$md"
fi
[ "$verdict" = PASS ]
