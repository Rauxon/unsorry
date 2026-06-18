# Study: Peer / Distributed Proof Verification

Status: **Study / exploration** (not a decision). Author: maintainers. Date: 2026-06-18.

Question studied: *can users (peers) validate each other's proofs — a distributed proof-verification system — not just compute proofs centrally?*

This is a study, not an ADR. It maps the design space against what unsorry already
is, surfaces the one hard problem, and recommends a path. It does **not** propose
merging anything yet.

---

## 1. Motivation

Today every proof is verified by one trusted central pipeline (Gate A on
namespace.so runners). This whole week's operational pain — saturation, cancelled
Gate A jobs, the in-flight cap — is **central verifier capacity** being the binding
constraint. "Let peers verify each other's proofs" is, at root, a proposal to
**scale verification past one operator's runners**. So the real goal is *capacity*,
and any design must keep *soundness* at least as strong as today.

## 2. The property everything hinges on: Lean verification is deterministic and reproducible

The trust anchor is the **Lean kernel re-checking proof terms** (`leanchecker`),
plus the axiom audit (whitelist `propext, Classical.choice, Quot.sound`; no
`sorry`/`admit`/`native_decide`) and the ADR-011 statement binding. Given:

- the pinned `lean-toolchain` (e.g. `leanprover/lean4:v4.30.0`),
- the pinned mathlib (`lakefile.toml` rev + committed `lake-manifest.json`, ADR-002),
- the proof source (`library/Unsorry/X.lean`, git-blob identity),
- the **canonical** goal statement (`goals/<id>.lean`, create-only/immutable, ADR-018),

the kernel **ACCEPT/REJECT verdict is deterministic and reproducible on any
machine**. (Olean *bytes* are not reproducible; the *verdict* is — `leanchecker`
re-checks regardless of olean origin.)

**Consequence:** a peer's verdict does not have to be *trusted* — it can be
*re-derived*. Anyone (another peer, the central tier, an auditor) can re-run the
same inputs and must get the same answer. Disagreement is therefore *detectable*.
This is the single most important fact for the design, and it is what makes a
sound distributed scheme possible at all.

## 3. What "peers verify each other" can and cannot mean here

A naive reading is "N users vote; majority wins." For Lean this is **the wrong
model, and the repo already rejected it** (ADR-049, Option 6; ADR-052 tiers):

- Lean is a **VERIFIED** domain — one valid kernel result *is* ground truth. A
  vote among non-cryptographic identities (ADR-007) is a *defeatable poll*, not a
  proof. N-of-M consensus is reserved (ADR-052 CONSENSUS tier) for domains with
  **no cheap deterministic verifier** (e.g. labelling, scoring). Using it for Lean
  adds 200–300% compute and admits *no new signal*.
- Worse, a vote is **Sybil-gameable**: agent IDs are self-asserted (ADR-007), so
  one actor can run M "independent" verifiers and outvote the truth.

So the sound framing is **not** consensus. It is:

> **Reproducible independent re-verification, where a peer's verdict is accepted
> because it is *checkable*, not because the peer is *trusted* — backed by random
> audit and Sybil-resistant reputation so that lying is detectable and irrational.**

This is "optimistic verification" (cf. optimistic rollups, BOINC/SETI redundancy):
trust by default, verify a sample, penalise provable lies.

## 4. The one hard problem

Reproducibility makes lies *detectable after the fact*. But at the moment of
acceptance, the system faces the **"did you actually run the kernel?"** problem:
there is no cheap cryptographic proof that a peer ran `leanchecker` rather than
just signing `accepted=true`. You cannot make producing a verdict expensive-to-fake
the way you can with proof-of-work.

The only sound answers are:

1. **Reproducibility** — any verdict can be re-checked; a lie is caught the moment
   anyone re-runs (and the scheduled full re-replay, ADR-048, guarantees someone
   eventually does).
2. **Random audit** — the trusted tier re-runs a sampled fraction *f* of peer
   verdicts. A peer that lies on fraction *p* of its work is caught with
   probability ~`1-(1-f)^(p·n)` over *n* verdicts → caught fast unless *p* is tiny.
3. **Redundancy with independence** — K independent peers verify the same artifact;
   because the function is deterministic, honest peers *always* agree, so any
   disagreement flags a liar/broken-env. But "independence" must be real (Sybil
   resistance), or K colluding identities just agree on a lie.
4. **Reputation / stake + slashing** — a caught lie slashes the peer's standing
   (loss of accumulated reputation/access), making lying net-negative.

These compose. None alone is sufficient; together they make a peer verdict
*economically and probabilistically* as good as a central one — while *never*
weakening the absolute backstop (the kernel re-check that anyone can perform).

## 5. The soundness invariant a peer verifier MUST honour

