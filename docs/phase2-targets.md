# Phase 2 Targets — Candidate Shortlist

**Status:** Research / proposal · **Date:** 2026-06-10 · **Author:** swarm research subagent
**For:** unsorry Phase 2 ("open lemmas and target theorems" — distributed-research-swarm-plan.md §Phasing)

> Phase 2 = point the swarm at **one chosen result that is not already in mathlib** and drive a
> kernel-verified proof to it **by decomposition**, with affinity-weighted selection on. This doc is
> the honest, researched shortlist. **Target selection is a human curation call** (see §4) — the
> swarm cannot pick its own mission, and several "obvious" candidates turned out to already be in
> mathlib, so every absence claim below carries an explicit confidence and a "verify before
> claiming" caveat.

---

## 0. Grounding: what the swarm has actually demonstrated

This sets the *difficulty band*. From `phase1-run-001.md` and the seeded backlog, the Phase-1 prove cycle has closed only **trivial facts that mathlib already proves**, where the "proof" is a one-line delegation:

- `int_neg_neg_thm (n : Int) : -(-n) = n := Int.neg_neg n` (PR #74)
- `int-add-neg` (#72), `and-comm-imp` (#70) — same shape.
- Merge rate **0.6** (3/5), and the two misses were **infrastructure** (cold mathlib olean cache → build timeout), not hard mathematics.

Three structural facts from the specs constrain Phase 2:

1. **Decomposition is not built yet.** SPEC-007-A step 11: a Phase-1 prove failure is *"just release + flag"*; the `decompositions/` path (split a parent into sub-lemmas with `Post(A)⊆Pre(B)` edges, per SPEC-003-C) is **explicitly Phase 2 work**. A good first target must therefore *force* that machinery to be exercised — i.e. it must genuinely not close in one shot.
2. **Affinity selection is specced but not wired.** Protocol `⟦Γ:Affinity⟧` (+1 merge / −10 fail, `τ_v = −5`, gap = `|deps(g) ∖ proved|`) exists in `protocol.aisp`; SPEC-007-A selection is still **lexicographic**. A target whose sub-lemmas have a clear dependency DAG gives affinity/gap-selection something real to chew on.
3. **The statement-binding gap is open.** `gate-a-redteam-001.md`: Gate A gates *soundness* but **no layer binds a library theorem's statement to its canonical goal** (the autoImplicit-vacuity survivor, PR #64). So a Phase-2 target's **statement must be hard to vacuously satisfy** — pick definitional content (a stated equality/area formula), not an easily-vacuous `∀`.

**Implication for the band:** the right Phase-2 target is *one step up* from "mathlib one-liner" — a result whose **statement** uses only objects mathlib already has, but whose **proof** does not exist in mathlib and naturally splits into 2–4 lemmas a frontier model can write tactic-by-tactic.

---

## 1. Selection criteria (the checklist)

A candidate must pass **all four**:

- [ ] **(a) Genuinely known/proved in the literature.** Not a conjecture, not original research. There is a textbook/paper proof to follow.
- [ ] **(b) Reachable by decomposition from current mathlib + a frontier model writing tactic proofs.** Not P≠NP, not a research frontier. **Statement objects must already live in mathlib** (so the goal can even be *stated* without first formalizing new definitions — itself a large, different project).
- [ ] **(c) Decomposes into 2–4 sub-lemmas** with a real dependency structure (`Post(A) ⊆ Pre(B)`), so it exercises the Phase-2 decomposition record and gap-based selection rather than collapsing to a one-liner.
- [ ] **(d) Worth the compute** — a *named* or otherwise citable result, ideally moving a tracked list (Freek's 100, the 1000+ list, or `undergrad_todo`).

Plus a hard gate from §0(3): **the statement must resist vacuous/mis-stated satisfaction** (definitional content, concrete equality, not a trivially-true `∀`).

**Sources for "what mathlib lacks" (consulted):**
mathlib `undergrad_todo` · 100 theorems in Lean and 100-missing · 1000+ theorems in Lean · Freek Wiedijk, Formalizing 100 Theorems · combinatorics-gap evidence: CombiBench, LeanComb / PutnamBench.

**"Verify before claiming" is not boilerplate here.** During this research I found several intuitively-missing results are **already in mathlib**, and dropped them:

- **Bertrand's postulate** — IN mathlib, `Mathlib.NumberTheory.Bertrand` (Erdős "Proofs from THE BOOK" proof). Dropped.
- **Frobenius / Chicken-McNugget number** (`mn − m − n`) — IN mathlib, `Mathlib.NumberTheory.FrobeniusNumber`. Dropped.
- **Stirling's formula** — IN mathlib (`tendsto_stirlingSeq_sqrt_pi`, on the 1000+ list). Dropped.
- **Fermat sum-of-two-squares** — IN mathlib, `Mathlib.NumberTheory.SumTwoSquares`. Dropped.
- **Pick's theorem** — *was* a strong candidate, but arXiv 2603.23095 "Formalizing Pick's Theorem, efficiently" (Mar 2026) formalizes it **in Lean**. mathlib-upstreaming status unconfirmed, but it can no longer be claimed absent. **Confidence downgraded to unverified — do not pick without checking current mathlib HEAD.**

---

## 2. Candidate table

Confidence legend: **high** = checked a specific mathlib module / tracked-list entry and found the *named result* absent; **medium** = absent from tracked lists + no formalization found, but I did not grep mathlib HEAD for an equivalent lemma; **unverified** = plausibly absent but with a live reason to double-check.

| # | Candidate | What it is | Why it fits the band | Decomposition sketch (2–4 sub-lemmas) | Absence confidence | Difficulty (Fin 6) |
|---|---|---|---|---|---|---|
| 1 | **Faulhaber low cases: Σk² and Σk³** | `∑_{k=1}^{n} k² = n(n+1)(2n+1)/6` and `∑ k³ = (n(n+1)/2)²`. | Statement objects all in mathlib (`Finset.sum`, `Finset.range`); mathlib has Gauss-sum `Finset.sum_range_id` for Σk but the **quadratic/cubic closed forms are not standard named lemmas** (verify HEAD). Pure induction → ideal first decomposition. | L1: `∑k = n(n+1)/2` (likely *present* — `Finset.sum_range_id_mul_two` — a `Post⊆Pre` dependency on an existing lemma). L2: `∑k²` by induction. L3: `∑k³ = (∑k)²` by induction reusing L1. | **medium** (Σk present; closed forms for k²,k³ not found as named lemmas — grep before claiming) | 1–2 |
| 2 | **Nicomachus identity alone** (`∑ k³ = (∑ k)²`) | The sum of the first n cubes equals the square of the sum. | Self-contained, classic, statement = mathlib `Finset` objects only; the "square of a sum" RHS resists vacuity (concrete equality, §0(3) gate). | L1: `∑_{range n} k = n(n+1)/2` (depends on existing mathlib lemma). L2: induction step `(S+(n+1))²−S² = (n+1)³` reduced to L1. L3: assemble. | **medium** (not on 100/1000 lists; verify no `Finset.sum_range_cube` exists) | 1 |
| 3 | **Sophie Germain identity** | `a⁴ + 4b⁴ = (a²+2ab+2b²)(a²−2ab+2b²)` over a commutative ring. | Single ring identity; statement uses only `CommRing` + `^`; mathlib has sum-of-two-squares number theory but **not this named factorization** (verify). | L1: the raw identity (`ring` may one-shot it — if so it fails (c)). L2 (real target): compositeness corollary `n>1 ⇒ n⁴+4 composite` — needs L1 + a primality argument, genuinely decomposes. | **medium** (identity trivial; corollary is the citable bit — confirm absence) | 1 (identity) / 3 (corollary) |
| 4 | **Liouville transcendence** *(corollary band)* | Liouville's approximation theorem ⇒ transcendence of Liouville's constant. | **Caveat: mathlib already has `Liouville` and `transcendental_liouville_number`** in `Mathlib.NumberTheory.Liouville.*` — headline taken. Listed only as a source of sub-lemmas if a specific bound is missing. | (only if a gap is found) — not recommended without a confirmed missing sub-lemma. | **unverified → likely PRESENT** | n/a |
| 5 | **Unsolved PutnamBench item** | A specific combinatorics/number-theory Putnam problem whose Lean *statement* exists in PutnamBench but is **unsolved by current provers**. | Statement pre-written on mathlib objects; difficulty calibrated & known-hard-but-elementary; an unsolved one is a legible "swarm closed an open benchmark item" win. | Problem-specific; PutnamBench problems are chosen to need 2–5 lemmas. Decomposition is the whole game. | **high** (benchmark tracks unsolved-in-Lean status) | 2–4 (pick the band) |
| 6 | **Combinatorial identity from LeanComb / CombiBench** | A binomial-sum / combinatorial identity from the gap set. | Combinatorics is mathlib's **thinnest** area (CombiBench: "the gap between informal and formal is larger here"). Statements use `Nat.choose`, `Finset.sum` — all present. | (L1) a `Nat.choose` recurrence, (L2) induction on the sum, (L3) algebraic close. Pascal-rule decompositions are natural. | **high** (these benchmarks exist *because* the results aren't in mathlib) | 2–3 |
| 7 | **Erdős–Szekeres corollary** | Monotone-subsequence theorem. | **Caveat: core theorem is IN mathlib** (Theorems100 / Pigeonhole). Only a named corollary/generalization not in mathlib would qualify. | Not recommended as a headline; higher-dimensional variant is research-band. | **unverified → core PRESENT** | n/a |
| 8 | **AISP dogfooding — one mechanizable claim** | One of the AISP project's 15 published claims (bar181/aisp-open-core): beam-search termination, density monotonicity, content-addressing tamper-evidence, adjunction laws. | The design doc's own suggested stretch. Self-contained, dual-benefit. **But see §3** — these are **paper/natural-deduction claims with no Lean statement**, so the *statement* must be authored from scratch (translate work, not just prove). | Termination: L1 measure decreases per step; L2 measure bounded below; L3 ⇒ termination via well-founded recursion. (Algorithmic, not mathlib-classical.) | **high** (confirmed *not* mechanized anywhere) | 2–4, **plus statement-authoring cost** |

---

## 3. Honest assessment of the AISP dogfooding stretch (candidate #8)

The design doc explicitly offers this as the Phase-1→2 stretch. My honest read after checking the source:

**For it:** it is the doc's *own* recommendation (dual-project value); the claims are self-contained and algorithmic (termination, monotonicity, tamper-evidence) — the right "decomposes into sub-lemmas" shape; a win is uniquely legible ("the swarm verified its own coordination format").

**Against it / caveats the doc undersells:**
1. **No Lean statement exists.** bar181/aisp-open-core states the 15 claims in natural deduction + category theory with **empirical "evidence" folders, not mechanized proofs**. So this is *first* an autoformalisation task (author the statement, run the dual-translation fidelity gate) and *only then* a prove task — larger scope than "prove an existing goal."
2. **Statement-fidelity risk is maximal.** These are bespoke definitions (what *is* "density," "tamper-evidence," "the adjunction" formally?). The §0(3) binding gap bites hardest: it is very easy to formalize a *vacuously-true* "content-addressing is tamper-evident." This is exactly the unfixed red-team gap (PR #64); a mis-stated AISP theorem would pass Gate A and look like a triumph.
3. **Not classical in the §1(a) sense.** One project's claims, not textbook theorems with independent proofs to cross-check.

**Verdict:** keep it as a *flagship demonstration* for later in Phase 2 — but **not the first target**. It co-loads the two least-built parts (statement authoring + statement-binding fidelity). Do it *after* decomposition is proven on a classical, unambiguous target.

---

## 4. Recommended first Phase-2 target

**Recommendation: Candidate #2, the Nicomachus identity `∑_{k=0}^{n} k³ = (∑_{k=0}^{n} k)²`, as the decomposition shakedown — with Candidate #6 (a LeanComb/CombiBench combinatorial identity) as the "real contribution" follow-on once the decomposition path is proven.**

Reasoning, against the criteria and §0 constraints:

1. **It forces decomposition without forcing anything else.** The point of a first Phase-2 target is to exercise the **unbuilt** decomposition machinery (SPEC-007-A step 11 → Phase 2) and the **unwired** affinity/gap selection — not to also stress autoformalisation or new definitions. Nicomachus:
   - **Statement is unambiguous and definitional** (a concrete equality over `Finset.sum` objects mathlib already has) → sidesteps the unfixed statement-binding gap (§0(3)); there is no vacuous reading of `∑k³ = (∑k)²`.
   - **Genuinely needs ≥2 lemmas** (depends on `∑k = n(n+1)/2`, then an induction step consuming it) → produces a real `Post(L1) ⊆ Pre(L2)` edge and a `decompositions/` record — the artifact Phase 2 must produce.
   - **Has a real dependency on an *existing* merged lemma** (`Finset.sum_range_id_mul_two` or similar) → gap-based selection (`gap = |deps ∖ proved|`) has something to compute, and affinity has a pattern to reward.

2. **It is cheap, true, and legible.** Classic named identity (d), provable by a frontier model in tactic mode against mathlib (b), known-true with a one-paragraph textbook proof (a). If the swarm *can't* close it after decomposition, that is a clean signal about the machinery, not the math.

3. **It de-risks before expensive targets.** Once #2 demonstrates decomp-record-committed → sub-goals re-queued → sub-goals proved (possibly by different agents) → parent closed by composition → merged, *then* point the swarm at #6/#5 for a contribution that actually moves a tracked gap (combinatorics being mathlib's thinnest area).

**Why not AISP first:** §3 — co-loads statement-authoring + the unfixed fidelity/binding gap.
**Why not Faulhaber-general / transcendence:** too definition-heavy (Bernoulli machinery) or already in mathlib (Liouville) for a *first* decomposition.

**Pre-flight checks before committing #2 (do not skip):**
- `grep`/search mathlib HEAD for an existing `Finset.sum_range` cube/square closed-form lemma. If `∑k³=(∑k)²` is *already* named, the prove step one-lines it and you've tested nothing — fall straight through to #6.
- Confirm the depended-on `∑k` lemma's exact mathlib name so the decomposition's `deps` edge points at a real importable lemma.

---

## 5. This is the human judgment call

Target selection is **curation, not computation.** The swarm decomposes, claims, proves, and verifies autonomously — but it **cannot pick its own mission**:

- **The kernel guarantees soundness, never relevance.** Gate A (ADR-006) will merge a vacuously-true or mis-stated theorem under a plausible name (red-team PR #64). "It compiled" ≠ "it was worth proving" ≠ "it says what we meant." Choosing a target whose *statement* is unambiguous is a human safeguard against the one gap the kernel does not cover.
- **Affinity (+1/−10) optimizes *within* a chosen mission, not the choice of mission.** It has no notion of mathematical value; point it at the wrong hill and it climbs the wrong hill efficiently.
- **Every absence claim here is a snapshot.** mathlib moves weekly; Pick's theorem went from "great candidate" to "verify HEAD" inside this research session (arXiv Mar 2026). Whoever commits a target **must re-verify absence at commit time** by grepping current mathlib, not by trusting this table. Confidence labels are honest as of 2026-06-10 and no stronger.
- **The benefit framing is the maintainer's to own.** Per the design doc, formal maths is an *enabling* public good, not direct welfare. Which absent theorem is "worth the compute" is a values call no metric in the system encodes.

The swarm's job is to *prove*. Choosing *what* is, and should remain, a person's signature on the goal record.

---

### Appendix: one-line disposition of everything checked

| Checked | Disposition |
|---|---|
| Bertrand's postulate | IN mathlib (`NumberTheory.Bertrand`) — dropped |
| Frobenius / Chicken-McNugget | IN mathlib (`NumberTheory.FrobeniusNumber`) — dropped |
| Stirling's formula | IN mathlib (1000+ list) — dropped |
| Fermat sum-of-two-squares | IN mathlib (`NumberTheory.SumTwoSquares`) — dropped |
| Quadratic reciprocity, Wilson, Cayley-Hamilton, Ballot, Königsberg | IN mathlib (100-list) — dropped |
| Pick's theorem | Lean formalization exists (arXiv 2603.23095, Mar 2026) — **unverified, do not assume absent** |
| Erdős–Szekeres core | IN mathlib (Theorems100 / Pigeonhole) — only a novel variant would qualify |
| Liouville transcendence | IN mathlib (`NumberTheory.Liouville`) — headline taken |
| Σk², Σk³ closed forms / Nicomachus | **medium** absence — recommended first target (verify HEAD) |
| Sophie Germain identity + compositeness corollary | **medium** absence — viable |
| Combinatorial identity (LeanComb / CombiBench) | **high** absence (gap-benchmark by construction) — recommended follow-on |
| Unsolved PutnamBench item | **high** (benchmark tracks unsolved-in-Lean) — viable, calibratable difficulty |
| AISP 15 theorems | **high** absence (not mechanized anywhere) — flagship-later, not first (§3) |