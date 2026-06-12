# Gemini Provider Integration

This document outlines the constrained, local-first integration, restricted admin policy, and acceptance plan for the Gemini LLM provider within the `unsorry` distributed research swarm.

## 1. Local-Only Integration

To maintain maximum privacy, performance predictability, and deterministic local verification, the Gemini provider operates entirely through a local CLI wrapper or local proxy endpoint. 
- **No Third-Party SDKs:** The integration avoids heavy third-party SDKs, keeping dependency footprints minimal.
- **Hermetic Execution:** Execution context is completely isolated. No external telemetry or telemetry feedback loops are permitted.
- **Zero-Data Leakage:** All source files, context, and proof states remain on the local machine during verification.

## 2. Restricted Admin Policy

To prevent any arbitrary code execution or model-driven directory traversal, the Gemini provider operates under a strict, directory-bounded restricted administrator policy.
- **File System Sandbox:** The provider is restricted to reading and writing within the active, temporary PR/prove worktree (`prove-<goal>-<agent-id>`).
- **Command Access Control:** No arbitrary shell commands may be executed by the model. Tool use is limited strictly to `read_file`, `write_file`, and precise replacement functions.
- **Binary Whitelisting:** Only explicitly whitelisted toolchains (`lake`, `git`) are exposed, under a read-only or highly constrained operational mode.

## 3. Exact-Target Edits

Model edits are strictly target-bounded to minimize diff pollution and simplify the human-review or automated Gate A/B validation pipelines.
- **Single-File Scope:** The model is only allowed to modify the exact target proof file: `goals/<id>.lean`.
- **Anti-Refactoring Guard:** Any changes made outside of the target file, including formatting of adjacent files or removal of unrelated imports, are rejected at the provider boundary.
- **Validation-Driven Diffing:** Before any replacement is accepted, the diff is verified for exact boundary compliance, ensuring zero-pollution.

## 4. Model Handling & Effort Policy

Gemini model execution adheres to a progressive effort ladder and fallback policy optimized for mathematical proof search:
- **Model Standard:** Defaults to `gemini-2.5-pro` for deep proof search and complex tactic synthesis.
- **Progressive Effort Ladder:** Adapts calling parameters across multiple attempts (e.g., controlling temperature, token budgets, and search breadth on a scaling ladder similar to ADR-015).
- **Graceful Degrade:** On CLI configurations that do not support dynamic effort flags, the provider gracefully falls back to standard parameter sets without interrupting the execution loop.

## 5. Health Checks

Before any prove cycle is initiated, the provider performs a series of local health probes to avoid wasting compute or budget on broken environments.
- **Endpoint Reachability:** Probes local API ports or gateways to ensure the provider process is online.
- **API Key & Auth Verification:** Performs a minimal, fast, non-billing-incurring metadata call to check credentials.
- **Resource Readiness:** Confirms that local toolchain states and memory requirements are met.

## 6. Testing Strategy

The Gemini provider suite is backed by exhaustive unit and integration tests under the Python test suite:
- **Parameter Construction:** Tests that the CLI flags and API payloads are correctly formatted based on target model/effort configurations.
- **Path Policy Verification:** Unit tests confirming that any attempt to write outside of `goals/<id>.lean` triggers an immediate policy violation.
- **Schema Validation:** Ensures JSON input/output schemas conform strictly to AISP/coordination contract definitions.

## 7. Acceptance Smoke Test

A hermetic, offline acceptance smoke test is provided to verify the provider loop without making real remote API calls.
- **Preserved Worktree Smoke:** Running `./swarm/agent.sh --prove-local --goal <id> --provider gemini --dry-run` builds a preserved worktree and validates the end-to-end routing.
- **Mock Response Replay:** Uses a canned mock proof replay to verify that the local build (`lake build`) and Gate B validators successfully process a synthesized proof.
