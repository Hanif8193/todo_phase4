"""
Simple test handler to verify Vercel Python runtime works
Visit: /api/test-simple
"""
from http.server import BaseHTTPRequestHandler

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        message = '{"status": "Python is working on Vercel!"}'
        self.wfile.write(message.encode())
        return
