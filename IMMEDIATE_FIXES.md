# Immediate Fixes for PythonAnywhere Deployment

## Current Error
```
ValueError: OPENAI_API_KEY environment variable not set
```

## Quick Fix (5 minutes)

### Step 1: Go to PythonAnywhere Web Tab
Login to [PythonAnywhere](https://www.pythonanywhere.com) → Web tab

### Step 2: Add Environment Variables
Scroll to **"Environment"** section and add:

```
Name: OPENAI_API_KEY
Value: [Paste your actual OpenAI API key here]
```

```
Name: ALLOWED_ORIGINS
Value: http://localhost:3000,https://your-vercel-app.vercel.app
```

⚠️ **Important**: Replace `https://your-vercel-app.vercel.app` with your actual frontend URL

### Step 3: Verify Virtual Environment Settings
In **"Virtualenv"** section, ensure path is:
```
/home/Hanif6831/todo_phase4/backend/venv
```

OR (if you created it with mkvirtualenv):
```
/home/Hanif6831/.virtualenvs/venv
```

### Step 4: Reload Web App
Click the green **"Reload hanif6831.pythonanywhere.com"** button at the top

### Step 5: Test
Visit: `https://hanif6831.pythonanywhere.com/`

You should see:
```json
{"message": "AI Todo Chatbot is running!"}
```

## If Still Getting Errors

### Check Error Logs
On PythonAnywhere, open a Bash console:
```bash
tail -n 50 /var/log/hanif6831.pythonanywhere.com.error.log
```

### Verify Dependencies Are Installed
```bash
cd /home/Hanif6831/todo_phase4/backend
workon venv  # or: source venv/bin/activate
pip list | grep -E "fastapi|openai|dotenv"
```

If packages are missing:
```bash
pip install -r requirements-pythonanywhere.txt
```
Then reload the web app again.

### Test Import Manually
```bash
cd /home/Hanif6831/todo_phase4/backend
python3 << EOF
import sys
import os
sys.path.insert(0, '/home/Hanif6831/todo_phase4/backend/src')
os.environ['OPENAI_API_KEY'] = 'test-key'  # Temporary test
from main import app
print("✅ Success!")
EOF
```

## Common Issues

| Error | Cause | Fix |
|-------|-------|-----|
| `No module named 'openai'` | Dependencies not installed | Run: `pip install -r requirements-pythonanywhere.txt` |
| `OPENAI_API_KEY not set` | Env var not configured | Add in Web → Environment section |
| `ModuleNotFoundError: main` | WSGI path wrong | Check wsgi.py has correct paths |
| CORS errors | Frontend URL not in ALLOWED_ORIGINS | Add your Vercel URL to environment variable |

## Need Your OpenAI API Key?

1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign in
3. Create new secret key
4. Copy and paste into PythonAnywhere environment variable

## Success Checklist

- [ ] Virtual environment created (`/home/Hanif6831/todo_phase4/backend/venv`)
- [ ] Dependencies installed (openai, fastapi, pydantic, python-dotenv)
- [ ] OPENAI_API_KEY set in Web → Environment
- [ ] ALLOWED_ORIGINS set in Web → Environment
- [ ] WSGI file configured correctly
- [ ] Web app reloaded
- [ ] Visit site and see success message
- [ ] Test `/health` endpoint works
- [ ] Test `/todos` endpoint works

## Next Steps After Deployment

1. Update frontend to point to `https://hanif6831.pythonanywhere.com`
2. Test end-to-end functionality
3. Monitor error logs for issues
4. Set up proper CORS with actual frontend URL

## Getting Help

If still stuck, share:
1. Latest error log: `tail -n 100 /var/log/hanif6831.pythonanywhere.com.error.log`
2. Package list: `pip list`
3. Python path test results
