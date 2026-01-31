from http.server import BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import json
import os

# Simple in-memory todo list (resets on each deployment)
todo_list = []

class handler(BaseHTTPRequestHandler):
    def _send_json_response(self, status_code, data):
        """Helper to send JSON response"""
        self.send_response(status_code)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def do_OPTIONS(self):
        """Handle CORS preflight"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_GET(self):
        """Handle GET requests"""
        path = urlparse(self.path).path

        if path == '/' or path == '/api' or path == '/api/':
            self._send_json_response(200, {"message": "AI Todo Chatbot is running on Vercel!"})
        elif path == '/health' or path == '/api/health':
            self._send_json_response(200, {"status": "ok"})
        elif path == '/todos' or path == '/api/todos':
            self._send_json_response(200, {"todos": todo_list})
        else:
            self._send_json_response(404, {"error": "Not found"})

    def do_POST(self):
        """Handle POST requests"""
        path = urlparse(self.path).path
        content_length = int(self.headers.get('Content-Length', 0))

        if content_length > 0:
            body = self.rfile.read(content_length)
            try:
                data = json.loads(body.decode())
            except json.JSONDecodeError:
                self._send_json_response(400, {"error": "Invalid JSON"})
                return
        else:
            data = {}

        if path == '/todos' or path == '/api/todos':
            task = data.get('task', '')
            if task:
                todo_list.append(task)
                self._send_json_response(200, {
                    "message": f"Task '{task}' added successfully!",
                    "todos": todo_list
                })
            else:
                self._send_json_response(400, {"error": "Task is required"})
        elif path == '/todos/run' or path == '/api/todos/run':
            self._send_json_response(503, {
                "error": "AI features not available in this deployment. Set OPENAI_API_KEY to enable."
            })
        else:
            self._send_json_response(404, {"error": "Not found"})

    def do_DELETE(self):
        """Handle DELETE requests"""
        path = urlparse(self.path).path

        # Parse index from path like /todos/0
        if path.startswith('/todos/') or path.startswith('/api/todos/'):
            try:
                index = int(path.split('/')[-1])
                if 0 <= index < len(todo_list):
                    deleted_task = todo_list.pop(index)
                    self._send_json_response(200, {
                        "message": f"Task '{deleted_task}' deleted successfully!",
                        "todos": todo_list
                    })
                else:
                    self._send_json_response(404, {"error": "Todo not found"})
            except (ValueError, IndexError):
                self._send_json_response(400, {"error": "Invalid index"})
        else:
            self._send_json_response(404, {"error": "Not found"})
