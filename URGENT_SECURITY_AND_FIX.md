# 🚨 URGENT: Security Issue + Deployment Fix

## STEP 1: REVOKE EXPOSED API KEY (DO THIS NOW!)

Your OpenAI API key was exposed in the error logs. You must:

1. Go to [OpenAI API Keys](https://platform.openai.com/api-keys)
2. Find the key starting with `sk-proj-z6QibH3...`
3. Click "Revoke" or delete it
4. Create a new secret key
5. Save the new key securely

## STEP 2: Fix PythonAnywhere Deployment

### Problem
FastAPI is an ASGI app, but PythonAnywhere uses WSGI. You need an adapter.

### Solution

#### A. Install Missing Package

On PythonAnywhere Bash console:

```bash
cd /home/Hanif6831/todo_phase4/backend
workon venv  # or: source venv/bin/activate
pip install asgiref>=3.7.0
```

#### B. Upload New Files

Upload these updated files to PythonAnywhere:
- `backend/wsgi.py` (updated with ASGI adapter)
- `backend/requirements-pythonanywhere.txt` (added asgiref)

**Via Git:**
```bash
cd /home/Hanif6831/todo_phase4
git pull origin main
cd backend
pip install -r requirements-pythonanywhere.txt
```

**Or manually:** Use Files tab to upload the new wsgi.py

#### C. Set Environment Variables SECURELY

⚠️ **NEVER put API keys in code files!**

On PythonAnywhere Web tab → "Environment" section:

```
OPENAI_API_KEY    your-new-api-key-here
ALLOWED_ORIGINS   http://localhost:3000,https://your-app.vercel.app
```

#### D. Update WSGI Configuration File Path

On Web tab → "Code" section:

**WSGI configuration file:** Click the link and replace ALL content with:

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

# Import FastAPI app
from main import app

# Wrap ASGI for WSGI
from asgiref.wsgi import WsgiToAsgi
application = WsgiToAsgi(app)
```

#### E. Reload Web App

Click the green **"Reload"** button

## STEP 3: Test

Visit: `https://hanif6831.pythonanywhere.com/`

Expected response:
```json
{"message": "AI Todo Chatbot is running!"}
```

Test health endpoint:
```
https://hanif6831.pythonanywhere.com/health
```

## Common Errors After This Fix

### Error: "No module named 'asgiref'"
**Solution:**
```bash
pip install asgiref
```

### Error: "OPENAI_API_KEY not set"
**Solution:** Add it in Web tab → Environment section (not in code!)

### Error: Still seeing old errors
**Solution:**
1. Clear browser cache
2. Reload web app on PythonAnywhere
3. Wait 30 seconds for changes to propagate

## Security Best Practices

✅ **DO:**
- Set API keys in PythonAnywhere Environment section
- Use `.env` files locally (never commit them)
- Add `.env` to `.gitignore`
- Rotate API keys regularly

❌ **DON'T:**
- Hardcode API keys in Python files
- Commit `.env` files to git
- Share API keys in chat/logs
- Use the same key for dev and production

## Verification Checklist

- [ ] Old API key revoked
- [ ] New API key generated
- [ ] `asgiref` installed in virtual environment
- [ ] New `wsgi.py` uploaded to PythonAnywhere
- [ ] WSGI config file updated with ASGI adapter
- [ ] Environment variables set in Web tab (not code)
- [ ] Virtual environment path set: `/home/Hanif6831/todo_phase4/backend/venv`
- [ ] Web app reloaded
- [ ] Root URL returns success message
- [ ] `/health` endpoint works
- [ ] No errors in error log

## Check Logs

```bash
tail -n 50 /var/log/hanif6831.pythonanywhere.com.error.log
```

If you see "AI Todo Chatbot is running!" - you're done! 🎉

## Still Having Issues?

Share the latest 20 lines from error log:
```bash
tail -n 20 /var/log/hanif6831.pythonanywhere.com.error.log
```
