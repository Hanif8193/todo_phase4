from openai_agent_sdk.skills.skill import Skill

class ErrorHandlerSkill(Skill):
    """
    A skill for handling errors.
    """

    def __init__(self):
        super().__init__(name="error_handler", description="Handles errors and provides a user-friendly message.")

    def execute(self, **kwargs) -> str:
        """
        Executes the skill to handle an error.

        Args:
            error_message (str): The error message to handle.

        Returns:
            A user-friendly error message.
        """
        error_message = kwargs.get("error_message")
        return f"An error occurred: {error_message}. Please try again."
