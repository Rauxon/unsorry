# Mathlib Upstream Path (Thread C plan)

Status: proposal / for discussion · 2026-06-11 · Implements the Phase-3 roadmap's thread C

The public good is only realised when a verified lemma lands *in the commons*. This is the plan for getting unsorry's novel lemmas into mathlib — designed around mathlib's actual contribution policy, which was verified against [the contributing guide](https://leanprover-community.github.io/contribute/index.html) on 2026-06-11, not assumed.

## The constraint that shapes everything: mathlib's AI policy

Mathlib's policy (verbatim requirements, current as of 2026-06-11):

- AI use **must be disclosed** in the PR description — which tools, and how they were used.
- A PR with substantial LLM-generated code gets the **`LLM-generated` label**.
- The author must **understand all AI-written content** and be able to justify each decision to reviewers **without the use of an AI**.
- Review teams **summarily close** low-quality LLM PRs, especially from authors who haven't engaged the community first; repeat offenders face bans.
- LLM-written comments on GitHub/Zulip are **not allowed** — the human speaks in their own words.

**Consequence: a fully autonomous unsorry→mathlib pipeline is against mathlib policy and is a non-goal of this plan.** Anything else would also be strategically self-defeating: unsorry's credibility rests on honesty about what the kernel does and doesn't certify, and mathlib's bar is community trust, not just kernel-validity. One spammy AI PR would cost more than a merged lemma gains.

## The model: machine-prepared, human-sponsored

unsorry's deliverable is an **upstream packet** per candidate lemma — everything a human sponsor needs to take the lemma to mathlib honestly and efficiently. The human sponsor (a real contributor, in their own words) owns the Zulip discussion, the PR, and the review conversation, and must genuinely understand the proof line-by-line before opening anything.

Division of labour:

| Machine (unsorry tooling) | Human sponsor |
|---|---|
| Dedup against mathlib **HEAD** at packet time (our absence checks date from the pinned v4.30.0) | Reads and understands the proof completely |
| Mathlib-style restatement: naming-convention proposal, namespace, line length, docstring + copyright header skeleton | Opens a **Zulip thread first** ("is this lemma wanted, where, under what name?") in their own words |
| Scratch-project build: the restated lemma **kernel-verified against mathlib HEAD**, not just our pin | Opens the PR with full AI disclosure + `LLM-generated` label |
| Generalization analysis: what reviewers will likely ask (see per-candidate notes) | Answers review comments without AI assistance |
| Provenance dossier: model, prompts, run records, gate evidence — so disclosure is precise, not vague | Decides whether to proceed at all after Zulip feedback |

## Current candidates (and honest per-candidate notes)

Only mathlib-absent novel results qualify — today that is 2 of the library's 19 lemmas (the other 17 are shakedown trivia mathlib already has):

1. **`nicomachus_sum_cubes`** (`∑ k ∈ range n, k³ = (∑ k ∈ range n, k)²`). Likely home: `Mathlib/Algebra/BigOperators/Intervals.lean` near `Finset.sum_range_id`; plausible mathlib name `Finset.sum_range_cube` or similar — naming is a Zulip question, not ours to decide. **Honest complication:** this identity is left as a reader exercise in *Mathematics in Lean* §5. Merging it makes `exact?` solve that exercise. Maintainers may consider that a feature (it's a real library gap) or a reason to decline — the Zulip-first step exists precisely for this question.
2. **`sum_range_pow_four_closed`** (`30·∑k⁴ = n(n+1)(2n+1)(3n²+3n−1)` over ℤ). **Honest complication:** mathlib has the general Bernoulli machinery (`Finset.sum_range_pow`, over ℚ). Reviewers may prefer (a) the elementary ℤ/ℕ closed form as-is (no ℚ division, decide-friendly), (b) deriving it from the Bernoulli form, or (c) declining as a special case. The packet's generalization analysis must present all three fairly.

Expectation-setting: **two elementary identities are a credibility probe, not a flood.** The realistic outcome includes "mathlib declines both" — that is a valid, recorded result that still validates the pipeline (the packet machinery is reusable as harder, more clearly-wanted lemmas accumulate from Phase-3 runs).

## The pipeline (five stages)

1. **Select** — a proved, mathlib-absent, non-shakedown lemma; tracked as `upstream≜candidate` provenance on the goal's backlog entry.
2. **Re-verify absence at HEAD** — `tools/upstream/dedup_head.py`: clone mathlib master, run the ADR-012 absence check against it (not the pin), plus Loogle/LeanSearch when reachable. Mathlib moves; a 4.30.0 absence claim can be stale.
3. **Restate** — `tools/upstream/packet.py` drafts the mathlib-style artifact: proposed name + namespace + file placement, header (copyright, **human author**, license), module-doc line, 100-col formatting, and the proof body (possibly golfed: mathlib prefers terse idiomatic proofs over verbose induction where a one-liner exists).
4. **Verify at HEAD** — a scratch Lake project pinned to mathlib master builds the restated lemma; the kernel, not optimism, says it still holds at HEAD.
5. **Hand off** — the packet (`docs/upstream/<id>.md`: restated lemma, build evidence, dedup evidence, generalization analysis, provenance dossier, draft disclosure text) goes to the human sponsor. Everything after the packet is human: Zulip, PR, review. Status tracked on the targets board (`candidate → packet-ready → in-discussion → pr-open → merged | declined`), each transition a gated docs PR.

## What gets built (implementation scope, when thread C is scheduled)

- `tools/upstream/dedup_head.py` + `tools/upstream/packet.py` (+ tests, TDD as usual)
- `docs/upstream/` packet home; targets-board upstream-status column
- ADR-015 (decision: human-sponsored upstreaming; autonomous PRs rejected) + SPEC-015-A — **ADR lands as Proposed and needs the sponsor's explicit sign-up**, because the plan commits a named human to real work and real community standing, which is not the maintainer-bot's to promise.

## Non-goals

- No autonomous PRs, comments, or Zulip posts to mathlib — ever, per policy.
- No bulk submission. One lemma per PR, Zulip-first, spaced by community feedback.
- The 17 shakedown lemmas are not candidates; they exist in mathlib already.

## Exit metric for thread C

**A first unsorry-originated lemma merged into mathlib, with full AI provenance disclosed** — or an honest recorded outcome that mathlib declined, with the packet pipeline proven and reusable for stronger future candidates.
