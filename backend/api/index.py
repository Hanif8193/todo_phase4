import sys
import os

# Add src to path
current_dir = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.abspath(os.path.join(current_dir, '..', 'src'))
sys.path.insert(0, src_path)

# Import FastAPI app
from main import app

# Export for Vercel
# Note: Vercel will call this directly with ASGI events
from mangum import Mangum

handler = Mangum(app, lifespan="off")
