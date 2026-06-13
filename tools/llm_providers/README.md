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

- `OPENAI_API_KEY` - Required. Your OpenAI API key
- `UNSORRY_PROVIDER` - Set to `openai` to use this provider
- `UNSORRY_MODEL` - Model to use (default: `gpt-4o`)
- `UNSORRY_EFFORT` - Maps to temperature: low=0.3, medium=0.2, high=0.1, max=0.0

### Translation with OpenAI

```bash
UNSORRY_TRANSLATE_PROVIDER=openai UNSORRY_MODEL=gpt-4o-mini ./swarm/agent.sh --translate-only --once
```

## Architecture

- `openai_provider.py` - Core OpenAI API client with tool support
- `openai_cli.py` - CLI wrapper compatible with claude/codex/gemini interfaces
- Integrated into `swarm/agent.sh` as a first-class provider
