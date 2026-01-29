
import asyncio
from typing import Dict, Any, List

# This is a placeholder for a real database connection.
# In a production environment, you would use a library like asyncpg to connect to Neon PostgreSQL.
class NeonDB:
    def __init__(self):
        self.tasks = {}
        self.next_id = 1

    async def execute(self, query: str, params: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        # This is a mock implementation.
        # In a real scenario, you would parse the SQL query and interact with the database.
        if "INSERT INTO tasks" in query:
            task_id = self.next_id
            self.tasks[task_id] = {"id": task_id, "description": params["description"], "completed": False}
            self.next_id += 1
            return [{"id": task_id}]
        elif "SELECT id, description, completed FROM tasks" in query:
            return list(self.tasks.values())
        elif "UPDATE tasks" in query:
            task_id = params["id"]
            if task_id in self.tasks:
                if "description" in params:
                    self.tasks[task_id]["description"] = params["description"]
                if "completed" in params:
                    self.tasks[task_id]["completed"] = params["completed"]
                return [{"id": task_id}]
            return []
        elif "DELETE FROM tasks" in query:
            task_id = params["id"]
            if task_id in self.tasks:
                del self.tasks[task_id]
                return [{"id": task_id}]
            return []
        return []

db = NeonDB()

async def add_task(description: str) -> Dict[str, Any]:
    """
    Adds a new task to the database.
    
    Args:
        description: The description of the task.
        
    Returns:
        A dictionary containing the id of the newly created task.
    """
    result = await db.execute("INSERT INTO tasks (description) VALUES (:description)", {"description": description})
    return result[0]

async def list_tasks() -> List[Dict[str, Any]]:
    """
    Lists all tasks from the database.
    
    Returns:
        A list of dictionaries, where each dictionary represents a task.
    """
    return await db.execute("SELECT id, description, completed FROM tasks")

async def complete_task(task_id: int) -> Dict[str, Any]:
    """
    Marks a task as complete.
    
    Args:
        task_id: The id of the task to mark as complete.
        
    Returns:
        A dictionary containing the id of the completed task.
    """
    result = await db.execute("UPDATE tasks SET completed = TRUE WHERE id = :id", {"id": task_id})
    if not result:
        raise ValueError(f"Task with id {task_id} not found.")
    return result[0]

async def delete_task(task_id: int) -> Dict[str, Any]:
    """
    Deletes a task from the database.
    
    Args:
        task_id: The id of the task to delete.
        
    Returns:
        A dictionary containing the id of the deleted task.
    """
    result = await db.execute("DELETE FROM tasks WHERE id = :id", {"id": task_id})
    if not result:
        raise ValueError(f"Task with id {task_id} not found.")
    return result[0]

async def update_task(task_id: int, description: str) -> Dict[str, Any]:
    """
    Updates the description of a task.
    
    Args:
        task_id: The id of the task to update.
        description: The new description for the task.
        
    Returns:
        A dictionary containing the id of the updated task.
    """
    result = await db.execute("UPDATE tasks SET description = :description WHERE id = :id", {"id": task_id, "description": description})
    if not result:
        raise ValueError(f"Task with id {task_id} not found.")
    return result[0]
