import sys
import os

# Add your project directory to sys.path
project_home = '/home/Hanif6831/todo_phase4/backend'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Add src directory to sys.path
src_path = '/home/Hanif6831/todo_phase4/backend/src'
if src_path not in sys.path:
    sys.path.insert(0, src_path)

# Add virtualenv site-packages to sys.path
venv_path = '/home/Hanif6831/todo_phase4/backend/venv'
python_version = 'python3.10'
site_packages = os.path.join(venv_path, 'lib', python_version, 'site-packages')
if site_packages not in sys.path:
    sys.path.insert(0, site_packages)

# Load environment variables from .env file (for free PythonAnywhere plan)
# This .env file should ONLY exist on PythonAnywhere, never commit it to git
from dotenv import load_dotenv
env_path = os.path.join(project_home, '.env')
load_dotenv(env_path)

# Import FastAPI app
from main import app

# Wrap ASGI app (FastAPI) for WSGI server (PythonAnywhere)
from asgiref.wsgi import WsgiToAsgi

application = WsgiToAsgi(app)
