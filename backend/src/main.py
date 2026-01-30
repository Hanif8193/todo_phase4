from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from connection import create_agent, run_agent
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize FastAPI
app = FastAPI(title="AI Todo Chatbot", version="1.0")

# CORS configuration
allowed_origins = os.getenv("ALLOWED_ORIGINS", "*").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize the agent
agent = create_agent()

# Todo model
class TodoItem(BaseModel):
    task: str

# In-memory list
todo_list = []

# Root route
@app.get("/")
def root():
    return {"message": "AI Todo Chatbot is running!"}

# Health check
@app.get("/health")
def health():
    return {"status": "ok"}

# Get todos
@app.get("/todos")
def get_todos():
    return {"todos": todo_list}

# Add todo
@app.post("/todos")
def add_todo(item: TodoItem):
    todo_list.append(item.task)
    return {"message": f"Task '{item.task}' added successfully!", "todos": todo_list}

# Run AI agent task
@app.post("/todos/run")
async def run_task(item: TodoItem):
    try:
        result = await run_agent(agent, item.task)
        return {"task": item.task, "result": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

