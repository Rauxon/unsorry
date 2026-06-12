"""The sponsor's draft-PR helper (ADR-021, SPEC-021-A).

ADR-020 stops at a ready packet because mathlib policy reserves the PR and the
review conversation for a human who understands the proof. This helper closes
the *mechanical* half of that last step — and only the mechanical half — for
the human who runs it:

  clone/update mathlib master → fresh branch → `git apply` the packet patch →
  commit (the sponsor's git identity) → push to the sponsor's fork → open a
  **draft** PR against leanprover-community/mathlib4 whose body carries the
  factual AI-disclosure block and a loud placeholder where the sponsor's own
  narrative must go.

The boundary is enforced, not just documented:

- it refuses to run without ``--understood`` — running it IS the sponsor's
  attestation that they have read the proof and can defend it unaided (the
  exact thing mathlib policy requires);
- it refuses a packet that is not ``packet-ready`` or not HEAD-verified
  (no raising PRs for blocked or stale lemmas);
- it opens a **draft** with the narrative left as a ``SPONSOR: replace…``
  placeholder, so the human cannot skip writing it before marking the PR
  ready — the conversation stays the human's, in their own words.

The machine never marks the PR ready and never writes a review reply.

Usage:
  python3 -m tools.upstream.raise_pr --goal <id> --fork <github-user>
      --understood [--root <repo>] [--mathlib-dir <dir>] [--dry-run]
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path
from typing import List

MATHLIB_REPO = "leanprover-community/mathlib4"

_STATUS_RE = re.compile(r"^Status:\s*(\S+)", re.MULTILINE)
_HEAD_RE = re.compile(r"\*\*HEAD verification:\*\*\s*(\w+)\s+at mathlib `([0-9a-f]+)`")
_NAME_RE = re.compile(r"theorem\s+([A-Za-z0-9_.']+)")


def _packet_path(root: Path, goal: str) -> Path:
    return root / "docs" / "upstream" / f"{goal}.md"


def _packet_text(root: Path, goal: str) -> str:
    return _packet_path(root, goal).read_text(encoding="utf-8")


def packet_status(root: Path, goal: str) -> str | None:
    m = _STATUS_RE.search(_packet_text(root, goal))
    return m.group(1) if m else None


def head_verified(root: Path, goal: str) -> bool:
    """True iff the packet carries a HEAD-verification stamp with verdict PASS."""
    m = _HEAD_RE.search(_packet_text(root, goal))
    return bool(m) and m.group(1).upper() == "PASS"


def head_rev(root: Path, goal: str) -> str | None:
    m = _HEAD_RE.search(_packet_text(root, goal))
    return m.group(2) if m else None


def disclosure_block(root: Path, goal: str) -> str:
    """The packet's AI-disclosure paragraph, quote markers stripped."""
    text = _packet_text(root, goal)
    section = text.split("## AI disclosure", 1)[1].split("##", 1)[0]
    lines = []
    for line in section.splitlines():
        s = line.strip()
        if not s or s.startswith("(") or s.startswith("##"):
            continue
        lines.append(re.sub(r"^>\s?", "", line).rstrip())
    return "\n".join(l for l in lines if l.strip())


def _theorem_name(root: Path, goal: str) -> str:
    patch = (root / "docs" / "upstream" / f"{goal}.patch").read_text(encoding="utf-8")
    for line in patch.splitlines():
        if line.startswith("+theorem "):
            m = _NAME_RE.search(line[1:])
            if m:
                return m.group(1)
    return goal.replace("-", "_")


def pr_title(root: Path, goal: str) -> str:
    return f"[DRAFT] feat: {_theorem_name(root, goal)}"


def pr_body(root: Path, goal: str) -> str:
    rev = head_rev(root, goal) or "unknown"
    return f"""<!-- SPONSOR: this PR was opened as a DRAFT by tools/upstream/raise_pr.py.
     It is NOT ready for review until you replace the narrative below with
     your own words and mark it ready. Mathlib policy forbids LLM-written PR
     and review conversation — the machine prepared the patch and the facts,
     the words are yours. -->

> **SPONSOR: replace this section with your own description, in your own words.**
> What is the lemma, why is it wanted, where does it belong, what did the Zulip
> thread conclude? Do not paste machine-written prose here — delete this block
> once written.

---

### Provenance & AI disclosure

{disclosure_block(root, goal)}

The proof was additionally re-verified against mathlib master `{rev}` before
this PR (a scratch-project kernel build), not only against the pinned release
it was proved on.

### Checklist before marking ready
- [ ] I have read the proof and can justify each step **without AI assistance**.
- [ ] I opened (or linked) a **Zulip** thread and the lemma is wanted here.
- [ ] I replaced the narrative above with my own words.
- [ ] The `LLM-generated` label is applied.
- [ ] One lemma, golfed to the linter's satisfaction (binder names, line length).
"""


