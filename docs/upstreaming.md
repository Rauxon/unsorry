# Upstreaming to mathlib — the sponsor's process

How a lemma the swarm proved becomes a lemma in [mathlib](https://github.com/leanprover-community/mathlib4).
This is the human-facing companion to [ADR-020](adrs/ADR-020-Human-Sponsored-Upstreaming.md)
(the pipeline) and [ADR-021](adrs/ADR-021-Sponsor-PR-Helper.md) (the draft-PR helper).

## The one rule that shapes everything

Mathlib's AI-contribution policy: **disclose** AI use, carry the `LLM-generated`
label, the **author must understand everything and justify it without AI**, and
**LLM-written PR/Zulip conversation is not allowed**. Low-quality autonomous LLM
PRs are summarily closed. So the machine prepares the *artifact and the facts*;
the **human sponsor** owns the *understanding and every word the community reads*.
A fully autonomous unsorry→mathlib PR is a permanent non-goal.

## What is automatic, and what is yours

| Stage | Who | What |
|---|---|---|
| 1. Detect eligibility | **machine** (nightly) | proved + absence-verified + unpacketed |
| 2. Dedup at mathlib HEAD | **machine** | re-grep master; record the rev |
| 3. Packet + patch | **machine** | `docs/upstream/<id>.md` + a `git apply`-able `.patch` (your author header, golfed proof, disclosure) |
| 4. Packet PR into unsorry | **machine** | a gated docs PR, assigned to you |
| 5. HEAD kernel-verify | machine, you trigger | `verify_head.sh` builds the patch against master; stamps the packet |
| 6. **Understand the proof** | **you** | read until you can defend every step unaided |
| 7. **Zulip first** | **you, own words** | is it wanted, where, what name? |
| 8. Raise the **draft** PR | machine plumbing, **you run it** | `raise_pr.py` does the git/gh mechanics, opens a draft |
| 9. **Write the narrative** | **you, own words** | replace the placeholder; apply the label |
| 10. **Mark ready → review** | **you** | flip draft→ready; answer reviewers in your own words |

Stages 1–5 need no human kick-off — a target that becomes ready packets itself
and lands in your PR queue. Stages 6–10 are irreducibly yours; the tooling only
removes the *mechanical* friction from 8.

## Step by step, with the commands

You have a packet PR (stage 4). From the unsorry repo root:

**a. Verify it still holds at mathlib HEAD** (if the packet isn't stamped yet):
```
./tools/upstream/verify_head.sh <goal> --stamp
```
A `PASS` stamp is a precondition for raising the PR; a `FAIL` means mathlib
moved under the lemma — record it and stop.

**b. Read the proof.** The patch is `docs/upstream/<goal>.patch` — one short
Lean file. You must be able to justify it to a reviewer without AI. This is the
gate, not a formality.

**c. Zulip, in your own words.** Open a thread on the
[mathlib Zulip](https://leanprover.zulipchat.com/): is this lemma wanted, where
should it live, what should it be called? Naming and placement are the
community's call, not the packet's (the patch path is a deliberate placeholder).

**d. Raise the draft PR — one command:**
```
python3 -m tools.upstream.raise_pr --goal <goal> --fork <your-github-user> --understood
```
- `--understood` is your attestation that you've done step (b). The helper
  **refuses without it**, and refuses a packet that isn't `packet-ready` or
  HEAD-verified.
- `--dry-run` prints the exact plan and the draft body without touching
  anything — run it first.
- It clones mathlib master, applies the patch to a fresh branch, pushes to
  **your fork**, and opens a **draft** PR against `leanprover-community/mathlib4`
  whose body has the factual disclosure and a loud `SPONSOR: replace…`
  placeholder. It never marks the PR ready and never writes a review reply.

**e. Make it yours.** In the draft: replace the placeholder with your own
description (what the Zulip thread concluded, why it's wanted), confirm the
`LLM-generated` label, then **you** flip draft → ready.

**f. Review.** Answer reviewers in your own words; expect linter golfing
(binder names, 100-column) — that editing is yours. Record the outcome on the
[targets board](targets.md): `in-discussion → pr-open → merged | declined`.
**Declined is a valid, recorded result** — it still validates the pipeline.

## Why a *draft*, and why `--understood`

The draft state and the narrative placeholder are mechanical enforcement of the
policy boundary: a draft is not a review request, and you cannot mark it ready
without having written the description yourself. `--understood` makes running the
helper an explicit attestation rather than a reflex. The machine does everything
that is pure plumbing and nothing that is a human judgement or a human word.
