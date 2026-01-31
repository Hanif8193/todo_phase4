#!/bin/bash
# PythonAnywhere Deployment Script
# Run this on PythonAnywhere Bash console

set -e  # Exit on error

echo "🚀 Starting PythonAnywhere Deployment..."

# Configuration
PROJECT_DIR="/home/Hanif6831/todo_phase4/backend"
VENV_NAME="venv"
PYTHON_VERSION="3.10"

# Navigate to project
cd "$PROJECT_DIR"
echo "📁 Working directory: $(pwd)"

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_NAME" ]; then
    echo "🔧 Creating virtual environment..."
    mkvirtualenv --python=/usr/bin/python$PYTHON_VERSION $VENV_NAME
else
    echo "✅ Virtual environment exists"
    workon $VENV_NAME
fi

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "📦 Installing dependencies..."
if [ -f "requirements-pythonanywhere.txt" ]; then
    pip install -r requirements-pythonanywhere.txt
elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "❌ No requirements file found!"
    exit 1
fi

# Verify installations
echo "🔍 Verifying key packages..."
pip list | grep -E "fastapi|uvicorn|openai|pydantic|dotenv" || echo "⚠️  Some packages may be missing"

# Test imports
echo "🧪 Testing imports..."
python3 << 'EOF'
import sys
sys.path.insert(0, '/home/Hanif6831/todo_phase4/backend/src')
try:
    from main import app
    print("✅ Import successful!")
except Exception as e:
    print(f"❌ Import failed: {e}")
    sys.exit(1)
EOF

echo "
✅ Deployment preparation complete!

⚠️  NEXT STEPS (Manual):
1. Go to PythonAnywhere Web tab
2. Set environment variables:
   - OPENAI_API_KEY=<your-key>
   - ALLOWED_ORIGINS=<your-frontend-url>
3. Configure WSGI file path: /home/Hanif6831/todo_phase4/backend/wsgi.py
4. Set virtualenv path: /home/Hanif6831/todo_phase4/backend/venv
5. Click 'Reload' button

📊 Check logs at:
   /var/log/hanif6831.pythonanywhere.com.error.log
"