def check_preconditions(root: Path, goal: str, understood: bool) -> List[str]:
    errs: List[str] = []
    if not understood:
        errs.append(
            "refusing without --understood: running this helper attests that "
            "YOU have read the proof and can justify it without AI (mathlib policy)"
        )
    packet = _packet_path(root, goal)
    if not packet.is_file():
        errs.append(f"no packet at {packet}")
        return errs  # nothing else to check
    if not (root / "docs" / "upstream" / f"{goal}.patch").is_file():
        errs.append(f"no patch at docs/upstream/{goal}.patch")
    status = packet_status(root, goal)
    if status != "packet-ready":
        errs.append(
            f"packet status is '{status}', not 'packet-ready' — "
            "resolve the dedup/blocking issue before raising a PR"
        )
    if not head_verified(root, goal):
        errs.append(
            "packet has no PASS HEAD-verification stamp — run "
            "`tools/upstream/verify_head.sh "
            f"{goal} --stamp` first (the lemma must build at mathlib HEAD)"
        )
    return errs


def _run(cmd: List[str], *, dry: bool, cwd: Path | None = None) -> None:
    if dry:
        print("  $", " ".join(cmd))
        return
    subprocess.run(cmd, check=True, cwd=cwd)


def main(argv: List[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="tools.upstream.raise_pr")
    parser.add_argument("--goal", required=True)
    parser.add_argument("--fork", required=True,
                        help="your github username (the mathlib4 fork owner)")
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--understood", action="store_true",
                        help="attest you have read the proof and can defend it without AI")
    parser.add_argument("--mathlib-dir", type=Path,
                        default=Path("/tmp/unsorry-mathlib-pr"),
                        help="scratch mathlib checkout (reused across goals)")
    parser.add_argument("--dry-run", action="store_true",
                        help="print the plan and the PR body, touch nothing")
    args = parser.parse_args(argv)

    errs = check_preconditions(args.root, args.goal, args.understood)
    if errs:
        for e in errs:
            print(f"error: {e}", file=sys.stderr)
        return 2

    branch = f"unsorry/{args.goal}"
    patch = (args.root / "docs" / "upstream" / f"{args.goal}.patch").resolve()
    title = pr_title(args.root, args.goal)
    body = pr_body(args.root, args.goal)
    ml = args.mathlib_dir
    fork_url = f"https://github.com/{args.fork}/mathlib4"

    print(f"Raising a DRAFT mathlib PR for `{args.goal}`:")
    print(f"  target: {MATHLIB_REPO} (draft)   fork: {args.fork}")
    print(f"  branch: {branch}   title: {title}")

    if not ml.exists():
        _run(["git", "clone", "--depth", "1",
              f"https://github.com/{MATHLIB_REPO}", str(ml)], dry=args.dry_run)
    else:
        _run(["git", "-C", str(ml), "fetch", "-q", "origin", "master"], dry=args.dry_run)
        _run(["git", "-C", str(ml), "checkout", "-q", "master"], dry=args.dry_run)
        _run(["git", "-C", str(ml), "reset", "--hard", "-q", "origin/master"], dry=args.dry_run)
    _run(["git", "-C", str(ml), "switch", "-c", branch], dry=args.dry_run)
    _run(["git", "-C", str(ml), "apply", str(patch)], dry=args.dry_run)
    _run(["git", "-C", str(ml), "add", "-A"], dry=args.dry_run)
    _run(["git", "-C", str(ml), "commit", "-q", "-m", title.replace("[DRAFT] ", "")],
         dry=args.dry_run)
    _run(["git", "-C", str(ml), "push", "-q", fork_url, f"{branch}:{branch}"],
         dry=args.dry_run)

    if args.dry_run:
        print("\n  $ gh pr create --draft \\")
        print(f"      --repo {MATHLIB_REPO} \\")
        print(f"      --head {args.fork}:{branch} --base master \\")
        print(f"      --title {title!r} --body <body>")
        print("\n--- PR body (draft) ---")
        print(body)
        print("--- end body ---")
        print("\nDry run: nothing was cloned, pushed, or opened.")
        return 0

    proc = subprocess.run(
        ["gh", "pr", "create", "--draft", "--repo", MATHLIB_REPO,
         "--head", f"{args.fork}:{branch}", "--base", "master",
         "--title", title, "--body", body],
        cwd=ml, capture_output=True, text=True,
    )
    sys.stdout.write(proc.stdout)
    sys.stderr.write(proc.stderr)
    if proc.returncode != 0:
        return 1
    print("\nDRAFT opened. It is NOT a review request yet. Before marking ready:")
    print("  1) replace the narrative placeholder with your own words,")
    print("  2) ensure the LLM-generated label is applied,")
    print("  3) confirm the Zulip thread, then flip draft → ready yourself.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
