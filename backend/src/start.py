from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, List
from chat import TodoAgent

app = FastAPI()

# This should be loaded from a config file in a real application
MCP_SERVER_URL = "http://localhost:8080"
agent = TodoAgent(mcp_server_url=MCP_SERVER_URL)

class ChatRequest(BaseModel):
    message: str
    conversation_id: Optional[int] = None

class ChatResponse(BaseModel):
    conversation_id: int
    response: str
    tool_calls: List[dict]

@app.post("/api/{user_id}/chat", response_model=ChatResponse)
async def chat(user_id: str, request: ChatRequest):
    """
    Handles a chat request from a user.
    """
    try:
        response = agent(text=request.message, conversation_id=request.conversation_id)
        
        # The agent response format may vary. Adjust the parsing as needed.
        # This is a simplified example.
        if isinstance(response, dict) and "text" in response:
            tool_calls = response.get("tool_calls", [])
            return ChatResponse(
                conversation_id=response.get("conversation_id", request.conversation_id or 0),
                response=response["text"],
                tool_calls=tool_calls
            )
        else:
            # Handle cases where the response is not in the expected format
            return ChatResponse(
                conversation_id=request.conversation_id or 0,
                response=str(response),
                tool_calls=[]
            )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
