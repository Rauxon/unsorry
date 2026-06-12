"""ADR-021 / SPEC-021-A: the sponsor's draft-PR helper."""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from tools.upstream.raise_pr import (
    check_preconditions,
    disclosure_block,
    head_verified,
    packet_status,
    pr_body,
    pr_title,
)

_PACKET = """# Upstream packet: `novel-lemma`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
theorem novel_lemma_thm : 1 = 1 := rfl
```

## AI disclosure (paste-ready facts)

> The Lean proof in this PR was produced by an autonomous LLM agent.
> I have read and understood the proof in full. Label: `LLM-generated`.

## For the sponsor

1. Read it.

**HEAD verification:** PASS at mathlib `deadbeef` (2026-06-12T03:27Z)
"""

_BLOCKED = _PACKET.replace("Status: packet-ready", "Status: blocked-possible-duplicate")
_UNVERIFIED = _PACKET.replace(
    "\n**HEAD verification:** PASS at mathlib `deadbeef` (2026-06-12T03:27Z)\n", "\n"
)
_FAILED_HEAD = _PACKET.replace("PASS at mathlib", "FAIL at mathlib")


def _mk(tmp_path: Path, goal: str, packet: str, *, patch: bool = True) -> Path:
    root = tmp_path
    up = root / "docs" / "upstream"
    up.mkdir(parents=True)
    (up / f"{goal}.md").write_text(packet, encoding="utf-8")
    if patch:
        (up / f"{goal}.patch").write_text(
            "--- /dev/null\n+++ b/Mathlib/Unsorry/Novel.lean\n@@ -0,0 +1,1 @@\n"
            "+theorem novel_lemma_thm : 1 = 1 := rfl\n",
            encoding="utf-8",
        )
    return root


def test_packet_status_and_head_verified(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    assert packet_status(root, "novel-lemma") == "packet-ready"
    assert head_verified(root, "novel-lemma") is True


def test_head_verified_false_when_unstamped_or_failed(tmp_path):
    assert head_verified(_mk(tmp_path / "a", "g", _UNVERIFIED), "g") is False
    assert head_verified(_mk(tmp_path / "b", "g", _FAILED_HEAD), "g") is False


def test_disclosure_block_extracted(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    d = disclosure_block(root, "novel-lemma")
    assert "autonomous LLM agent" in d
    assert "LLM-generated" in d
    # The leading '> ' quote markers are stripped for the PR body.
    assert not d.lstrip().startswith(">")


def test_pr_title_and_body(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    assert pr_title(root, "novel-lemma").startswith("[DRAFT]")
    body = pr_body(root, "novel-lemma")
    assert "autonomous LLM agent" in body          # factual disclosure included
    assert "SPONSOR: replace" in body              # the human-narrative placeholder
    assert "LLM-generated" in body
    assert "without AI" in body                     # the policy reminder


def test_preconditions_pass_on_ready_verified(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    assert check_preconditions(root, "novel-lemma", understood=True) == []


def test_preconditions_block_without_understood(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    errs = check_preconditions(root, "novel-lemma", understood=False)
    assert any("understood" in e.lower() for e in errs)


def test_preconditions_block_on_blocked_status(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _BLOCKED)
    errs = check_preconditions(root, "novel-lemma", understood=True)
    assert any("blocked" in e.lower() or "packet-ready" in e.lower() for e in errs)


def test_preconditions_block_on_unverified_head(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _UNVERIFIED)
    errs = check_preconditions(root, "novel-lemma", understood=True)
    assert any("head" in e.lower() for e in errs)


def test_preconditions_block_on_missing_patch(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET, patch=False)
    errs = check_preconditions(root, "novel-lemma", understood=True)
    assert any("patch" in e.lower() for e in errs)


def test_cli_dry_run_prints_plan_without_side_effects(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    proc = subprocess.run(
        [sys.executable, "-m", "tools.upstream.raise_pr",
         "--goal", "novel-lemma", "--root", str(root),
         "--fork", "sponsoruser", "--understood", "--dry-run"],
        capture_output=True, text=True,
        cwd=Path(__file__).resolve().parents[3],
    )
    assert proc.returncode == 0, proc.stderr
    assert "leanprover-community/mathlib4" in proc.stdout
    assert "draft" in proc.stdout.lower()
    assert "sponsoruser" in proc.stdout


def test_cli_dry_run_refuses_without_understood(tmp_path):
    root = _mk(tmp_path, "novel-lemma", _PACKET)
    proc = subprocess.run(
        [sys.executable, "-m", "tools.upstream.raise_pr",
         "--goal", "novel-lemma", "--root", str(root),
         "--fork", "sponsoruser", "--dry-run"],
        capture_output=True, text=True,
        cwd=Path(__file__).resolve().parents[3],
    )
    assert proc.returncode != 0
    assert "understood" in (proc.stdout + proc.stderr).lower()
