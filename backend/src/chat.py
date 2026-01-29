from openai_agent_sdk.agent import Agent
from skills.add_task_skill import AddTaskSkill
from skills.list_tasks_skill import ListTasksSkill
from skills.update_complete_delete_skill import UpdateCompleteDeleteSkill
from skills.error_handler_skill import ErrorHandlerSkill
from agent_connector import AgentConnector

class TodoAgent(Agent):
    """
    A to-do chatbot agent that connects to an MCP server.
    """

    def __init__(self, mcp_server_url: str):
        """
        Initializes the TodoAgent.

        Args:
            mcp_server_url: The URL of the MCP server.
        """
        super().__init__(
            name="TodoAgent",
            description="A to-do chatbot agent.",
            skills=[
                AddTaskSkill(),
                ListTasksSkill(),
                UpdateCompleteDeleteSkill(),
                ErrorHandlerSkill(),
            ],
        )
        self.connector = AgentConnector(mcp_server_url).get_connector()

    def __call__(self, text: str, **kwargs):
        return self.connector(text=text, **kwargs)
