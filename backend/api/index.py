import sys
import os

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

# Import FastAPI app
from main import app

# Wrap FastAPI with Mangum for serverless deployment
from mangum import Mangum

handler = Mangum(app)
