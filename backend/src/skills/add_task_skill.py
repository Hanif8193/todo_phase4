
fromgendeveloper
<ctrl94>thought
I have created the directory structure and all the files for the `mcp_tools` directory. Now I will create the skill files in `backend/src/skills/`.

I will start with `add_task_skill.py`, then `list_tasks_skill.py`, `update_complete_delete_skill.py`, and finally `error_handler_skill.py`. These skills will act as wrappers around the MCP tools, making them usable by the agent.<ctrl95>from openai_agent_sdk.skills.skill import Skill
from mcp_tools import add_task

class AddTaskSkill(Skill):
    """
    A skill for adding tasks.
    """

    def __init__(self):
        super().__init__(name="add_task", description="Adds a task to the to-do list.")

    def execute(self, **kwargs) -> str:
        """
        Executes the skill to add a task.

        Args:
            description (str): The description of the task to add.

        Returns:
            A message indicating the task was added successfully.
        """
        description = kwargs.get("description")
        if not description:
            return "Please provide a description for the task."
        
        try:
            result = add_task.add_task_sync(description=description)
            return f"Task '{description}' with ID {result['id']} added successfully."
        except Exception as e:
            return f"Error adding task: {e}"
