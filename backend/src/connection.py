
# connection.py
from agents import AsyncOpenAI, OpenAIChatCompletionsModel, RunConfig, Agent, Runner

def create_agent():
    """
    Create and return your AI agent
    """
    # Example: initialize agent with a chat model
    model = OpenAIChatCompletionsModel(model_name="gpt-4")
    config = RunConfig()
    agent = Agent(model=model, config=config)
    return agent

def run_agent(agent, task: str):
    """
    Run a task through the agent
    """
    runner = Runner(agent)
    return runner.run(task)
