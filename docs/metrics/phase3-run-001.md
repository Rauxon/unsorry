# Phase-3 run 001 — the chain, in anger (Platonic Schläfli core)

**run_id:** `phase3-run-001` · **date:** 2026-06-11/12 (UTC) · **trial:** thread A — force decompose → prove-subs → recompose to carry a real proof end-to-end.

Machine record: [`phase3-run-001.json`](phase3-run-001.json).

## Exit-metric verdict (read this first)

**The exit metric is: did the decompose → prove-subs → recompose chain carry a real proof end-to-end?**

**MET.** `platonic-schlafli-core` — the Schläfli arithmetic core of the Platonic-solids classification, mathlib-absent — is kernel-verified on `main` (#211, gate-a green, binding obligation regenerated and satisfied). The proof file imports `Unsorry.PlatonicSchlafliCoreS2/S3/S4` and **is literally the composition of its sub-lemmas**:

```lean
theorem platonic_schlafli_pairs (p q : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (h : (p : ℚ)⁻¹ + (q : ℚ)⁻¹ > 2⁻¹) :
    (p, q) ∈ ({(3,3),(3,4),(4,3),(3,5),(5,3)} : Finset (ℕ × ℕ)) :=
  platonic_schlafli_pairs_of_bounds p q hp hq
    (platonic_schlafli_fst_lt_six p q hp hq h)
    (platonic_schlafli_snd_lt_six p q hp hq h) h
```

Three interior nodes recomposed the same way first (s1-s1 → #197, s2 → #202, s1 → #207), so the chain was exercised at every level of a depth-3 tree, not just at the root.

**Honesty about the forcing:** the parent was *made* to decompose with a strangled stage-1 budget (`UNSORRY_ATTEMPTS=1`, `UNSORRY_WALL=420`). A frontier model at full budget might have one-shot this statement. What this run tested — and what is now demonstrated — is the *chain*: budget exhaustion → machine-proposed sub-lemmas through Gate B → bottom-up proving → unblock sweeps → recompose through Gate A, three levels deep, 13 goals, 4 recompositions.

## The tree

```
platonic-schlafli-core                       #149 decompose (4 subs) → #209 unblock → #211 PROVED
├── s1  (p<6 bound chain)                    #152 decompose (3 subs) → #203 unblock → #207 PROVED
│   ├── s1-s1 (cast monotonicity)            #167 decompose (2 subs) → #193 unblock → #197 PROVED @xhigh
│   │   ├── s1-s1-s1 nat_cast_le_rat_of_le   #184 PROVED @high
│   │   └── s1-s1-s2 nat_cast_six_eq_rat_six #186 PROVED @high
│   ├── s1-s2 rat_inv_le_inv_six_of_six_le   #166 PROVED @xhigh (see incidents)
│   └── s1-s3 nat_six_le_of_not_lt_six       #187 PROVED @high
├── s2  platonic_schlafli_fst_lt_six         #155 decompose (3 subs) → #200 unblock → #202 PROVED @high
│   ├── s2-s1 nat_inv_le_third_of_three_le   #191 PROVED @high
│   ├── s2-s2 rat_gt_sixth_of_add_gt_half    #195 PROVED @high
│   └── s2-s3 nat_lt_six_of_sixth_lt_inv     #194 PROVED @high
├── s3  platonic_schlafli_snd_lt_six         #201 PROVED @high
└── s4  platonic_schlafli_pairs_of_bounds    #208 PROVED @high  (the braced Finset literal)
```

13/13 proved · 4 decompositions · 4 recompositions · depth 3 · binding held everywhere · 0 soundness incidents.

## The effort ladder, measured (ADR-015)

11 of 13 final proofs closed at the **cheapest rung** (`high`, typically 3–8 minutes claim→PR); 2 needed `xhigh`; the only `max` spends were on the genuinely-stuck pre-decomposition passes. The ladder did exactly what it was designed to do: pay for deep reasoning only where a cheaper pass failed — and it cut quota burn proportionally, which mattered (below).

## Incidents — and the machinery they produced

This run ate three CLI quota outages and surfaced two coordination bugs. Each incident either validated existing guards or produced a new one, all shipped in [v1.3.0](https://github.com/agenticsnz/unsorry/releases/tag/v1.3.0):

1. **Outage 1 (05:48Z)** — every claude call died in ~1 min; the loop, unable to tell "model tried and failed" from "model never ran", demoted all 8 leaves below τ_v (#156–#163) and starved itself. Manual restore #165.
2. **Outage 2 (10:43Z)** — same, 9 more spurious demotes (#168–#181). Manual restore #183 — and **ADR-016**: fast-dead call + failed health probe = infrastructure failure, zero queue writes, exit 3.
3. **#166's silent stall** — a spurious demote raced the open prove PR for the same goal record; the PR went CONFLICTING, and GitHub runs **no checks** on a conflicted PR, so its armed auto-merge waited 8 hours in silence. (Also: gate-a's text lint rejected the word "axiom" in a *doc comment* — kernel checks were green; reworded.) Produced **ADR-017**: claim guard + supervisor + CONFLICTING flag.
4. **Claim races (19:00Z)** — pre-ADR-017 loops double-claimed past `PROVE_CLAIM_CAP=1`; 6 duplicate prove PRs, all closed, identical content where compared (the gates are idempotent — soundness was never at risk; the cost was redundant runs). Root-cause interleave still unreproduced — known issue.
5. **Outage 3 (19:45Z) — the validation.** First outage under the new guards: alpha's call died in 137s, probe failed, claim released, **zero penalties**, exit 3; both supervisors rode ~3.5 h of outage with 1h-capped exponential backoff and resumed unattended. Queue repair PRs required: **none.**
6. **Claim-guard false positive (23:4xZ)** — GitHub search tokenizes punctuation, so leftover duplicate #198 (`…-s2-s2`) matched the *parent's* guard query and both agents skipped the recompose-ready root. The supervisor's CONFLICTING flag surfaced it; exact-prefix matching shipped (#210).

Wall clock start→finish was ~24 h, of which ~12 h was quota outage and ~3.5 h was actual healthy-quota proving for the entire tree.

## What this run proves, and what it doesn't

- **Proved:** the architecture's central claim — a goal too big for one attempt becomes a tree, the tree becomes lemmas, the lemmas recompose into the goal, with the kernel as the only authority at every step. Also: an unattended swarm now survives its operational environment (outages, races, silent CI stalls) without corrupting queue state.
- **Not proved:** that decomposition beats one-shotting *for this statement* (the forcing was artificial), and nothing about the difficulty ceiling — these sub-lemmas were elementary. The next escalation is a target that resists a full-budget frontier model on its own merits.
- A bonus datapoint for the open-swarm thread: a second contributor machine (`mac-158f`) proved `alternating-sum-naturals` (#204) mid-run, through the same gates, with no coordination beyond the claims branch.
