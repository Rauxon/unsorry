# Phase 3 Roadmap (proposal)

Status: proposal / for discussion · 2026-06-10

Phase 2 demonstrated the loop *can* produce novel, kernel-verified mathematics: the machinery (decomposition, affinity/gap selection, the statement-binding gate) is built and red-team-proven, and the swarm proved its first mathlib-absent lemma (Nicomachus, [phase2-run-001](../metrics/phase2-run-001.md)). That is a proof of concept. Phase 3 asks the question a proof of concept cannot: **does it scale and sharpen?** Does a swarm pointed at genuinely hard, mathlib-absent targets grow the verified commons faster than people can — or does it stall at the elementary band?

This is a menu of the work that question breaks into, not a committed plan. The threads are roughly independent; pick the order by what we most want to learn.

## The honest gaps Phase 2 leaves

1. **Decomposition is demonstrated on paper, not in anger.** Nicomachus was proved *directly*; the decompose → prove-subs → recompose chain has unit tests and Gate-B guardrails but has never carried a proof the swarm couldn't one-shot. Until a real target forces it, "compounding" is a claim.
2. **No target *result*, only isolated lemmas.** The design doc's Phase 2 was "drive toward a chosen unformalised result by decomposition." We built the machinery and proved standalone lemmas; we have not yet pointed the swarm at one *result* and watched a dependency tree fill toward it.
3. **The library is unsorry's, not mathlib's.** The public good is only realised when a verified lemma lands *in the commons*. Right now nothing upstreams.
4. **One model, a few agents, the maintainer's account.** The "rag-tag heterogeneous swarm" is still aspirational at volume; authorship is by orchestration trail, not cryptography (ADR-007).
5. **Known inefficiencies.** Merge-lag duplicate fan-out wasted ~64% of cycles in `phase1-run-002`; absence is a grep pre-filter with a shelf life; Agent SDK credit economics are unbudgeted at scale.

## Candidate threads

### A. Force and prove decomposition (closest to done)
Drive the swarm at a target hard enough that a direct proof fails and decomposition *must* fire, then show the full chain close through Gate A. The [hard-target run](../metrics/) (Sophie Germain `n⁴+4`, the Platonic–Schläfli arithmetic core, …) is the first probe. **Exit:** at least one target reached *via* decompose → recompose, recorded end-to-end. This is the single most important gap to close — it turns "compounding" from a design claim into an observed fact.

### B. Drive to a chosen *result* through a dependency tree
Pick one unformalised result whose proof genuinely needs several lemmas in order (e.g. a closed-form via its Gauss-sum dependency, or a number-theory result built on 3–4 sub-lemmas), seed the target plus its dependency edges, and let affinity/gap selection route the swarm bottom-up. **Exit:** a target closed where the merged sub-lemmas were *reused* as importable dependencies — the compounding the architecture is named for.

### C. Upstream to mathlib (realise the public good)
A path from a verified `library/Unsorry/*.lean` lemma to a mathlib-ready PR: naming/style conformance, dedup against mathlib HEAD at submission time, and an artifact a human can open upstream. The value of the commons is only realised in the commons. **Planned:** [mathlib-upstream-plan.md](mathlib-upstream-plan.md) — mathlib's AI policy (verified 2026-06-11) requires disclosure, an `LLM-generated` label, and an author who understands every line without AI, so the model is **machine-prepared packets, human-sponsored PRs**; a fully autonomous pipeline is against policy and a non-goal.

### D. Open the swarm to real contributors at volume
Invite external people to run agents on their own machines/subscriptions; observe claim-collision, merge-rate, and coordination dynamics at higher concurrency than the maintainer's few agents. Tests the design's core promise (untrusted, heterogeneous, rag-tag) for real. **Prereq:** the dedup fix below, or collision/merge churn will dominate.

### E. Harden the economics and the dedup
Fix the merge-lag duplicate fan-out (a "sha-already-in-library / claimed-by-me" short-circuit decoupled from the main-branch status flip — flagged in `phase1-run-002`); budget Agent SDK credit for sustained runs; consider a GitHub merge queue if volume grows. Unglamorous, but it is the difference between a demo and a service.

**Failure notes.** Today a failed prove attempt records *that* the goal resisted (the −10 affinity demote PR) but not *what was tried*: the failed Lean text is discarded with the worktree, so the next agent re-walks the same dead ends blind — and with concurrency, every agent pays full price for the same lesson. Add a one-line approach note to the demote path (e.g. `note≜induction on n stalls at Even/ℕ-division bookkeeping`, written by the prover on give-up, carried on the demote PR and surfaced to the next claimant's prove prompt). Cheap to record, compounds across agents, and turns the affinity scalar into transferable knowledge. Keep it one line — full failed proofs are noise; the *diagnosis* is the asset.

### F. Statement fidelity for research targets
For non-trivial targets the *formalisation* being faithful matters more than for trivia. Strengthen the dual-translation/fidelity gate (and the human-flag path) so a hard target's Lean statement provably captures its informal claim — the residue ADR-011 explicitly leaves to fidelity, not binding.

### G. Benchmark AISP's value
The coordination layer is written in AISP (ADR-003) on two claims — compactness in LLM context and drift-resistant machine validation — and neither has ever been *measured* against the boring alternative (JSON/YAML with a schema validator). Honest starting observation: most records are machine-rendered (`py_helper`) and machine-parsed (Gate B), so the LLM rarely touches AISP directly; where it does is the swarm contract (`protocol.aisp` + the ~19 KB grammar guide loaded into **every agent session**) and records quoted into prompts. The benchmark, in two layers:

1. **Observational (free, always on):** instrument what already flows — tokens per record and per loaded contract vs a generated JSON mirror; Gate B first-try rejection rate per record type; render-retry counts in `metrics.jsonl`. Lands in every run report.
2. **A/B trial (the real test):** a JSON mirror of the three record schemas plus a prose/JSON mirror of the swarm contract, semantically identical; run matched translate/prove cycles (same goals, same model) with `format=aisp` vs `format=json`; compare first-try record validity, protocol-discipline errors (claim/TTL misuse), end-to-end cycle success, and tokens consumed. → `docs/metrics/aisp-benchmark-001`.

The honest possible outcome — AISP's value is marginal for machine-rendered records and real only as context compression — is exactly worth knowing **before** thread D invites contributors to learn a bespoke notation. If the benchmark says JSON does the job, that's a finding, not a failure; the validator and the gates, not the glyphs, were always the load-bearing part.

## Non-goals (unchanged)

Still not open conjectures — the swarm formalises existing proofs, it does not discover research-frontier mathematics. Still upstream of welfare — an enabling public good, not a direct one.

## A reasonable first move

**Thread A, then B.** Close the decomposition demonstration (it is nearly there and it is the load-bearing claim), then point the swarm at one real target *result* and watch the dependency tree compound. C (upstreaming) is the highest-leverage for *impact* but needs the most human-norm judgement; D/E/F are what make it a service rather than a demo. Each thread is an ADR + spec + a measured run, in the same idiom as Phases 0–2.
