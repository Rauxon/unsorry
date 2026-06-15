# ADR-052: Verification Tiers and Auditability Evidence for Autonomous Work

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-052 |
| **Initiative** | unsorry platform generalization / verifier policy and auditability |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Proposed |

## Context

ADR-030 introduced the domain-plugin seam and named three verification tiers:
`VERIFIED`, `SCORED`, and `CONSENSUS`. ADR-050 then defined the reusable
Autonomous Trunk Skeleton, and ADR-051 planned the experience layer needed for
contributors, operators, and agent fleets. Those decisions make unsorry
reusable, but they leave a critical policy question under-specified: **what
level of verification is enough to let autonomous work merge, and what evidence
must be retained so a project remains auditable?**

The answer differs by domain. Lean proofs have a deterministic checker: the
kernel and Gate A can decide correctness for the merged artifact, so one valid
result is enough. Other domains are weaker. A test suite may be deterministic
but incomplete. A benchmark can rank candidates without proving correctness. A
security scanner may produce findings rather than an accept/reject theorem. A
human approval gate can manage risk, but it is not a machine proof.

If the skeleton lets every adapter call itself "verified", autonomous merge
becomes unsafe. If it requires Lean-grade proof for every domain, the skeleton
cannot generalize. The system needs a verifier policy that states which tier a
domain is using, which merge behavior that tier permits, and which audit
evidence must be produced.

This is also where compliance support belongs natively. The repository and
workflows do not make the organization ISO/IEC 27001 compliant by themselves.
However, the system can produce structured evidence for an ISMS owner:
traceable changes, verifier outcomes, approval records, settings snapshots,
exceptions, and risk decisions.

## WH(Y) Decision Statement

**In the context of** a reusable autonomous trunk system where different
domains will have different verifier strength, and where operators need
audit-ready evidence without pretending that the repository itself is a
certified ISMS,

**facing** the risk that weak verifiers could be mislabeled as deterministic
truth or that audit evidence remains ad hoc across adapters,

**we decided for** making verification tier an explicit adapter policy and
merge-control input: every adapter must declare its tier, verifier command,
acceptance semantics, evidence artifacts, replay/reproduction requirements,
and allowed merge mode; `VERIFIED` domains may auto-merge after one accepted
deterministic result, `SCORED` domains may select and retain best candidates
under project policy, `CONSENSUS` domains require independent redundant
results or quorum, and `APPROVAL` domains require a human or organizational
gate before merge; all tiers must emit structured audit evidence, including
verifier result, provenance, toolchain/version context, risk exceptions, and
approval or consensus records where applicable,

**and neglected** treating all green CI as equivalent (rejected because a test
suite, benchmark, scanner, and theorem kernel have different trust meaning),
requiring Lean-style proof for every domain (rejected because it would block
useful non-proof workloads), and claiming standards compliance from evidence
generation alone (rejected because compliance belongs to an organization's
ISMS, scope, risk treatment, review, and audit process),

**to achieve** a skeleton that can safely generalize beyond Lean while keeping
merge decisions, verifier strength, and audit evidence explicit,

**accepting that** lower tiers need more friction and less automation than
Lean's deterministic path, that adapter authors must maintain their evidence
schemas as seriously as their verifier code, and that auditability creates
records useful for compliance without certifying the project by itself.

## Verification Tiers

| Tier | Meaning | Autonomous merge policy |
|------|---------|-------------------------|
| `VERIFIED` | Deterministic checker decides whether the artifact satisfies the work unit. | One accepted result may auto-merge after required gates. |
| `SCORED` | Verifier ranks candidates or measures quality, but does not prove truth. | Auto-merge only if project policy defines thresholds and rollback; otherwise require approval. |
| `CONSENSUS` | No single cheap verifier is authoritative; trust comes from independent redundant results. | Merge only after quorum / N-over-M policy and central sanity checks. |
| `APPROVAL` | Human or organizational approval is the risk control. | No autonomous merge without recorded approval. |

`APPROVAL` is added explicitly rather than hidden inside `CONSENSUS` because
some domains are acceptable only through human risk acceptance, regulatory
sign-off, or maintainer judgment.

## Auditability Requirements

Every tier must produce evidence that can be preserved with the contribution:

- work-unit id and version,
- agent or contributor identity,
- verifier tier,
- verifier command or approval workflow,
- toolchain / dependency / model version context,
- result status and timestamps,
- artifact hashes,
- logs or summaries sufficient for later review,
- risk exceptions or accepted deviations,
- approval identity where humans are involved,
- consensus quorum details where redundant verification is used.

This evidence is not a compliance certificate. It is an auditable record that
an ISMS, security program, or project governance process can consume.

## Consequences

- **Positive.** New adapters cannot silently inherit Lean's auto-merge trust
  level. They must state their verifier strength and evidence obligations.
- **Positive.** Compliance support is built into the work lifecycle: evidence
  is generated at the same time as verification, not reconstructed later.
- **Positive.** Operators can compare domains honestly: deterministic proof,
  test-based confidence, scored optimization, redundant consensus, or human
  risk acceptance.
- **Negative.** Some useful domains will not be eligible for full autonomous
  merge. That is intentional; the tier tells the truth about the risk.
- **Negative.** Evidence schemas add maintenance overhead and must evolve when
  verifier behavior changes.

## Rollout

1. Add the tier policy to adapter documentation and generated status.
2. Define a shared verifier evidence schema in SPEC-052-A.
3. Mark the Lean adapter as `VERIFIED` and map current Gate A evidence into
   the schema.
4. Require future non-Lean pilots from ADR-050 to choose a tier before they can
   auto-merge.
5. Add evidence-pack hooks to ADR-051's experience layer.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Verification tier and auditability spec | Specification | specs/SPEC-052-A-Verification-Tiers-And-Auditability.md |
| REF-2 | Domain-agnostic distributed-workload engine | Decision | ADR-030-Distributed-Workload-Engine.md |
| REF-3 | Autonomous Trunk Skeleton | Decision | ADR-050-Autonomous-Trunk-Skeleton.md |
| REF-4 | Autonomous Trunk Experience Layer | Decision | ADR-051-Autonomous-Trunk-Experience-Layer.md |
| REF-5 | Gate A soundness enforcement | Decision | ADR-006-Gate-A-Soundness-Enforcement.md |
| REF-6 | Verify-on-ingest | Decision | ADR-048-Verify-On-Ingest.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
