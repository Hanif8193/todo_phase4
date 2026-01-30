# Fix PythonAnywhere Deployment

## Your Issue
The import error happens because PythonAnywhere's WSGI file isn't configured correctly.

## Quick Fix - Follow These Steps

### Step 1: Upload All Files (if not done)

Make sure these files are uploaded to PythonAnywhere:
- `~/todo_phase4/backend/src/main.py`
- `~/todo_phase4/backend/src/connection.py`
- `~/todo_phase4/backend/requirements.txt`

### Step 2: Install Dependencies

In a PythonAnywhere Bash console:

```bash
cd ~/todo_phase4/backend
pip3.10 install --user -r requirements.txt
```

**Important**: This will take a few minutes. Wait for it to complete.

### Step 3: Fix WSGI Configuration

1. Go to the **Web** tab in PythonAnywhere
2. Find the **"Code"** section
3. Click on the **WSGI configuration file** link (should be something like `/var/www/Hanif6831_pythonanywhere_com_wsgi.py`)
4. **Delete everything** in that file
5. **Copy and paste this exactly**:

```python
# +++++++++++ PYTHONANYWHERE WSGI CONFIGURATION +++++++++++
import sys
import os

# Add your project directory to the sys.path
username = 'Hanif6831'  # Your PythonAnywhere username
project_home = f'/home/{username}/todo_phase4/backend/src'

if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Set environment variables
os.environ['ALLOWED_ORIGINS'] = '*'  # Update with Vercel URL later

# Import the FastAPI app
from main import app as application
```

6. Click **Save** (top right)

### Step 4: Reload Web App

1. Go back to the **Web** tab
2. Scroll to the top
3. Click the big green **"Reload"** button
4. Wait 10 seconds

### Step 5: Test Your Backend

Visit these URLs in your browser:
- `https://Hanif6831.pythonanywhere.com/health`
- `https://Hanif6831.pythonanywhere.com/docs`

You should see:
- `/health` → `{"status":"ok"}`
- `/docs` → Interactive API documentation

---

## If You Still Get Errors

### Check Error Logs

1. Go to **Web** tab
2. Find **"Log files"** section
3. Click **"Error log"**
4. Look at the bottom for recent errors
5. Share the error with me

### Common Issues

**Issue**: Still getting ModuleNotFoundError

**Solution**: Make sure the path in WSGI file matches your actual directory:
```bash
# In Bash console, run:
ls -la ~/todo_phase4/backend/src/

# You should see:
# main.py
# connection.py
```

If files are in a different location, update the `project_home` path in WSGI file.

---

**Issue**: ImportError: No module named 'fastapi'

**Solution**: Dependencies not installed. Run:
```bash
cd ~/todo_phase4/backend
pip3.10 install --user fastapi uvicorn pydantic python-dotenv
```

---

**Issue**: 502 Bad Gateway

**Solution**:
1. Check WSGI file has correct username
2. Check paths match your directory structure
3. Look at error log for specific error

---

## After Backend Works

### Deploy Frontend to Vercel

1. Go to https://vercel.com
2. New Project → Import your repository
3. **Root Directory**: `frontend`
4. **Environment Variable**:
   - Name: `NEXT_PUBLIC_API_URL`
   - Value: `https://Hanif6831.pythonanywhere.com`
5. Deploy

### Update CORS

After getting your Vercel URL, update the WSGI file:

Change this line:
```python
os.environ['ALLOWED_ORIGINS'] = '*'
```

To this:
```python
os.environ['ALLOWED_ORIGINS'] = 'https://your-app.vercel.app'
```

Then click **Reload** on the Web tab.

---

## Complete Setup Checklist

- [ ] Files uploaded to `~/todo_phase4/backend/src/`
- [ ] Dependencies installed with `pip3.10 install --user -r requirements.txt`
- [ ] WSGI file updated with correct configuration
- [ ] Web app reloaded
- [ ] `/health` endpoint returns `{"status":"ok"}`
- [ ] `/docs` shows API documentation
- [ ] Frontend deployed to Vercel
- [ ] CORS updated with Vercel URL
- [ ] Full app tested and working

---

## Need Help?

If you're still stuck, share:
1. The error from the Error log (Web tab → Log files → Error log)
2. Screenshot of your Web tab configuration
3. Output of: `ls -la ~/todo_phase4/backend/src/`

I'll help you debug!
