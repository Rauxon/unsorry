# LLM Providers for Unsorry

OpenAI API provider for the Unsorry swarm, enabling use of GPT-4o, o1, o3-mini, and other OpenAI models for Lean 4 proof generation.

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Set your OpenAI API key:
```bash
export OPENAI_API_KEY="sk-..."
```

## Usage

### Prove mode with OpenAI

```bash
UNSORRY_PROVIDER=openai UNSORRY_MODEL=gpt-4o ./swarm/agent.sh --prove-local --goal <goal-id>
```

### Available Models

- `gpt-4o` (default) - Best for most proofs, supports tool use
- `gpt-4o-mini` - Faster, cheaper, good for simple proofs
- `gpt-4-turbo` - High quality, slower
- `o1` - Reasoning model, no tool use
- `o3-mini` - Fast reasoning model, supports tool use

### Environment Variables

- `OPENAI_API_KEY` - Required. Your OpenAI API key (any non-empty value for a local server)
- `OPENAI_BASE_URL` - OpenAI-compatible endpoint for local/self-hosted models (ADR-025)
- `UNSORRY_PROVIDER` - Set to `openai` to use this provider
- `UNSORRY_MODEL` - Model to use (default: `gpt-4o`; any id on a custom endpoint)
- `UNSORRY_EFFORT` - Maps to temperature: low=0.3, medium=0.2, high=0.1, max=0.0

### Translation with OpenAI

```bash
UNSORRY_TRANSLATE_PROVIDER=openai UNSORRY_MODEL=gpt-4o-mini ./swarm/agent.sh --translate-only --once
```

## OpenAI-compatible / local endpoints (ADR-025)

Point the provider at any OpenAI Chat-Completions-compatible server (Ollama, vLLM,
LM Studio, or a proxy) with `OPENAI_BASE_URL`. On a custom endpoint the model
allow-list is bypassed, so arbitrary local model ids work:

```bash
OPENAI_BASE_URL=http://localhost:11434/v1 OPENAI_API_KEY=ollama \
  UNSORRY_PROVIDER=openai UNSORRY_MODEL=llama3.1:8b \
  ./swarm/agent.sh --prove-local --goal <goal-id>
```

**Caveat:** the `--prove` tool loop needs OpenAI function-calling — use a tool-capable
local model (e.g. Llama-3.1-Instruct, a Qwen-coder). Translation works on any model.

### `-pi` — reuse pi-coder's models.json

If you already configure models in pi-coder's `~/.pi/agent/models.json`, the `-pi`
flag sources the endpoint, key, and model from it by the model name/id — given as the
optional `-pi <model>` argument, or via `UNSORRY_MODEL`:

```bash
./swarm/agent.sh --prove-local -pi "Llama 3.1 8B (Local)" --goal <goal-id>
# or:  UNSORRY_MODEL="Llama 3.1 8B (Local)" ./swarm/agent.sh --prove-local -pi --goal <goal-id>
```

`-pi` looks up `UNSORRY_MODEL` among every provider's `models[]` (by `name`, then `id`),
requires the owning provider's `api` to be `openai-completions`, expands a `$ENV` `apiKey`,
and exports `OPENAI_BASE_URL` / `OPENAI_API_KEY` / `UNSORRY_PROVIDER=openai`. Works in both
`--prove-local` and coordinated `--prove`. The resolver is `pi_config.py`:

```bash
python3 -m tools.llm_providers.pi_config resolve --model "Llama 3.1 8B (Local)"
# → base_url, api_key, model_id (three lines)
```

## Architecture

- `openai_provider.py` - Core OpenAI API client with tool support and custom-endpoint passthrough
- `openai_cli.py` - CLI wrapper compatible with claude/codex/gemini interfaces
- `pi_config.py` - Pure-stdlib resolver for pi-coder's `~/.pi/agent/models.json` (ADR-025)
- Integrated into `swarm/agent.sh` as a first-class provider
