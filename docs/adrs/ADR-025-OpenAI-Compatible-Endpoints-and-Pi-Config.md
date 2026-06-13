# ADR-025: OpenAI-Compatible Local Endpoints and pi-coder Config

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-025 |
| **Initiative** | unsorry swarm provider portability |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** an OpenAI provider hardwired to `https://api.openai.com/v1` with a fixed model allow-list, now that ADR-022 / #292 enabled coordinated `--prove` for openai, and a desire to run local or self-hosted OpenAI-compatible models (Ollama / vLLM / LM Studio / a proxy) and to reuse an operator's existing pi-coder endpoint catalogue,
**facing** no way to point the provider at a custom endpoint or to use arbitrary local model ids, and the friction of re-declaring an endpoint, key, and model that already live in `~/.pi/agent/models.json`,
**we decided for** (1) an `OPENAI_BASE_URL` override (precedence: explicit arg → env → OpenAI's default) plus a model passthrough that bypasses the allow-list and attaches tools whenever a custom endpoint is in effect, reusing the OpenAI Chat-Completions client unchanged; and (2) a `-pi` **toggle** on `agent.sh` that resolves the endpoint, key, and model from `~/.pi/agent/models.json` by the **existing** `UNSORRY_MODEL` name (DRY — no new model argument), via a pure-stdlib resolver `tools/llm_providers/pi_config.py`, then drives the same OpenAI-compatible path in both `--prove-local` and coordinated `--prove`,
**and neglected** parsing `models.json` in bash (untestable, needs `jq`), a `--pi` flag inside `openai_cli.py` (couples the HTTP client to pi's schema and must be wired into both CLI codepaths), and a new `--pi-model` argument (violates DRY against the existing `UNSORRY_MODEL`),
**to achieve** local-model proving and translation against the same Gate A kernel-verification bar, with one-toggle reuse of an operator's pi endpoint catalogue,
**accepting that** only pi `api: "openai-completions"` entries are usable (others error clearly); local models that lack OpenAI function-calling cannot drive the `--prove` tool loop (translation works on any model); `apiKey` `$ENV` references are expanded but command-style (`!cmd`) keys are rejected rather than executed; the pi schema is treated as observed-and-tolerated; and trust still rests solely on Gate A re-checking every proof, independent of which endpoint or model produced it.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | OpenAI-compatible endpoints and pi-config | Specification | specs/SPEC-025-A-OpenAI-Compatible-Endpoints-and-Pi-Config.md |
| REF-2 | Local provider smoke mode (the path `-pi` rides) | ADR | ADR-022-Local-Provider-Smoke-Mode.md |
| REF-3 | Agent loop script | Specification | specs/SPEC-007-A-Agent-Loop-Script.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-13 |
| Accepted | unsorry maintainers | 2026-06-13 |
