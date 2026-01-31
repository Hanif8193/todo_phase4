# PythonAnywhere Free Plan Setup Guide

## Problem: Free Plan Limitations
- ❌ No "Environment" section in Web tab
- ✅ Solution: Use `.env` file directly on PythonAnywhere server

## Complete Setup (5-10 minutes)

### Step 1: Revoke Old API Key (CRITICAL)
1. Go to https://platform.openai.com/api-keys
2. Find and revoke the exposed key (starts with `sk-proj-z6QibH3...`)
3. Click "Create new secret key"
4. **Copy the new key** - you'll need it in Step 3

### Step 2: Upload Code to PythonAnywhere

**Option A: Via Git (Recommended)**
```bash
# On PythonAnywhere Bash console
cd /home/Hanif6831
git clone <your-repo-url> todo_phase4
cd todo_phase4/backend
```

**Option B: Via Files Tab**
- Upload `backend` folder using Files tab

### Step 3: Create .env File on PythonAnywhere

**On PythonAnywhere Bash console:**

```bash
# Navigate to backend directory
cd /home/Hanif6831/todo_phase4/backend

# Create .env file with nano editor
nano .env
```

**Type this content** (replace with your actual values):
```
OPENAI_API_KEY=sk-your-NEW-api-key-here
ALLOWED_ORIGINS=http://localhost:3000,https://your-frontend.vercel.app
```

**Save and exit:**
- Press `Ctrl + O` (Write Out)
- Press `Enter` (Confirm)
- Press `Ctrl + X` (Exit)

**Verify the file was created:**
```bash
cat .env
```

You should see your configuration (without the actual key showing fully).

### Step 4: Create Virtual Environment

```bash
cd /home/Hanif6831/todo_phase4/backend

# Create virtual environment
mkvirtualenv --python=/usr/bin/python3.10 venv

# Verify it's activated (should see (venv) in prompt)
which python
```

### Step 5: Install Dependencies

```bash
# Make sure you're in venv
workon venv

# Install packages
pip install --upgrade pip
pip install -r requirements-pythonanywhere.txt

# Verify key packages installed
pip list | grep -E "fastapi|openai|asgiref|dotenv"
```

Expected output should include:
```
asgiref         3.7.x
fastapi         0.115.x
openai          1.50.x
python-dotenv   1.0.x
```

### Step 6: Configure Web App

Go to PythonAnywhere **Web** tab:

#### A. If Creating New Web App:
1. Click "Add a new web app"
2. Choose "Manual configuration"
3. Select **Python 3.10**
4. Click through to create

#### B. Configure Virtualenv:
In "Virtualenv" section:
```
/home/Hanif6831/todo_phase4/backend/venv
```

#### C. Configure WSGI File:
1. Click on the WSGI configuration file link (e.g., `/var/www/hanif6831_pythonanywhere_com_wsgi.py`)
2. **Delete all existing content**
3. **Paste this:**

```python
import sys
import os

# Add project paths
project_home = '/home/Hanif6831/todo_phase4/backend'
src_path = '/home/Hanif6831/todo_phase4/backend/src'
venv_path = '/home/Hanif6831/todo_phase4/backend/venv'
python_version = 'python3.10'
site_packages = os.path.join(venv_path, 'lib', python_version, 'site-packages')

for path in [project_home, src_path, site_packages]:
    if path not in sys.path:
        sys.path.insert(0, path)

# Load environment variables from .env file
from dotenv import load_dotenv
env_path = os.path.join(project_home, '.env')
load_dotenv(env_path)

# Import FastAPI app
from main import app

# Wrap ASGI for WSGI (required for FastAPI on PythonAnywhere)
from asgiref.wsgi import WsgiToAsgi
application = WsgiToAsgi(app)
```

4. Click **Save**

### Step 7: Reload Web App

Click the green **"Reload hanif6831.pythonanywhere.com"** button

### Step 8: Test Your Deployment

**Test 1: Root endpoint**
Visit: `https://hanif6831.pythonanywhere.com/`

