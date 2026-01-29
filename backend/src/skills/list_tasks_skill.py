from openai_agent_sdk.skills.skill import Skill
from mcp_tools import list_tasks

class ListTasksSkill(Skill):
    """
    A skill for listing tasks.
    """

    def __init__(self):
        super().__init__(name="list_tasks", description="Lists all tasks in the to-do list.")

    def execute(self, **kwargs) -> str:
        """
        Executes the skill to list all tasks.

        Returns:
            A formatted string of all tasks.
        """
        try:
            tasks = list_tasks.list_tasks_sync()
            if not tasks:
                return "No tasks found."
            
            return "\n".join([f"ID: {task['id']}, Description: {task['description']}, Completed: {task['completed']}" for task in tasks])
        except Exception as e:
            return f"Error listing tasks: {e}"