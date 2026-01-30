# +++++++++++ PYTHONANYWHERE WSGI CONFIGURATION +++++++++++
# This file tells PythonAnywhere how to run your FastAPI app

import sys
import os

# ========== CONFIGURATION ==========
# IMPORTANT: Update these paths to match your PythonAnywhere setup
USERNAME = 'Hanif6831'  # Your PythonAnywhere username
PROJECT_NAME = 'todo_pase4'  # Your project folder name (match exactly!)

# ========== PATH SETUP ==========
# Path to your project home (where backend folder is)
project_home = f'/home/{USERNAME}/{PROJECT_NAME}'
backend_path = f'{project_home}/backend'
src_path = f'{backend_path}/src'

# Add paths to sys.path
if src_path not in sys.path:
    sys.path.insert(0, src_path)
if backend_path not in sys.path:
    sys.path.insert(0, backend_path)

# ========== VIRTUAL ENVIRONMENT ==========
# Activate virtual environment (if it exists)
venv_path = f'{backend_path}/venv'
activate_this = f'{venv_path}/bin/activate_this.py'

# Try to activate virtualenv (for older Python versions)
if os.path.exists(activate_this):
    with open(activate_this) as f:
        exec(f.read(), {'__file__': activate_this})
else:
    # For Python 3.3+, just add site-packages to path
    site_packages = f'{venv_path}/lib/python3.10/site-packages'
    if os.path.exists(site_packages) and site_packages not in sys.path:
        sys.path.insert(0, site_packages)

# ========== ENVIRONMENT VARIABLES ==========
# Set environment variables
os.environ['ALLOWED_ORIGINS'] = '*'  # Change to your Vercel URL in production
# Uncomment and set your OpenAI API key if using AI features:
# os.environ['OPENAI_API_KEY'] = 'sk-your-key-here'

# ========== LOAD .ENV FILE (if exists) ==========
env_file = f'{backend_path}/.env'
if os.path.exists(env_file):
    with open(env_file) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                os.environ[key.strip()] = value.strip()

# ========== IMPORT FASTAPI APP ==========
try:
    from main import app as application
except ImportError as e:
    # Fallback: try importing with full path
    import importlib.util
    spec = importlib.util.spec_from_file_location("main", f"{src_path}/main.py")
    main_module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(main_module)
    application = main_module.app

# PythonAnywhere needs the app to be called 'application'
# The 'application' variable is now set and ready to use
