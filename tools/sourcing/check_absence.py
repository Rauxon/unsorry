"""Mathlib absence check (backlog sourcing, ADR-012).

A target only belongs in the backlog if it is *not already in mathlib* — and,
as the Nicomachus case showed, that is exactly the claim humans and LLMs get
wrong from memory. So absence is a **machine** step, not a judgement call.

This tool greps the pinned mathlib source (the authoritative local check — the
checkout IS the version the swarm builds against) for caller-supplied patterns
that would appear if the theorem were already stated, and optionally cross-checks
a Loogle query when the service is reachable. It records the mathlib revision so
an absence claim carries the commit it was verified against (mathlib moves; the
claim has a shelf life).

It is a **pre-filter, not a proof of absence**: grep cannot decide semantic
presence. The definitive evidence is downstream — if a target were in mathlib,
the prove cycle would discharge it with a one-line citation rather than a real
proof. This tool keeps obvious duplicates out of the queue cheaply.

Usage:
  python3 -m tools.sourcing.check_absence --mathlib <dir> \\
      --pattern '<regex>' [--pattern '<regex>' ...] [--loogle '<query>'] [--rev <sha>]

Exit: 0 = no local match (absent as far as grep can tell) · 1 = a pattern
matched (possible duplicate, review the printed hits) · 2 = usage/error.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

LOOGLE_URL = "https://loogle.lean-lang.org/json"


def grep_mathlib(mathlib: Path, patterns: list[str]) -> list[tuple[str, str, str]]:
    """Return (pattern, relative-path, line) for every match in *.lean."""
    compiled = [(p, re.compile(p)) for p in patterns]
    hits: list[tuple[str, str, str]] = []
    for path in mathlib.rglob("*.lean"):
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for line in text.splitlines():
            for raw, rx in compiled:
                if rx.search(line):
                    hits.append((raw, str(path.relative_to(mathlib.parent)), line.strip()))
    return hits


def loogle(query: str, timeout: float = 12.0) -> dict | None:
    """Best-effort Loogle query; None if the service is unreachable."""
    url = f"{LOOGLE_URL}?{urllib.parse.urlencode({'q': query})}"
    try:
        with urllib.request.urlopen(url, timeout=timeout) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except (urllib.error.URLError, OSError, ValueError, TimeoutError):
        return None


def manifest_rev(repo_root: Path) -> str | None:
    manifest = repo_root / "lake-manifest.json"
    if not manifest.is_file():
        return None
    try:
        data = json.loads(manifest.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None
    for pkg in data.get("packages", []):
        if pkg.get("name") == "mathlib":
            return pkg.get("rev")
    return None


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="tools.sourcing.check_absence")
    parser.add_argument("--mathlib", type=Path,
                        default=Path(".lake/packages/mathlib/Mathlib"))
    parser.add_argument("--pattern", action="append", default=[],
                        help="regex that would match the theorem if already stated")
    parser.add_argument("--loogle", help="optional Loogle query for corroboration")
    parser.add_argument("--rev", help="override the recorded mathlib revision")
    parser.add_argument("--json", action="store_true", dest="as_json")
    args = parser.parse_args(argv)

    if not args.pattern and not args.loogle:
        print("error: give at least one --pattern (or --loogle)", file=sys.stderr)
        return 2
    if not args.mathlib.is_dir():
        print(f"error: mathlib source not found at {args.mathlib}", file=sys.stderr)
        return 2

    rev = args.rev or manifest_rev(Path.cwd()) or "unknown"
    hits = grep_mathlib(args.mathlib, args.pattern) if args.pattern else []
    loogle_result = loogle(args.loogle) if args.loogle else None
    loogle_count = None
    if loogle_result is not None:
        loogle_count = len(loogle_result.get("hits", []) or [])

    report = {
        "mathlib_rev": rev,
        "patterns": args.pattern,
        "local_matches": [{"pattern": p, "file": f, "line": ln} for p, f, ln in hits],
        "loogle_query": args.loogle,
        "loogle_reachable": loogle_result is not None,
        "loogle_hits": loogle_count,
        "verdict": "possible-duplicate" if hits else "no-local-match",
    }

    if args.as_json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(f"mathlib rev: {rev}")
        if hits:
            print(f"POSSIBLE DUPLICATE — {len(hits)} local match(es):")
            for p, f, ln in hits:
                print(f"  [{p}] {f}: {ln}")
        else:
            print("no local match — absent as far as grep can tell")
        if args.loogle:
            if loogle_result is None:
                print("loogle: unreachable (grep is authoritative here)")
            else:
                print(f"loogle: {loogle_count} hit(s) for {args.loogle!r}")

    return 1 if hits else 0


if __name__ == "__main__":
    raise SystemExit(main())
