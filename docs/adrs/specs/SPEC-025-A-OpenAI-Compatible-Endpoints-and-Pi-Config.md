# SPEC-025-A: OpenAI-Compatible Endpoints and pi-coder Config

Implements: [ADR-025](../ADR-025-OpenAI-Compatible-Endpoints-and-Pi-Config.md) · Relates to: [ADR-022](../ADR-022-Local-Provider-Smoke-Mode.md), [SPEC-007-A](SPEC-007-A-Agent-Loop-Script.md) · Status: Living · Updated: 2026-06-13

Two layered capabilities: a base-URL/model override on the OpenAI provider (Part 1), and
a `-pi` toggle that sources that config from pi-coder's `models.json` (Part 2). The seam
between them is environment variables only — `-pi` resolves config and exports it; the
provider has no pi-awareness.

## 1. Endpoint override (`tools/llm_providers/openai_provider.py`)

- `OpenAIProvider(base_url=…)` resolves `base_url` with precedence **explicit arg →
  `OPENAI_BASE_URL` env → `DEFAULT_BASE_URL`**. `self.custom_endpoint` is true iff the
  resolved base_url (slash-normalised) differs from `DEFAULT_BASE_URL`.
- `openai_cli.py` exposes `--base-url` (default `OPENAI_BASE_URL`) and passes it to the
  provider. The prove path (`process_conversation`) reads `provider.base_url` and so
  targets the custom endpoint with no further change.

## 2. Model passthrough (`complete`)

- The model allow-list (`MODELS`) is enforced **only on the default endpoint**: on a
  custom endpoint any model id is accepted (local ids are arbitrary).
- Tools are attached when the model is a known `TOOL_MODELS` member **or** a custom
  endpoint is in effect. (The prove path attaches tools unconditionally and never
  consults the allow-list or `TOOL_MODELS`, so this affects only the translate path.)

## 3. pi resolver (`tools/llm_providers/pi_config.py`)

`resolve(model_name, config_path=None) -> (base_url, api_key, model_id)`:

- Default config path `~/.pi/agent/models.json`, overridable via `--config` / param /
  `UNSORRY_PI_CONFIG` (tests).
- Search every `providers.<p>.models[]` for `name == model_name` (a model's `name`
  defaults to its `id`); fall back to `id == model_name`. Name matches take priority.
- The matched model's **effective api** (`model.api` else `provider.api`) must be
  `openai-completions`; otherwise a clear error.
- `base_url` = the owning provider's `baseUrl` (required).
- `api_key` = the owning provider's `apiKey`, with `$VAR` / `${VAR}` expanded from the
  environment (error if unset); `!cmd` command-style keys are rejected; a missing key
  resolves to a harmless placeholder (local servers ignore the bearer token).
- Error taxonomy (`PiConfigError`, message is actionable): missing file (names path),
  unreadable/malformed JSON, no matching model, unsupported api type, unset `$ENV` key,
  command-style key.
- CLI: `python3 -m tools.llm_providers.pi_config resolve --model NAME [--config PATH]`
  prints **three lines** `base_url\napi_key\nmodel_id` on success (exit 0); a single
  stderr diagnostic and non-zero exit on any error.

## 4. agent.sh `-pi` (`swarm/agent.sh`)

- `-pi` is a toggle (`PI_MODE`). `resolve_pi_config()` requires `UNSORRY_MODEL`, calls the
  resolver, and exports `OPENAI_BASE_URL` / `OPENAI_API_KEY`, sets `UNSORRY_PROVIDER=openai`
  and `UNSORRY_MODEL=<resolved id>`, then logs the resolution. Resolver failure →
  `die_config` with the resolver's diagnostic.
- Invoked in `main()` **before** provider validation and **before** both the
  `--prove-local` and coordinated `--prove` branches, so both modes inherit it.
  Complementary to #292 (coordinated openai) — adds no gate, re-touches none of its lines.
- The openai `cli_health_probe` uses the configured model (not the hardcoded
  `gpt-4o-mini`) when `OPENAI_BASE_URL` is set, so a real failure on a local endpoint is
  not misclassified as infrastructure (ADR-016).

## Acceptance criteria

1. `OPENAI_BASE_URL` from env / explicit arg overrides the endpoint; default endpoint unchanged (`test_openai_provider.py`).
2. Custom endpoint passes arbitrary model ids; default endpoint still rejects unknown models.
3. Tools attach on a custom endpoint even for non-`TOOL_MODELS` ids; not attached for a non-tool model on the default endpoint.
4. `pi_config.resolve` returns the right triple by name and by id; respects per-model provider ownership.
5. `apiKey` `$VAR`/`${VAR}` expand; literal passes through; missing key → placeholder; unset `$ENV` / `!cmd` / missing-file / missing-model / non-openai-api → `PiConfigError`.
6. The `pi_config` CLI prints exactly three lines on success and exits non-zero with a diagnostic on error.
7. `-pi` resolves and exports correctly; errors when `UNSORRY_MODEL` is unset and when the config/model is missing; works in `--prove-local` and coordinated `--prove`.
8. `shellcheck swarm/agent.sh` clean; `./swarm/agent.sh --self-test` green; `pytest tools/llm_providers` green and run in CI.
