from openai_agent_sdk.skills.skill import Skill
from mcp_tools import update_task, complete_task, delete_task

class UpdateCompleteDeleteSkill(Skill):
    """
    A skill for updating, completing, or deleting a task.
    """

    def __init__(self):
        super().__init__(name="update_complete_delete_task", description="Updates, completes, or deletes a task.")

    def execute(self, **kwargs) -> str:
        """
        Executes the skill to update, complete or delete a task.

        Args:
            action (str): The action to perform (update, complete, or delete).
            task_id (int): The ID of the task.
            description (str, optional): The new description for the task (for update action).

        Returns:
            A message indicating the result of the operation.
        """
        action = kwargs.get("action")
        task_id = kwargs.get("task_id")
        description = kwargs.get("description")

        if not action or not task_id:
            return "Please provide an action and a task ID."

        try:
            if action == "update":
                if not description:
                    return "Please provide a description for the task."
                update_task.update_task_sync(task_id=task_id, description=description)
                return f"Task with ID {task_id} updated successfully."
            elif action == "complete":
                complete_task.complete_task_sync(task_id=task_id)
                return f"Task with ID {task_id} marked as complete."
            elif action == "delete":
                delete_task.delete_task_sync(task_id=task_id)
                return f"Task with ID {task_id} deleted successfully."
            else:
                return "Invalid action. Please choose from 'update', 'complete', or 'delete'."
        except Exception as e:
            return f"Error performing action '{action}' on task with ID {task_id}: {e}"
