
from typing import Dict, Any
from .add_task import delete_task as remove_task

async def delete_task(task_id: int) -> Dict[str, Any]:
    """
    Deletes a task from the database.
    
    Args:
        task_id: The id of the task to delete.
        
    Returns:
        A dictionary containing the id of the deleted task.
    """
    return await remove_task(task_id)
