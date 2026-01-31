from http.server import BaseHTTPRequestHandler
import sys
import os

# Add src to path
current_dir = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.abspath(os.path.join(current_dir, '..', 'src'))
sys.path.insert(0, src_path)

try:
    # Import FastAPI app
    from main import app
    from mangum import Mangum

    # Create Mangum handler
    asgi_handler = Mangum(app, lifespan="off")

    class handler(BaseHTTPRequestHandler):
        def do_GET(self):
            # Convert HTTP request to ASGI format and call FastAPI
            event = {
                "httpMethod": self.command,
                "path": self.path,
                "headers": dict(self.headers),
                "body": None,
                "isBase64Encoded": False
            }

            context = {}
            response = asgi_handler(event, context)

            # Send response
            self.send_response(response.get("statusCode", 200))
            for key, value in response.get("headers", {}).items():
                self.send_header(key, value)
            self.end_headers()

            body = response.get("body", "")
            self.wfile.write(body.encode() if isinstance(body, str) else body)

        def do_POST(self):
            # Read POST body
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length).decode('utf-8') if content_length else None

            # Convert to ASGI format
            event = {
                "httpMethod": self.command,
                "path": self.path,
                "headers": dict(self.headers),
                "body": body,
                "isBase64Encoded": False
            }

            context = {}
            response = asgi_handler(event, context)

            # Send response
            self.send_response(response.get("statusCode", 200))
            for key, value in response.get("headers", {}).items():
                self.send_header(key, value)
            self.end_headers()

            body = response.get("body", "")
            self.wfile.write(body.encode() if isinstance(body, str) else body)

        def do_DELETE(self):
            self.do_GET()  # Handle DELETE same as GET

except Exception as e:
    import json

    # Fallback if FastAPI import fails
    class handler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            error_msg = {
                "error": "FastAPI import failed",
                "details": str(e),
                "sys_path": sys.path[:3]
            }

            self.wfile.write(json.dumps(error_msg).encode())
