
from typing import Dict, Any
from .add_task import update_task as modify_task

async def update_task(task_id: int, description: str) -> Dict[str, Any]:
    """
    Updates the description of a task.
    
    Args:
        task_id: The id of the task to update.
        description: The new description for the task.
        
    Returns:
        A dictionary containing the id of the updated task.
    """
    return await modify_task(task_id, description)