From ADR-049 / ADR-011 (the load-bearing rules a distributed verifier cannot relax):

- The verifier MUST re-derive the statement from the **canonical goal source**
  (`goals/<id>.lean`) and bind the proof to it (ADR-011). It must **never** trust a
  contributor-supplied statement or a contributor-supplied `.olean` — both admit
  the *vacuity class* (a real proof of a *weakened/renamed* statement, PR #64) and
  crafted-invalid oleans.
- The verifier MUST run on the **pinned** toolchain + mathlib and record their
  hashes in the verdict — a verdict is only valid under the artifact's pinned
  context.
- The verifier runs the full sound check: build + statement binding + axiom audit +
  `leanchecker`. (This is exactly what Gate A does; a peer is "Gate A on someone
  else's machine".)

So a "peer verification" is precisely **ADR-049's decentralised runner, run by a
volunteer, plus an integrity layer (audit + reputation) that lets its verdict
count without being blindly trusted.**

## 6. Design options

| Option | What | Capacity win | Soundness | Verdict |
|---|---|---|---|---|
| **A. Advisory peer pre-check + central gate** | Peers verify to filter/cache; the central kernel still gates every merge | None (central still gates) | Absolute (status quo) | Safe, but doesn't solve the bottleneck |
| **B. Optimistic audited re-verification** | Peers run the full check, sign a verdict; accept on a sufficiently-trusted verdict; central **spot-audits a random sample**; slash provable lies | **High** — most proofs never touch central | Absolute-by-reproducibility + probabilistic-by-audit | **Recommended core** |
| **C. K-independent agreement** | K independent peers verify the same artifact; accept on unanimous (deterministic) agreement; any disagreement → escalate to central | Medium (K× cost) | Strong detection, needs real independence | Good complement to B for high-risk items |
| **D. BFT / N-of-M consensus** | Quorum vote decides acceptance | High | **Unsound for Lean** (gameable poll, ADR-049) | Rejected |

## 7. Recommended architecture (synthesis of B + C, on existing primitives)

A layered **"trust-by-reproducibility, capacity-by-audit"** model:

1. **Immutable, content-addressed work unit** (ADR-018/048): goal source + proof
   source + pinned toolchain hash + mathlib manifest hash. This *is* "the exact
   artifact" a verdict refers to.
2. **Peer verifier = decentralised runner** (ADR-049): pulls the work unit, runs
   the full sound check (§5), emits a **signed VerificationEvidence** record
   (ADR-052 schema, *extended* with: verifier identity, verifier public key /
   signature, toolchain+mathlib hashes, artifact hash, verdict, logs link).
3. **Coordination via a `verdicts/` branch** (reuse ADR-003 AISP + ADR-004
   first-push-wins): peers publish verdict records the way agents publish claims —
   git-native, no central service.
4. **Acceptance policy by verifier trust tier** (ADR-054):
   - `trusted`-tier verifier's signed verdict → admits (subject to audit).
   - `trial`-tier verdict → requires **corroboration**: a second *independent*
     verdict (Option C) or a central audit, before merge.
   - Tiers are *earned* from a history of audited-correct verdicts.
5. **Random audit + slashing** (new mechanism): the trusted/central tier re-runs a
   random sample of peer verdicts. Because the check is deterministic, an honest
   verdict *always* matches; a mismatch → slash the verifier's reputation/tier,
   re-verify the artifact, and alert. Audit rate *f* is the tunable soundness/cost
   dial.
6. **Sybil resistance** (ADR-054, the hard prerequisite): identities bound to an
   accountable owner; reputation *derived* from merged `⟦Π:Provenance⟧` (ADR-023);
   only *independent* identities count toward corroboration/quorum. Without this,
   Options B/C collapse (one owner = many "independent" verifiers).
7. **Backstops (unchanged)**: scheduled full re-replay (ADR-048) and an open
   **challenge** path — anyone may re-run any artifact and publish a counter-verdict;
   a valid challenge forces re-verification and fix-forward. The kernel remains the
   final authority; peers never *lower* the soundness bar, only *share the load*.

The net is: **soundness is still ultimately the kernel** (anyone can re-derive any
verdict; bad merges are detectable and reversible), while **capacity scales with the
number of audited volunteer verifiers** instead of one operator's runner pool.

## 8. Threat model

| Threat | Mitigation |
|---|---|
| **Lazy verifier** signs `accept` without running the kernel | Random audit (deterministic mismatch on a bad accept) + reproducibility + slashing |
| **Lying verifier** accepts an invalid proof | Same; plus corroboration for untrusted tiers |
| **Statement-weakening / vacuity** (real proof of a renamed/weaker goal) | Verifier MUST re-derive statement from canonical source + ADR-011 binding (never trust supplied statement) |
| **Crafted-invalid olean** | Verifier never ingests contributor oleans; rebuilds/`leanchecker` from source on pinned deps |
| **Sybil** (one owner, many "independent" verifiers) | ADR-054 owner binding + reputation + independence accounting; only independent identities corroborate |
| **Collusion** (K colluding verifiers agree on a lie) | Random central audit is owner-independent and unbeatable by collusion; audit rate sets the bound |
| **Reputation farming** (self-verify own proofs to climb tiers) | Verifier ≠ prover separation for reputation credit; audit; cross-owner corroboration |
| **Toolchain mismatch** (verdict under a different toolchain) | Pinned context hashes in the verdict; verdict invalid if context hash ≠ artifact's |
| **Grinding** (retry until a lie slips audit) | Slashing on first catch makes expected value negative; low audit-survival probability over many attempts |

## 9. What already exists vs. what must be built

**Reusable today:** kernel determinism + `leanchecker` (the anchor); ADR-048
immutable-artifact/provenance + verify-once; ADR-002 pinning; ADR-018
content-addressing; ADR-003/004 AISP + first-push-wins coordination; ADR-052
evidence schema (centralised form); ADR-049 decentralised-runner soundness rules.

**Must be built (mapped to ADRs):**
1. **Sybil-resistant identity + reputation** — ADR-054 (Proposed, unbuilt). *Hard
   prerequisite.* Without it, nothing here is safe.
2. **Signed verdicts** — extend ADR-052 evidence with verifier identity, context
   hashes, and a signature; key management (GitHub-account-bound or PAT-signed, or
   minimal PKI).
3. **Decentralised verifier worker** — ADR-049 (Accepted, Phase 1 not pursued):
   the volunteer "Gate A on your machine" honouring §5.
4. **Audit + challenge + slashing** — *new*: random re-verification sampler,
   counter-verdict/challenge handling, reputation penalties. This is the integrity
   core and the main novel work.
5. **`verdicts/` coordination branch** — small, reuses ADR-003/004.

## 10. Phased rollout

1. **Phase 0 — Advisory (Option A).** Peers run the full check and publish *signed
   verdicts* on `verdicts/`, but the central kernel still gates every merge. Zero
   soundness risk; builds the verdict schema, signing, and a corpus of
   peer-vs-central agreement data to *measure* honesty before trusting it.
2. **Phase 1 — Audited trusted-tier.** Promote verifiers to `trusted` from
   audited-correct history (ADR-054). A `trusted` verdict admits a proof *without*
   central re-check, with random audit rate *f*. Capacity starts scaling. Requires
   ADR-054 + audit/slashing.
3. **Phase 2 — Corroboration for trial tier (Option C).** New/low-rep verifiers'
   verdicts admit only with an independent second verdict; widens the verifier pool
   safely.
4. **Phase 3 — Tune.** Lower *f*, raise tiers, as measured honesty justifies; keep
   the scheduled full re-replay and challenge path as permanent backstops.

## 11. Honest assessment / recommendation

- **For soundness, peer *consensus* is unnecessary and was correctly rejected.** The
  kernel is ground truth; a vote can only weaken it. Do not build Option D.
- **For capacity (the actual problem), peer verification is viable** — but *only* as
  Option B/C: reproducible re-verification, audited, Sybil-gated. It is essentially
  **ADR-049 (decentralised runner) + ADR-054 (Sybil-resistant reputation) + a new
  audit/slashing layer + signed ADR-052 evidence.** That is a substantial,
  multi-ADR build, and it trades *absolute* soundness for *absolute-by-
  reproducibility + probabilistic-by-audit* (a defensible trade, since the kernel
  backstop and challenge path keep any error detectable and reversible).
- **Cheaper near-term alternative worth weighing first:** the central verifier is
  already sharded and embarrassingly parallel (ADR-063). Much of the desired
  capacity win is obtainable by running *that* across more (even volunteer)
  machines with **spot-audit** — i.e. Option A→B *without* full peer autonomy. If
  the goal is purely throughput, "audited decentralised runners" may deliver most
  of the benefit at a fraction of the trust-machinery cost.
- **Prerequisite gate:** none of B/C is safe until **ADR-054 (identity / Sybil /
  reputation)** is built. That should be the first concrete step regardless of how
  far toward peer verification we go.

## 12. Open questions

- Signing/key management: GitHub-account attestation vs. a minimal verifier PKI?
- How is verifier *independence* actually established (owner binding is necessary;
  is it sufficient)?
- Audit rate *f*: what soundness target, and who pays for the audit compute?
- Governance of slashing (false-positive audits from a verifier's broken env vs.
  genuine lies — needs an appeal/repro path).
- Reproducibility edge cases (toolchain bugs, platform-specific kernel behaviour)
  that could make an honest verdict differ — how rare, how detected.
