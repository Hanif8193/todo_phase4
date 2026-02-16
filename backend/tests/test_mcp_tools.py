"""
Tests for src/mcp_tools — NeonDB mock and async CRUD operations.
"""
import pytest
import mcp_tools.add_task as add_task_module
from mcp_tools.add_task import add_task, list_tasks, complete_task, delete_task, update_task


@pytest.fixture(autouse=True)
def reset_db():
    """Reset the in-memory NeonDB state before every test."""
    add_task_module.db.tasks.clear()
    add_task_module.db.next_id = 1
    yield


# ---------------------------------------------------------------------------
# add_task
# ---------------------------------------------------------------------------

async def test_add_task_returns_id():
    result = await add_task("Buy groceries")
    assert result == {"id": 1}


async def test_add_task_increments_id():
    await add_task("Task A")
    result = await add_task("Task B")
    assert result == {"id": 2}


async def test_add_task_persists_in_db():
    await add_task("Write tests")
    tasks = await list_tasks()
    assert len(tasks) == 1
    assert tasks[0]["description"] == "Write tests"
    assert tasks[0]["completed"] is False


# ---------------------------------------------------------------------------
# list_tasks
# ---------------------------------------------------------------------------

async def test_list_tasks_empty():
    tasks = await list_tasks()
    assert tasks == []


async def test_list_tasks_multiple():
    await add_task("Alpha")
    await add_task("Beta")
    await add_task("Gamma")
    tasks = await list_tasks()
    assert len(tasks) == 3
    descriptions = [t["description"] for t in tasks]
    assert "Alpha" in descriptions
    assert "Beta" in descriptions
    assert "Gamma" in descriptions


async def test_list_tasks_contains_expected_fields():
    await add_task("Check fields")
    tasks = await list_tasks()
    task = tasks[0]
    assert "id" in task
    assert "description" in task
    assert "completed" in task


# ---------------------------------------------------------------------------
# complete_task
# ---------------------------------------------------------------------------

async def test_complete_task_marks_done():
    added = await add_task("Finish report")
    task_id = added["id"]
    result = await complete_task(task_id)
    assert result == {"id": task_id}
    tasks = await list_tasks()
    assert tasks[0]["completed"] is True


async def test_complete_task_not_found_raises():
    with pytest.raises(ValueError, match="not found"):
        await complete_task(999)


# ---------------------------------------------------------------------------
# delete_task
# ---------------------------------------------------------------------------

async def test_delete_task_removes_it():
    added = await add_task("Temporary task")
    task_id = added["id"]
    result = await delete_task(task_id)
    assert result == {"id": task_id}
    tasks = await list_tasks()
    assert tasks == []


async def test_delete_task_not_found_raises():
    with pytest.raises(ValueError, match="not found"):
        await delete_task(999)


async def test_delete_task_only_removes_target():
    await add_task("Keep me")
    added = await add_task("Delete me")
    await delete_task(added["id"])
    tasks = await list_tasks()
    assert len(tasks) == 1
    assert tasks[0]["description"] == "Keep me"


# ---------------------------------------------------------------------------
# update_task
# ---------------------------------------------------------------------------

async def test_update_task_changes_description():
    added = await add_task("Old description")
    task_id = added["id"]
    result = await update_task(task_id, "New description")
    assert result == {"id": task_id}
    tasks = await list_tasks()
    assert tasks[0]["description"] == "New description"


async def test_update_task_not_found_raises():
    with pytest.raises(ValueError, match="not found"):
        await update_task(999, "Irrelevant")


async def test_update_task_does_not_change_completed():
    added = await add_task("Stay incomplete")
    task_id = added["id"]
    await update_task(task_id, "Updated text")
    tasks = await list_tasks()
    assert tasks[0]["completed"] is False
