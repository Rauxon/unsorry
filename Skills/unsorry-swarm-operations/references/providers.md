# Provider Reference

## Default Providers

Claude is the default coordinated provider in the repository docs. Codex and OpenAI-compatible providers are supported for proof loops. Gemini is local-oriented unless current repo code says otherwise.

Always inspect `swarm/agent.sh` and `tools/llm_providers/README.md` before changing provider behavior.

## OpenAI-Compatible Endpoint

Use this shape for Ollama, vLLM, LM Studio, or a proxy:

```bash
OPENAI_BASE_URL=http://localhost:11434/v1 OPENAI_API_KEY=ollama \
  UNSORRY_PROVIDER=openai UNSORRY_MODEL=<model-id> \
  ./swarm/agent.sh --prove-local --goal <goal-id>
```

On a custom endpoint, the model allow-list may be bypassed by the provider layer. Coordinated proof mode still needs a tool-capable model.

## pi-coder Config

Use `-pi` to source endpoint, key, and model from `~/.pi/agent/models.json`:

```bash
python3 -m tools.llm_providers.pi_config resolve --model "<model name>"
./swarm/agent.sh --prove-local -pi "<model name>" --goal <goal-id>
```

The resolver requires an OpenAI Chat-Completions-compatible provider entry.

## Effort And Model Overrides

Common environment variables:

```bash
export UNSORRY_PROVIDER=openai
export UNSORRY_MODEL=<model-id>
export UNSORRY_EFFORT=high
export OPENAI_BASE_URL=<base-url>
export OPENAI_API_KEY=<key-or-placeholder>
```

Proof-surface calls may use progressive effort. Do not assume every CLI supports every effort flag; the repo policy is fail-soft where possible.

## Provider Test Commands

```bash
pytest tools/llm_providers -q
./swarm/agent.sh --self-test
```

Use a local `--prove-local` goal smoke test only when credentials and model availability are intentionally configured.
