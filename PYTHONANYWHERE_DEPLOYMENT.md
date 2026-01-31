# PythonAnywhere Deployment Checklist

## Prerequisites
- PythonAnywhere account (username: Hanif6831)
- OpenAI API key
- Frontend deployed URL (for CORS)

## Deployment Steps

### 1. Upload Code to PythonAnywhere

**Option A: Git (Recommended)**
```bash
cd /home/Hanif6831
git clone <your-repo-url> todo_phase4
cd todo_phase4/backend
```

**Option B: Upload files**
- Use PythonAnywhere Files tab to upload backend folder

### 2. Create Virtual Environment

```bash
cd /home/Hanif6831/todo_phase4/backend
mkvirtualenv --python=/usr/bin/python3.10 venv
```

Verify:
```bash
which python  # Should show: /home/Hanif6831/.virtualenvs/venv/bin/python
python --version  # Should show: Python 3.10.x
```

### 3. Install Dependencies

```bash
workon venv
pip install --upgrade pip
pip install -r requirements-pythonanywhere.txt
```

Verify installation:
```bash
pip list | grep -E "fastapi|uvicorn|openai|pydantic|dotenv"
```

Expected output:
```
fastapi>=0.115.0
openai>=1.50.0
pydantic>=2.9.0
python-dotenv>=1.0.0
uvicorn>=0.32.0
```

### 4. Configure Web App

Go to PythonAnywhere **Web** tab:

#### A. Create New Web App
- Click "Add a new web app"
- Choose "Manual configuration"
- Select Python 3.10

#### B. Set Virtual Environment
- In "Virtualenv" section
- Enter: `/home/Hanif6831/.virtualenvs/venv`
- Or: `/home/Hanif6831/todo_phase4/backend/venv` (if created locally)

#### C. Configure WSGI File
- Click on WSGI configuration file link
- Replace content with the wsgi.py from your repo
- Or manually copy from: `/home/Hanif6831/todo_phase4/backend/wsgi.py`

#### D. Set Environment Variables
In "Environment" section of Web tab, add:
```
OPENAI_API_KEY=sk-your-actual-key-here
ALLOWED_ORIGINS=http://localhost:3000,https://your-app.vercel.app
```

### 5. Configure Static Files (if needed)

In Web tab → Static files section:
- URL: `/static/`
- Directory: `/home/Hanif6831/todo_phase4/backend/static/`

### 6. Reload Web App

Click the green "Reload" button on Web tab.

### 7. Test Deployment

Visit your app URL: `https://hanif6831.pythonanywhere.com`

Test endpoints:
```bash
# Health check
curl https://hanif6831.pythonanywhere.com/

# API test
curl https://hanif6831.pythonanywhere.com/api/todos
```

## Troubleshooting

### Check Error Logs
```bash
# View recent errors
tail -f /var/log/hanif6831.pythonanywhere.com.error.log

# View server logs
tail -f /var/log/hanif6831.pythonanywhere.com.server.log
```

### Common Issues

#### 1. ModuleNotFoundError
**Cause**: Virtual environment not activated or packages not installed
**Fix**:
```bash
workon venv
cd /home/Hanif6831/todo_phase4/backend
pip install -r requirements-pythonanywhere.txt
```

#### 2. OPENAI_API_KEY not set
**Cause**: Environment variable not configured
**Fix**: Add variable in Web tab → Environment section (not in .env file)

#### 3. Import errors for 'main' or 'connection'
**Cause**: Python path not configured correctly
**Fix**: Verify wsgi.py has correct paths:
```python
project_home = '/home/Hanif6831/todo_phase4/backend'
src_path = '/home/Hanif6831/todo_phase4/backend/src'
```

#### 4. CORS errors
**Cause**: ALLOWED_ORIGINS not set or frontend URL not included
**Fix**: Update ALLOWED_ORIGINS environment variable with your Vercel URL

### Manual Debugging

```bash
# Test Python imports
cd /home/Hanif6831/todo_phase4/backend
workon venv
python3 << EOF
import sys
sys.path.insert(0, '/home/Hanif6831/todo_phase4/backend/src')
from main import app
print("Import successful!")
EOF
```

## Post-Deployment

### Update Code
```bash
cd /home/Hanif6831/todo_phase4
git pull origin main
workon venv
pip install -r backend/requirements-pythonanywhere.txt
# Reload web app via Web tab
```

### Monitor Logs
Set up log monitoring in a console:
```bash
tail -f /var/log/hanif6831.pythonanywhere.com.error.log
```

## Security Notes

1. **Never commit .env file** with actual API keys
2. **Use PythonAnywhere environment variables** for secrets
3. **Keep requirements.txt updated** with exact versions
4. **Set ALLOWED_ORIGINS** to specific domains (not *)

## Resources

- [PythonAnywhere Help](https://help.pythonanywhere.com/)
- [Debugging Import Errors](https://help.pythonanywhere.com/pages/DebuggingImportError/)
- [FastAPI on PythonAnywhere](https://help.pythonanywhere.com/pages/FastAPI/)
