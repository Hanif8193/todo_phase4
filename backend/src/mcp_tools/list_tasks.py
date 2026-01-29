
from typing import List, Dict, Any
from .add_task import list_tasks as get_tasks

async def list_tasks() -> List[Dict[str, Any]]:
    """
    Lists all tasks from the database.
    
    Returns:
        A list of dictionaries, where each dictionary represents a task.
    """
    return await get_tasks()
