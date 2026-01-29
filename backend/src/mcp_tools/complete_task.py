
from typing import Dict, Any
from .add_task import complete_task as mark_task_complete

async def complete_task(task_id: int) -> Dict[str, Any]:
    """
    Marks a task as complete.
    
    Args:
        task_id: The id of the task to mark as complete.
        
    Returns:
        A dictionary containing the id of the completed task.
    """
    return await mark_task_complete(task_id)
