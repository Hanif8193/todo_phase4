from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from connection import create_agent, run_agent
import os

app = FastAPI(title="AI Todo Chatbot", version="1.0")

# CORS configuration
# In production, replace "*" with your specific Vercel domain
allowed_origins = os.getenv("ALLOWED_ORIGINS", "*").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

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

