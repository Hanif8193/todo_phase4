
# connection.py
from openai import AsyncOpenAI
import os

def create_agent():
    """
    Create and return OpenAI client
    """
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY environment variable not set")

    client = AsyncOpenAI(api_key=api_key)
    return client

async def run_agent(agent, task: str):
    """
    Run a task through the OpenAI client
    """
    try:
        response = await agent.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a helpful assistant for managing todos."},
                {"role": "user", "content": task}
            ]
        )
        return response.choices[0].message.content
    except Exception as e:
        raise Exception(f"Error running agent: {str(e)}")
