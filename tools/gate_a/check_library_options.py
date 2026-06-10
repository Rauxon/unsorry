"""Authoritative Gate A check: no `set_option` re-enables an unsound elaboration
mode inside the verified library.

Why this is its own check and not the textual-diff belt
-------------------------------------------------------
The Stage-4 red team (W3, PR #64) merged a vacuous theorem into `library/` by
turning `autoImplicit` back on — the lakefile sets it `false` package-wide, but
a module-level `set_option autoImplicit true` overrides that, and with it Lean
auto-binds free identifiers as implicit `Prop`s, so `(h : p) (hn : ¬ p) : ¬ g`
type-checks as the vacuous `∀ {p g : Prop}, p → ¬p → ¬g` under an impressive
name. The build, axiom audit and leanchecker all pass it (it is *sound*, just
meaningless) — verified in sandbox. So for this vector the lint **is** the bar,
not a belt, and it must not be evadable.

The original inline check grepped the PR diff line-by-line for
`set_option\\s+autoImplicit\\s+true`; the red team split the option across two
lines (`set_option autoImplicit\\n  true`) and walked straight through. This
check fixes both weaknesses: it scans the **whole** contents of every
`library/**/*.lean` file (not just added diff lines) with **all whitespace —
newlines included — collapsed**, so line-splitting cannot hide the option.

`autoImplicit` and `relaxedAutoImplicit` have no legitimate use in a verified
library; re-enabling either is always a finding.
"""
from __future__ import annotations

import re
import sys
import unicodedata
from pathlib import Path

#: Elaboration options that must never be re-enabled inside the library.
FORBIDDEN_OPTIONS = ("autoImplicit", "relaxedAutoImplicit")

#: After whitespace collapse, this matches `set_option <opt> true` for each.
_PATTERNS = {
    opt: re.compile(rf"set_option\s+{re.escape(opt)}\s+true\b")
    for opt in FORBIDDEN_OPTIONS
}


def _collapse(text: str) -> str:
    """NFC, then every run of whitespace (incl. newlines) → a single space."""
    return re.sub(r"\s+", " ", unicodedata.normalize("NFC", text))


def findings_for_text(text: str) -> list[str]:
    collapsed = _collapse(text)
    return [opt for opt, pat in _PATTERNS.items() if pat.search(collapsed)]


def scan_library(library_root: Path) -> list[tuple[Path, str]]:
    """Return (path, option) for every forbidden re-enable under the library."""
    findings: list[tuple[Path, str]] = []
    for path in sorted(library_root.rglob("*.lean")):
        for opt in findings_for_text(path.read_text(encoding="utf-8")):
            findings.append((path, opt))
    return findings


def main(argv: list[str] | None = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    root = Path(argv[0]) if argv else Path("library")
    if not root.is_dir():
        # No library yet is vacuously clean (not an error).
        return 0
    findings = scan_library(root)
    for path, opt in findings:
        print(f"FORBIDDEN {path}: re-enables `set_option {opt} true` "
              f"in the verified library")
    if findings:
        print(f"{len(findings)} forbidden option re-enable(s) in library/",
              file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
