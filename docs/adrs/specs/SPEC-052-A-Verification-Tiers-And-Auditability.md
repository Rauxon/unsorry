# SPEC-052-A: Verification Tiers and Auditability Evidence

Implements: [ADR-052](../ADR-052-Verification-Tiers-And-Auditability.md) | Status: Proposed | Updated: 2026-06-15

This spec defines the adapter verification tiers and the evidence records that
make autonomous work auditable. It extends ADR-030's plugin seam and ADR-050's
Autonomous Trunk Skeleton.

## 1. Purpose

Every adapter must answer two questions before its work can merge:

1. What does a successful verifier result mean?
2. What evidence is retained so that result can be reviewed later?

The tier decides merge policy. The evidence record supports traceability,
replay, incident review, and compliance programs.

## 2. Tier Declaration

Each adapter MUST publish a tier declaration:

```text
AdapterVerificationPolicy {
  adapter_id
  tier                    # VERIFIED | SCORED | CONSENSUS | APPROVAL
  verifier_name
  verifier_version
  verifier_command
  toolchain_context
  acceptance_semantics
  merge_policy
  evidence_schema_version
}
```

The declaration MUST be versioned. Changing tier or acceptance semantics is a
policy change and requires an ADR or an ADR update/supersession.

## 3. Tier Semantics

### 3.1 VERIFIED

Use when the verifier is deterministic and authoritative for the artifact being
merged.

Requirements:

- deterministic verifier,
- pinned or recorded toolchain context,
- reproducible central verification,
- fail-closed CI behavior,
- artifact hash recorded,
- verifier logs retained or summarized.

Merge policy:

- one accepted result may auto-merge if all required gates pass.

Example:

- Lean proof checked by Gate A and the Lean kernel.

### 3.2 SCORED

Use when the verifier measures or ranks candidates but does not prove
correctness.

Requirements:

- scoring function documented,
- score threshold or comparison rule documented,
- baseline result recorded,
- rollback or supersession policy documented,
- risk of benchmark overfitting noted.

Merge policy:

- autonomous merge only when the project has explicit thresholds and rollback
  policy;
- otherwise require approval.

Examples:

- benchmark optimization,
- fuzzing corpus improvement,
- search/ranking quality tasks.

### 3.3 CONSENSUS

Use when no single verifier is authoritative and the system needs independent
redundant work.

Requirements:

- N-over-M quorum rule,
- independence criteria,
- duplicate/collusion detection where possible,
- central sanity check,
- quorum evidence retained,
- tie/failure policy.

Merge policy:

- merge only after quorum is satisfied and required sanity checks pass.

Examples:

- subjective classification,
- data labeling,
- non-deterministic analysis where identical or compatible outputs are needed.

### 3.4 APPROVAL

Use when human or organizational risk acceptance is the controlling gate.

Requirements:

- approver role defined,
- approval criteria documented,
- approval identity recorded,
- separation-of-duties requirements stated,
- expiration or re-approval policy where applicable.

Merge policy:

- no autonomous merge until approval is recorded.

Examples:

- production SRE changes,
- legal/compliance-sensitive updates,
- high-impact security changes,
- domains where tests are informative but not sufficient.

## 4. Evidence Record

Each verification attempt SHOULD emit a structured record:

```text
VerificationEvidence {
  schema_version
  work_unit_id
  work_unit_revision
  adapter_id
  tier
  candidate_id
  candidate_hash
  contributor_id
  agent_id
  verifier_name
  verifier_version
  verifier_command
  toolchain_context
  started_at
  finished_at
  status                  # accepted | rejected | inconclusive | error
  score                   # SCORED only
  threshold               # SCORED only
  quorum                  # CONSENSUS only
  approval                # APPROVAL only
  artifact_hashes
  log_artifacts
  risk_exceptions
}
```

Records MAY be stored as AISP, JSON, JSONL, or another project-approved
machine-readable format. The format must be stable enough for generated
evidence packs and incident review.

## 5. Compliance Support

The system does not certify compliance. It supports auditability by producing
evidence for common governance questions:

- Who or what submitted the change?
- What was the work unit?
- What verifier or approval gate accepted it?
- Which toolchain and dependency context was used?
- What artifact actually merged?
- Were there exceptions?
- Can the decision be replayed or independently reviewed?

An ISMS owner can map these records to controls for change management, secure
development, access control, logging, supplier/toolchain governance, and risk
treatment. That mapping lives outside this spec.

## 6. Lean Adapter Mapping

The current Lean adapter is `VERIFIED`:

| Evidence field | Lean source |
|----------------|-------------|
| work unit | `goals/<id>.aisp` and `goals/<id>.lean` |
| candidate artifact | `library/Unsorry/<Name>.lean` |
| verifier | Gate A |
| toolchain context | `lean-toolchain`, Lake files, mathlib manifest |
| verifier result | build, statement-binding, axiom audit, kernel replay |
| artifact hash | library/index and provenance records |

ADR-048's verify-on-ingest policy remains compatible: the proof is verified by
trusted CI once for the pinned context, then immutability and provenance carry
that evidence forward.

## 7. Adapter Admission Checklist

A new adapter cannot use autonomous merge until it answers:

1. Which tier is it?
2. What verifier command runs locally?
3. What verifier command runs centrally?
4. What is the pinned toolchain context?
5. What evidence record is emitted?
6. What failure modes are inconclusive rather than rejected?
7. What artifacts are safe to merge?
8. Is approval or consensus required?
9. What happens if the verifier changes?
10. How is an accepted result audited later?

## 8. Dashboard and Evidence Pack Integration

ADR-051's experience layer SHOULD display:

- adapter tier,
- latest verifier outcomes,
- stale or missing evidence,
- accepted risk exceptions,
- approval-pending work,
- consensus-pending work,
- tier changes awaiting ADR/spec updates.

Periodic evidence packs SHOULD include a summary by tier so operators can see
how much work is fully deterministic versus scored, consensus-based, or
approval-gated.

## 9. Out of Scope

- Agent identity, quotas, reputation, and Sybil resistance.
- Claim substrate scaling.
- A hosted compliance product.
- Formal certification to ISO/IEC 27001 or any other standard.
- Defining every future adapter's verifier.
