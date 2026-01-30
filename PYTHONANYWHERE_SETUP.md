# PythonAnywhere Deployment Guide

## Step 1: Upload Your Project

### Option A: Using Git (Recommended)
```bash
# In PythonAnywhere Bash console
cd ~
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
```

### Option B: Upload Files Manually
- Use the PythonAnywhere Files interface to upload your project

## Step 2: Create Virtual Environment

```bash
# Navigate to your project
cd ~/todo_pase4/backend

# Create virtual environment
python3.10 -m venv venv

# Activate it
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

## Step 3: Configure Environment Variables

```bash
# Create .env file
cd ~/todo_pase4/backend
nano .env
```

Add these variables:
```
ALLOWED_ORIGINS=*
OPENAI_API_KEY=your-openai-api-key-here
```

Save and exit (Ctrl+X, then Y, then Enter)

## Step 4: Configure Web App

1. Go to PythonAnywhere **Web** tab
2. Click **Add a new web app**
3. Select **Manual configuration** (NOT Flask/Django)
4. Choose **Python 3.10**

## Step 5: Update WSGI Configuration

1. In the Web tab, find **WSGI configuration file** link
2. Click it to open the editor
3. **Delete all existing content**
4. Copy the entire content from `backend/pythonanywhere_wsgi.py`
5. Paste it into the WSGI file
6. **IMPORTANT**: Update these lines at the top:
   ```python
   USERNAME = 'Hanif6831'  # Your actual PythonAnywhere username
   PROJECT_NAME = 'todo_pase4'  # Your project folder name
   ```
7. Save the file (Ctrl+S or click Save button)

## Step 6: Configure Static Files (Optional)

If you have static files:
1. In the Web tab, scroll to **Static files** section
2. Add:
   - URL: `/static/`
   - Directory: `/home/Hanif6831/todo_pase4/backend/static/`

## Step 7: Set Virtual Environment Path

1. In the Web tab, find **Virtualenv** section
2. Enter: `/home/Hanif6831/todo_pase4/backend/venv`
3. Make sure this path is **exactly correct**

## Step 8: Reload Web App

1. Scroll to top of Web tab
2. Click the big green **Reload** button
3. Wait for reload to complete

## Step 9: Test Your API

Visit your PythonAnywhere URL:
- `https://hanif6831.pythonanywhere.com/`
- `https://hanif6831.pythonanywhere.com/health`
- `https://hanif6831.pythonanywhere.com/todos`

## Troubleshooting

### Error: FileNotFoundError for activate_this.py

**Solution**: This is normal for Python 3.3+. The updated WSGI file handles this automatically.

### Error: Module not found

**Solutions**:
1. Check virtual environment is created:
   ```bash
   ls ~/todo_pase4/backend/venv/bin/
   ```

2. Reinstall dependencies:
   ```bash
   cd ~/todo_pase4/backend
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. Check WSGI file paths match your actual folder structure

### Error: Application failed to start

1. Check error log in Web tab
2. Verify paths in WSGI file:
   - Username is correct
   - Project name matches folder name (`todo_pase4` not `todo_phase4`)
3. Check Python version in Web tab matches requirements (3.10)

### Check Logs

View error logs in PythonAnywhere:
1. Go to **Web** tab
2. Scroll to **Log files** section
3. Click on **Error log** to see recent errors
4. Click on **Server log** to see access logs

## Update Your Application

To update after making changes:

```bash
# Pull latest changes
cd ~/todo_pase4
git pull origin main

# Update dependencies if needed
cd backend
source venv/bin/activate
pip install -r requirements.txt --upgrade

# Reload web app
# Go to Web tab and click Reload button
```

## Environment Variables for Production

Update `.env` file:
```bash
cd ~/todo_pase4/backend
nano .env
```

Set proper values:
```
ALLOWED_ORIGINS=https://your-frontend-domain.vercel.app
OPENAI_API_KEY=sk-your-real-api-key
```

## Security Notes

1. **Never commit `.env` file** to git (already in `.gitignore`)
2. **Set specific CORS origins** in production (not `*`)
3. **Keep API keys secret** - use PythonAnywhere environment variables if possible
4. **Use HTTPS** (automatically provided by PythonAnywhere)

## Common Issues

### Issue: Wrong folder name
- Error log shows: `/home/Hanif6831/todo_phase4/...`
- Your actual folder: `todo_pase4`
- **Fix**: Update `PROJECT_NAME` in WSGI file to match exactly

### Issue: Virtual environment not found
- **Fix**: Make sure path in Web tab's Virtualenv section is correct
- Should be: `/home/Hanif6831/todo_pase4/backend/venv`

### Issue: Import errors
- **Fix**: Check `sys.path` in WSGI file includes both `backend` and `backend/src`
- The updated WSGI file handles this automatically

## Need Help?

- Check PythonAnywhere forums: https://www.pythonanywhere.com/forums/
- Review error logs in Web tab
- Verify all paths match your actual folder structure
