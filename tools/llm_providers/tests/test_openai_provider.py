"""Tests for OpenAI provider base_url override + model passthrough (ADR-025).

No network: `session.post` is monkeypatched to a recorder that captures the
request payload and returns a canned completion.
"""
import pytest

from tools.llm_providers.openai_provider import OpenAIProvider, OpenAIError


class FakeResp:
    def __init__(self, payload):
        self._payload = payload

    def raise_for_status(self):
        return None

    def json(self):
        return self._payload


def recorder(captured, content="OK"):
    """Return a session.post stand-in that records the request json."""
    def post(url, json=None, timeout=None):
        captured["url"] = url
        captured["json"] = json
        return FakeResp({"choices": [{"message": {"content": content}}]})
    return post


def make_provider(monkeypatch, base_url=None, env_base=None, model_env_key="x"):
    monkeypatch.setenv("OPENAI_API_KEY", model_env_key)
    if env_base is not None:
        monkeypatch.setenv("OPENAI_BASE_URL", env_base)
    else:
        monkeypatch.delenv("OPENAI_BASE_URL", raising=False)
    return OpenAIProvider(base_url=base_url)


def test_base_url_from_env(monkeypatch):
    p = make_provider(monkeypatch, env_base="http://localhost:11434/v1")
    assert p.base_url == "http://localhost:11434/v1"
    assert p.custom_endpoint is True


def test_explicit_arg_beats_env(monkeypatch):
    p = make_provider(monkeypatch, base_url="http://h/v1", env_base="http://env/v1")
    assert p.base_url == "http://h/v1"
    assert p.custom_endpoint is True


def test_default_endpoint(monkeypatch):
    p = make_provider(monkeypatch)
    assert p.base_url == OpenAIProvider.DEFAULT_BASE_URL
    assert p.custom_endpoint is False


def test_model_passthrough_on_custom_endpoint(monkeypatch):
    p = make_provider(monkeypatch, env_base="http://localhost:11434/v1")
    captured = {}
    monkeypatch.setattr(p.session, "post", recorder(captured))
    # An arbitrary local model id must NOT raise "Unknown model"
    p.complete("hi", model="llama3.1:8b")
    assert captured["json"]["model"] == "llama3.1:8b"
    assert captured["url"] == "http://localhost:11434/v1/chat/completions"


def test_model_rejected_on_default_endpoint(monkeypatch):
    p = make_provider(monkeypatch)  # default endpoint
    with pytest.raises(OpenAIError):
        p.complete("hi", model="llama3.1:8b")


def test_tools_attached_on_custom_endpoint(monkeypatch):
    p = make_provider(monkeypatch, env_base="http://localhost:11434/v1")
    captured = {}
    monkeypatch.setattr(p.session, "post", recorder(captured))
    # llama3.1:8b is not in TOOL_MODELS, but a custom endpoint must still get tools
    p.complete("hi", model="llama3.1:8b", tools=[{"type": "function", "function": {"name": "f"}}])
    assert "tools" in captured["json"]
    assert captured["json"]["tool_choice"] == "auto"


def test_tools_not_attached_for_non_tool_model_on_default(monkeypatch):
    p = make_provider(monkeypatch)  # default endpoint
    captured = {}
    monkeypatch.setattr(p.session, "post", recorder(captured))
    # o1 is a known model but not a TOOL_MODEL; default endpoint must not attach tools
    p.complete("hi", model="o1", tools=[{"type": "function", "function": {"name": "f"}}])
    assert "tools" not in captured["json"]
