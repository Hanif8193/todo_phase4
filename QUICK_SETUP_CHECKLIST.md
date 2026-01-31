# Quick Setup Checklist for Free PythonAnywhere

Copy these commands and run them in order.

## 1. Revoke Old Key & Get New One
- [ ] Go to https://platform.openai.com/api-keys
- [ ] Revoke old key: `sk-proj-z6QibH3...`
- [ ] Create new secret key
- [ ] Copy new key to clipboard

## 2. Create .env File on PythonAnywhere

```bash
cd /home/Hanif6831/todo_phase4/backend
nano .env
```

Paste this (replace with YOUR values):
```
OPENAI_API_KEY=sk-your-NEW-key-here
ALLOWED_ORIGINS=http://localhost:3000,https://your-app.vercel.app
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

## 3. Install Dependencies

```bash
cd /home/Hanif6831/todo_phase4/backend
mkvirtualenv --python=/usr/bin/python3.10 venv
pip install --upgrade pip
pip install -r requirements-pythonanywhere.txt
```

Verify:
```bash
pip list | grep -E "asgiref|fastapi|openai|dotenv"
```

## 4. Update WSGI File

Go to Web tab → Click WSGI configuration file link

Delete all content, paste this:

```python
import sys
import os

project_home = '/home/Hanif6831/todo_phase4/backend'
src_path = '/home/Hanif6831/todo_phase4/backend/src'
venv_path = '/home/Hanif6831/todo_phase4/backend/venv'
python_version = 'python3.10'
site_packages = os.path.join(venv_path, 'lib', python_version, 'site-packages')

for path in [project_home, src_path, site_packages]:
    if path not in sys.path:
        sys.path.insert(0, path)

from dotenv import load_dotenv
env_path = os.path.join(project_home, '.env')
load_dotenv(env_path)

from main import app
from asgiref.wsgi import WsgiToAsgi
application = WsgiToAsgi(app)
```

Save the file.

## 5. Set Virtualenv Path

Web tab → Virtualenv section:
```
/home/Hanif6831/todo_phase4/backend/venv
```

## 6. Reload & Test

- [ ] Click green "Reload" button
- [ ] Wait 30 seconds
- [ ] Visit: `https://hanif6831.pythonanywhere.com/`
- [ ] Should see: `{"message": "AI Todo Chatbot is running!"}`

## Success! ✅

Your app is live at: `https://hanif6831.pythonanywhere.com/`

---

## If Something Goes Wrong

Check logs:
```bash
tail -n 50 /var/log/hanif6831.pythonanywhere.com.error.log
```

Common fixes:
- Missing package: `pip install <package-name>`
- Wrong path: Check WSGI file paths match your structure
- Can't find .env: Make sure it's in `/home/Hanif6831/todo_phase4/backend/.env`
