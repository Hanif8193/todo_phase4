from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from mangum import Mangum
import os

# Create FastAPI app directly here
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

# Todo model
class TodoItem(BaseModel):
    task: str

# In-memory list (Note: This resets on each deployment)
todo_list = []

# Routes
@app.get("/")
def root():
    return {"message": "AI Todo Chatbot is running on Vercel!"}

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

@app.delete("/todos/{index}")
def delete_todo(index: int):
    if 0 <= index < len(todo_list):
        deleted_task = todo_list.pop(index)
        return {"message": f"Task '{deleted_task}' deleted successfully!", "todos": todo_list}
    raise HTTPException(status_code=404, detail="Todo not found")

# AI endpoint (disabled - no OpenAI key needed for basic features)
@app.post("/todos/run")
async def run_task(item: TodoItem):
    raise HTTPException(
        status_code=503,
        detail="AI features not available in this deployment. Set OPENAI_API_KEY to enable."
    )

# Vercel handler
handler = Mangum(app, lifespan="off")
