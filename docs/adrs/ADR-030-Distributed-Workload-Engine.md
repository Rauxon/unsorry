# ADR-030: Domain-Agnostic Distributed-Workload Engine (Plugin Seam)

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-030 |
| **Initiative** | platform generalization / reusable template |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Proposed |

## WH(Y) Decision Statement
**In the context of** unsorry being a working distributed swarm that discharges Lean `sorry`s into kernel-verified proofs through autonomous agents, a coordination layer (claims branch, ADR-004), soundness/hygiene gates (Gate A/B), provenance and a leaderboard (ADR-023), cross-cycle lesson memory (ADR-024), decomposition (ADR-009), and autonomous merge-on-green (ADR-005) — and a stated intent to reuse it as a template for crowdsourced problem-solving ("SETI@home for verifiable work") across domains beyond Lean,

**facing** the fact that most of the engine is already domain-agnostic, but three things are hardwired to Lean — the verifier (Gate A internals: `lake build --wfail`, `axiom_audit`, `leanchecker`, statement-binding), the candidate generator (proof prompts), and work-unit handling (`.lean`/`camel-name`, the goal record schema) — so a new domain cannot be onboarded without forking the swarm; and facing that the property which actually distinguishes this from SETI@home — **results are self-verifying by a deterministic checker, so one valid result is ground truth and redundant computation is unnecessary for trust** — is currently entangled with Lean specifics rather than expressed as a reusable contract,

**we decided for** defining a narrow **domain-plugin seam** behind which all domain-specific logic lives (`workunit` schema; `generate`; `verify → Verdict`; optional `decompose`; `assimilate`), keeping the swarm loop, provider abstraction, claims/lease coordination, provenance, lesson memory, gates-as-CI, and merge **domain-agnostic**, with **Lean as the first plugin** that re-expresses today's behaviour through the seam; and for adopting an explicit **verifiability spectrum** — `VERIFIED` (deterministic checker, one valid result suffices — Lean's tier), `SCORED` (verifier returns a score, keep-best), `CONSENSUS` (no cheap verifier, N independent results with quorum + reputation, the classic SETI/BOINC model) — so domains without a kernel-grade checker degrade gracefully instead of being excluded,

**and neglected** extracting the engine into a separate package/repo now (premature — the seam is a hypothesis until a second plugin exercises it; prove it in-repo first), replacing the claims branch with a central coordination service (deferred until git-as-database measurably breaks under contention — ADR-004 stands until then), folding deduplication, identity/anti-abuse, and contributor onboarding into this decision (each is an independent decision with its own ADR — see References), and weakening the Lean plugin's trust model (the kernel gate remains authoritative and unchanged; generalization must not lower the soundness bar),

**to achieve** a reusable distributed-workload template where onboarding a new problem domain means implementing one plugin against a documented contract — not forking the swarm — while preserving unsorry's core advantage that verified results need no redundancy,

**accepting that** the seam is provisional until a second, non-Lean plugin validates the boundary (and may need revision then); that the `VERIFIED` tier is the deliberate design centre while `SCORED`/`CONSENSUS` are secondary and less mature; that some currently-implicit engine/Lean coupling will surface as friction during extraction; and that scale (coordination service), correctness-of-credit (anti-abuse), wasted-work (dedup), and growth (onboarding) remain separate, explicitly-tracked decisions rather than guarantees of this ADR; and that further considerations which are not yet scoped — notably the **plugin trust boundary** (a third-party plugin's `verify` could lie and must not be trusted blindly), `verify` **reproducibility/pinning**, the **compute cost model**, central **CI cost/DoS**, **work-unit ingestion**, **corpus governance/licensing**, and **unit privacy** — are recorded in SPEC-030-A §7.2 so they are not lost.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Distributed-workload engine specification (the plugin seam) | Specification | specs/SPEC-030-A-Distributed-Workload-Engine.md |
| REF-2 | Distributed research swarm plan | Proposal | ../proposals/distributed-research-swarm-plan.md |
| REF-3 | Work-unit deduplication & coordination | Decision (follow-up) | GitHub issue (to be filed) |
| REF-4 | Claims branch coordination | Decision | ADR-004-Claims-Branch.md |
| REF-5 | Autonomous merge on green gates | Decision | ADR-005-Autonomous-Merge.md |
| REF-6 | Proof provenance and leaderboard | Decision | ADR-023-Proof-Provenance-Leaderboard.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-13 |
