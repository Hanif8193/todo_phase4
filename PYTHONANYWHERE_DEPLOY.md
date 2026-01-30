# Deploy to PythonAnywhere (100% Free - No Credit Card)

## Why PythonAnywhere?
- **Completely FREE** forever
- No credit card required
- Perfect for small projects
- Easy setup

## Limitations
- Free tier: 1 web app only
- Limited CPU time (can be enough for demos)
- Your URL will be: `username.pythonanywhere.com`

---

## Step-by-Step Deployment

### 1. Sign Up
1. Go to https://www.pythonanywhere.com
2. Click "Start running Python online in less than a minute"
3. Create a free "Beginner" account
4. Verify your email

### 2. Upload Your Code

**Option A: Using Git (Recommended)**

1. Click "Consoles" tab
2. Start a new "Bash" console
3. In the console, run:

```bash
git clone https://github.com/YOUR-USERNAME/todo_pase4.git
cd todo_pase4/backend
```

**Option B: Manual Upload**
1. Click "Files" tab
2. Navigate to your home directory
3. Create `todo_pase4/backend` folders
4. Upload your backend files

### 3. Install Dependencies

In the Bash console:

```bash
cd ~/todo_pase4/backend
pip3.10 install --user -r requirements.txt
```

### 4. Create Web App

1. Go to "Web" tab
2. Click "Add a new web app"
3. Click "Next"
4. Choose "Manual configuration"
5. Select "Python 3.10"
6. Click "Next"

### 5. Configure WSGI File

1. In the "Web" tab, find "Code" section
2. Click on the WSGI configuration file link
3. Delete everything and replace with:

```python
import sys
import os

# Add your project directory to the sys.path
project_home = '/home/YOUR_USERNAME/todo_pase4/backend/src'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Set environment variables
os.environ['ALLOWED_ORIGINS'] = '*'  # Update with your Vercel URL later
# os.environ['OPENAI_API_KEY'] = 'your-key'  # Uncomment if needed

# Import the FastAPI app
from main import app as application
```

**Replace `YOUR_USERNAME`** with your PythonAnywhere username!

6. Click "Save"

### 6. Set Virtual Environment (Optional but Recommended)

1. In "Web" tab, find "Virtualenv" section
2. Enter: `/home/YOUR_USERNAME/.local`
3. (Or create a proper virtualenv if you prefer)

### 7. Reload Web App

1. Scroll to top of "Web" tab
2. Click the big green "Reload" button
3. Wait ~10 seconds

### 8. Test Your API

Your API is now live at:
- `https://YOUR_USERNAME.pythonanywhere.com/health`
- `https://YOUR_USERNAME.pythonanywhere.com/docs`

### 9. Deploy Frontend to Vercel

1. Go to https://vercel.com
2. Import your repository
3. Set "Root Directory" to `frontend`
4. Add environment variable:
   - Name: `NEXT_PUBLIC_API_URL`
   - Value: `https://YOUR_USERNAME.pythonanywhere.com`
5. Deploy

### 10. Update CORS

Edit your WSGI file again:
```python
os.environ['ALLOWED_ORIGINS'] = 'https://your-app.vercel.app'
```

Click "Reload" on the Web tab.

---

## Troubleshooting

### 502 Bad Gateway
- Check WSGI file has correct username
- Check all paths are correct
- Look at error log (Web tab → Log files → Error log)

### Import Errors
- Make sure you ran `pip3.10 install --user -r requirements.txt`
- Check requirements.txt exists in backend folder
- Try installing packages individually

### CORS Errors
- Update `ALLOWED_ORIGINS` in WSGI file
- Reload web app after changes
- Make sure to include `https://` in the URL

---

## Free Tier Limits
- 1 web app
- 512MB disk space
- Limited CPU seconds/day (usually enough for demos)
- Custom domains not available on free tier

---

**Setup Time**: 15-20 minutes
**Cost**: $0 forever
**Perfect for**: Demos, learning, small projects