Expected:
```json
{"message": "AI Todo Chatbot is running!"}
```

**Test 2: Health check**
Visit: `https://hanif6831.pythonanywhere.com/health`

Expected:
```json
{"status": "ok"}
```

**Test 3: Todos**
Visit: `https://hanif6831.pythonanywhere.com/todos`

Expected:
```json
{"todos": []}
```

## Troubleshooting

### Error: "OPENAI_API_KEY environment variable not set"

**Check .env file exists:**
```bash
cd /home/Hanif6831/todo_phase4/backend
ls -la .env
cat .env
```

**If missing, create it:**
```bash
nano .env
# Add: OPENAI_API_KEY=your-key
# Save: Ctrl+O, Enter, Ctrl+X
```

### Error: "No module named 'asgiref'"

**Install it:**
```bash
cd /home/Hanif6831/todo_phase4/backend
workon venv
pip install asgiref>=3.7.0
```

Then reload web app.

### Error: "No module named 'main'"

**Check paths in WSGI file:**
```bash
# Verify these paths exist:
ls /home/Hanif6831/todo_phase4/backend/src/main.py
ls /home/Hanif6831/todo_phase4/backend/venv/
```

### Error: "TypeError: FastAPI.__call__() missing 'send'"

**Cause:** Not using ASGI adapter

**Fix:** Make sure your WSGI file has:
```python
from asgiref.wsgi import WsgiToAsgi
application = WsgiToAsgi(app)
```

### Check Error Logs

```bash
# View last 50 lines
tail -n 50 /var/log/hanif6831.pythonanywhere.com.error.log

# Watch logs in real-time
tail -f /var/log/hanif6831.pythonanywhere.com.error.log
```

## Security Checklist

- [ ] Old API key revoked ✓
- [ ] New API key created ✓
- [ ] `.env` file created on PythonAnywhere (not in git) ✓
- [ ] `.env` is in `.gitignore` ✓
- [ ] Never commit `.env` to git repository ✓

## File Structure on PythonAnywhere

```
/home/Hanif6831/
└── todo_phase4/
    └── backend/
        ├── .env                 ← Created manually (NOT in git)
        ├── wsgi.py              ← Updated with ASGI adapter
        ├── requirements-pythonanywhere.txt
        ├── venv/                ← Virtual environment
        └── src/
            ├── main.py
            └── connection.py
```

## Updating Your Deployment

**When you make code changes:**

```bash
# On PythonAnywhere
cd /home/Hanif6831/todo_phase4
git pull origin main
cd backend
workon venv
pip install -r requirements-pythonanywhere.txt
# Then reload web app via Web tab
```

**IMPORTANT:** Never pull or commit the `.env` file - it should only exist on PythonAnywhere!

## Success Indicators

✅ No errors in `/var/log/hanif6831.pythonanywhere.com.error.log`
✅ Root URL shows: `{"message": "AI Todo Chatbot is running!"}`
✅ `/health` returns: `{"status": "ok"}`
✅ `/todos` returns: `{"todos": []}`

## Next Steps

1. Update your frontend to use: `https://hanif6831.pythonanywhere.com`
2. Add your actual Vercel URL to `ALLOWED_ORIGINS` in `.env`
3. Test end-to-end functionality
4. Monitor error logs for any issues

## Quick Reference Commands

```bash
# Activate venv
workon venv

# Check if in venv
which python

# Install packages
pip install -r requirements-pythonanywhere.txt

# View logs
tail -f /var/log/hanif6831.pythonanywhere.com.error.log

# Edit .env
nano /home/Hanif6831/todo_phase4/backend/.env

# Test Python imports
cd /home/Hanif6831/todo_phase4/backend
python3 -c "import sys; sys.path.insert(0, 'src'); from main import app; print('Success!')"
```

## Getting Help

If stuck, share:
1. Latest error log (last 20 lines)
2. Result of `pip list | grep -E "fastapi|openai|asgiref"`
3. Result of `cat /home/Hanif6831/todo_phase4/backend/.env` (hide the actual API key!)
