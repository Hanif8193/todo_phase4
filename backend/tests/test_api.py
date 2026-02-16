"""
Tests for src/main.py — FastAPI routes.
"""
import pytest
from unittest.mock import AsyncMock, patch
from fastapi.testclient import TestClient

import main as main_module
from main import app

client = TestClient(app)


@pytest.fixture(autouse=True)
def reset_todo_list():
    """Clear the in-memory todo list before and after each test."""
    main_module.todo_list.clear()
    yield
    main_module.todo_list.clear()


# ---------------------------------------------------------------------------
# GET /
# ---------------------------------------------------------------------------

def test_root_returns_200():
    response = client.get("/")
    assert response.status_code == 200


def test_root_message():
    response = client.get("/")
    assert "message" in response.json()


# ---------------------------------------------------------------------------
# GET /health
# ---------------------------------------------------------------------------

def test_health_returns_ok():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


# ---------------------------------------------------------------------------
# GET /todos
# ---------------------------------------------------------------------------

def test_get_todos_empty():
    response = client.get("/todos")
    assert response.status_code == 200
    assert response.json() == {"todos": []}


def test_get_todos_after_adding():
    main_module.todo_list.extend(["Task 1", "Task 2"])
    response = client.get("/todos")
    assert response.status_code == 200
    assert response.json() == {"todos": ["Task 1", "Task 2"]}


# ---------------------------------------------------------------------------
# POST /todos
# ---------------------------------------------------------------------------

def test_add_todo_returns_task_in_response():
    response = client.post("/todos", json={"task": "Buy milk"})
    assert response.status_code == 200
    data = response.json()
    assert "Buy milk" in data["message"]
    assert "Buy milk" in data["todos"]


def test_add_todo_persists():
    client.post("/todos", json={"task": "First"})
    client.post("/todos", json={"task": "Second"})
    response = client.get("/todos")
    assert response.json()["todos"] == ["First", "Second"]


def test_add_todo_requires_task_field():
    response = client.post("/todos", json={})
    assert response.status_code == 422


def test_add_todo_empty_string_is_accepted():
    response = client.post("/todos", json={"task": ""})
    assert response.status_code == 200


# ---------------------------------------------------------------------------
# DELETE /todos/{index}
# ---------------------------------------------------------------------------

def test_delete_todo_removes_correct_item():
    main_module.todo_list.extend(["Alpha", "Beta", "Gamma"])
    response = client.delete("/todos/1")
    assert response.status_code == 200
    assert "Beta" in response.json()["message"]
    assert response.json()["todos"] == ["Alpha", "Gamma"]


def test_delete_todo_first_item():
    main_module.todo_list.extend(["First", "Second"])
    client.delete("/todos/0")
    assert main_module.todo_list == ["Second"]


def test_delete_todo_invalid_index_returns_404():
    response = client.delete("/todos/99")
    assert response.status_code == 404


def test_delete_todo_negative_index_returns_404():
    main_module.todo_list.append("Some task")
    response = client.delete("/todos/-1")
    assert response.status_code == 404


def test_delete_todo_empty_list_returns_404():
    response = client.delete("/todos/0")
    assert response.status_code == 404


# ---------------------------------------------------------------------------
# POST /todos/run  (AI agent endpoint)
# ---------------------------------------------------------------------------

def test_run_task_without_agent_returns_503():
    original_agent = main_module.agent
    main_module.agent = None
    try:
        response = client.post("/todos/run", json={"task": "Anything"})
        assert response.status_code == 503
    finally:
        main_module.agent = original_agent


def test_run_task_requires_task_field():
    response = client.post("/todos/run", json={})
    assert response.status_code == 422


def test_run_task_with_mocked_agent():
    mock_agent = AsyncMock()
    mock_response = AsyncMock()
    mock_response.choices = [AsyncMock()]
    mock_response.choices[0].message.content = "Task completed!"
    mock_agent.chat.completions.create = AsyncMock(return_value=mock_response)

    original_agent = main_module.agent
    main_module.agent = mock_agent
    try:
        response = client.post("/todos/run", json={"task": "Do something"})
        assert response.status_code == 200
        data = response.json()
        assert data["task"] == "Do something"
        assert data["result"] == "Task completed!"
    finally:
        main_module.agent = original_agent


def test_run_task_agent_exception_returns_500():
    mock_agent = AsyncMock()
    mock_agent.chat.completions.create = AsyncMock(
        side_effect=Exception("OpenAI unavailable")
    )

    original_agent = main_module.agent
    main_module.agent = mock_agent
    try:
        response = client.post("/todos/run", json={"task": "Fail"})
        assert response.status_code == 500
    finally:
        main_module.agent = original_agent
