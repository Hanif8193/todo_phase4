from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from connection import create_agent, run_agent

app = FastAPI(title="AI Todo Chatbot", version="1.0")

# Initialize the agent (can be async if needed)
agent = create_agent()

# Pydantic model for Todo item
class TodoItem(BaseModel):
    task: str

# In-memory storage for simplicity
todo_list = []

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/todos")
def get_todos():
    return {"todos": todo_list}

@app.post("/todos")
def add_todo(item: TodoItem):
    todo_list.append(item.task)
    return {"message": f"Task '{item.task}' added successfully!", "todos": todo_list}

@app.post("/todos/run")
def run_task(item: TodoItem):
    """
    Run the AI agent on a specific task
    """
    try:
        result = run_agent(agent, item.task)
        return {"task": item.task, "result": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

