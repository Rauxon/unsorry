---
name: unsorry-swarm-operations
description: "Workflow for running, inspecting, or modifying the Unsorry swarm. Use when working with swarm/agent.sh, swarm/supervise.sh, swarm/protocol.aisp, swarm prompts, claim lifecycle behavior, provider integrations, proof-run telemetry, model or effort policy, or local and coordinated proof-agent commands."
---

# Unsorry Swarm Operations

## Purpose

Use this skill to operate or modify the autonomous proof loop without confusing local experiments, coordinated claims, PR-producing runs, and analytics. The repository is the queue; the Lean kernel and CI gates decide acceptance.

## Operational Entry Points

Read these in order for swarm work:

```bash
sed -n '1,220p' swarm/README.md
sed -n '1,260p' swarm/protocol.aisp
sed -n '1,260p' CONTRIBUTING.md
sed -n '1,260p' tools/llm_providers/README.md
sed -n '1,220p' proof-runs/README.md
```

Use `swarm/AI_GUIDE.md` when you need AISP grammar details. Use `swarm/prompts/` when changing model-facing proof or decomposition instructions.

For deeper operational detail, load [references/runbook.md](references/runbook.md), [references/providers.md](references/providers.md), or [references/claims-and-telemetry.md](references/claims-and-telemetry.md).

## Run Modes

- `./swarm/agent.sh --self-test`: hermetic setup check. Use before changing the loop or diagnosing a local environment.
- `./swarm/agent.sh --dry-run --prove --once`: inspect selection and claim behavior without claiming.
- `./swarm/agent.sh --prove-local --goal <id> --provider claude|codex|gemini|openai`: local proof attempt with no fetch, claim, push, or PR. This is the default safe mode for forks and experiments.
- `./swarm/agent.sh --prove --once [--provider codex|openai]`: coordinated run that may claim, push a branch, open a PR, and rely on CI gates.
- `./swarm/agent.sh --translate-only --once`: translation/formalisation loop rather than proof loop.
- `./swarm/supervise.sh --prove --goal <id>`: unattended wrapper with backoff, PR hygiene, and merge waiting for driving a goal tree.

Coordinated `--prove` requires write access to the shared repository. If that is not known, use `--prove-local`.

## Claims And Queue Safety

- Claims live on the dedicated `claims` branch, not on `main`.
- A claim file has the shape `claims/<goal-id>.<agent-id>.aisp`.
- First push wins; a rejected push means the branch moved and another agent may have claimed the goal.
- Claims have TTLs and are reaped. Do not treat an expired or local claim file as ownership.
- Gate B enforces claim hygiene but cannot prove mathematics.

## Provider Access Pattern

Claude is the default coordinated provider. OpenAI-compatible providers are configured through environment variables:

```bash
OPENAI_BASE_URL=http://localhost:11434/v1 OPENAI_API_KEY=ollama \
  UNSORRY_PROVIDER=openai UNSORRY_MODEL=<model-id> \
  ./swarm/agent.sh --prove-local --goal <goal-id>
```

Use `-pi` when the model is already configured in pi-coder:

```bash
./swarm/agent.sh --prove-local -pi "<model name>" --goal <goal-id>
python3 -m tools.llm_providers.pi_config resolve --model "<model name>"
```

For coordinated `--prove`, use a provider and model that support tool calls. Translation can use simpler chat models.

## Telemetry And Leaderboard

- Successful coordinated proof runs may add proof provenance to `library/index/*.aisp`.
- Terminal coordinated outcomes are recorded under `proof-runs/` as `proved`, `decomposed`, or `failed`.
- Infrastructure failures and local-only smoke runs are excluded from `proof-runs/`.
- `UNSORRY_SOLVER` can override the credited GitHub handle. Do not guess historical attribution.
- Regenerate analytics after telemetry or index changes:

```bash
python3 -m tools.leaderboard --write .
python3 -m tools.visualiser --write .
```

## Validation

For swarm script or provider changes:

```bash
./swarm/agent.sh --self-test
python3 -m tools.gate_b validate .
pytest tools/llm_providers -q
python3 -m pytest tools -q
```

For a proof-producing run or proof metadata change:

```bash
lake build UnsorryLibrary --wfail
python3 -m tools.gate_b validate .
python3 -m tools.leaderboard --check .
```

For coordinated PR-producing changes, also check `.github/workflows/gate-a.yml`, `.github/workflows/gate-b.yml`, and any ADR/spec named by the code or docs you touch.

## Reporting

When reporting a swarm run, include the mode, provider, model if known, goal id, whether it was local or coordinated, claim/PR side effects, validation commands, and telemetry files created or intentionally omitted.

## Pack Resources

Load these only when the task needs the extra detail:

- [references/runbook.md](references/runbook.md): local/coordinated/supervised run modes and side effects.
- [references/providers.md](references/providers.md): Claude, Codex, OpenAI-compatible, local endpoint, and `-pi` configuration notes.
- [references/claims-and-telemetry.md](references/claims-and-telemetry.md): claims branch behavior, proof-run facts, attribution, and generated analytics.
- [references/swarm-debugging.md](references/swarm-debugging.md): common operational failures and first commands to run.

Reusable templates live in `assets/`:

- [assets/local-run-env.template.sh](assets/local-run-env.template.sh): environment variable template for OpenAI-compatible local runs.
- [assets/swarm-run-report-template.md](assets/swarm-run-report-template.md): concise run report.
- [assets/provider-smoke-test-checklist.md](assets/provider-smoke-test-checklist.md): provider setup and smoke-test checklist.
