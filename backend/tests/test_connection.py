"""
Tests for src/connection.py — OpenAI client creation and agent runner.
"""
import os
import pytest
from unittest.mock import AsyncMock, MagicMock, patch

import connection
from connection import create_agent, run_agent


# ---------------------------------------------------------------------------
# create_agent
# ---------------------------------------------------------------------------

def test_create_agent_raises_without_api_key(monkeypatch):
    monkeypatch.delenv("OPENAI_API_KEY", raising=False)
    with pytest.raises(ValueError, match="OPENAI_API_KEY"):
        create_agent()


def test_create_agent_raises_with_placeholder(monkeypatch):
    monkeypatch.setenv("OPENAI_API_KEY", "sk-your-new-api-key-here")
    with pytest.raises(ValueError, match="placeholder"):
        create_agent()


def test_create_agent_raises_with_empty_string(monkeypatch):
    monkeypatch.setenv("OPENAI_API_KEY", "")
    with pytest.raises(ValueError):
        create_agent()


def test_create_agent_returns_client_with_valid_key(monkeypatch):
    monkeypatch.setenv("OPENAI_API_KEY", "sk-testkey1234567890abcdef")
    from openai import AsyncOpenAI
    client = create_agent()
    assert isinstance(client, AsyncOpenAI)


# ---------------------------------------------------------------------------
# run_agent
# ---------------------------------------------------------------------------

async def test_run_agent_returns_model_response():
    mock_client = AsyncMock()
    mock_response = MagicMock()
    mock_response.choices = [MagicMock()]
    mock_response.choices[0].message.content = "Here are your todos."
    mock_client.chat.completions.create = AsyncMock(return_value=mock_response)

    result = await run_agent(mock_client, "List my tasks")
    assert result == "Here are your todos."


async def test_run_agent_passes_task_as_user_message():
    mock_client = AsyncMock()
    mock_response = MagicMock()
    mock_response.choices = [MagicMock()]
    mock_response.choices[0].message.content = "Done."
    mock_client.chat.completions.create = AsyncMock(return_value=mock_response)

    await run_agent(mock_client, "Add: buy apples")

    call_kwargs = mock_client.chat.completions.create.call_args
    messages = call_kwargs.kwargs.get("messages") or call_kwargs.args[0] if call_kwargs.args else []
    # Fallback: inspect keyword args
    if not messages:
        messages = call_kwargs[1].get("messages", [])
    user_messages = [m for m in messages if m.get("role") == "user"]
    assert any("buy apples" in m["content"] for m in user_messages)


async def test_run_agent_wraps_exception():
    mock_client = AsyncMock()
    mock_client.chat.completions.create = AsyncMock(
        side_effect=RuntimeError("network error")
    )
    with pytest.raises(Exception, match="Error running agent"):
        await run_agent(mock_client, "Any task")


async def test_run_agent_uses_gpt4_model():
    mock_client = AsyncMock()
    mock_response = MagicMock()
    mock_response.choices = [MagicMock()]
    mock_response.choices[0].message.content = "ok"
    mock_client.chat.completions.create = AsyncMock(return_value=mock_response)

    await run_agent(mock_client, "test")

    call_kwargs = mock_client.chat.completions.create.call_args
    model = call_kwargs.kwargs.get("model") or call_kwargs[1].get("model")
    assert model == "gpt-4"


async def test_run_agent_includes_system_prompt():
    mock_client = AsyncMock()
    mock_response = MagicMock()
    mock_response.choices = [MagicMock()]
    mock_response.choices[0].message.content = "ok"
    mock_client.chat.completions.create = AsyncMock(return_value=mock_response)

    await run_agent(mock_client, "test")

    call_kwargs = mock_client.chat.completions.create.call_args
    messages = call_kwargs.kwargs.get("messages", [])
    system_messages = [m for m in messages if m.get("role") == "system"]
    assert len(system_messages) >= 1
