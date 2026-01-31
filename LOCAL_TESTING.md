# 🧪 Local Testing Guide

Test both backend and frontend on your local machine before deploying.

## Prerequisites

- Python 3.10+ installed
- Node.js 18+ installed
- **NEW OpenAI API key** (not the exposed one!)

## Quick Start (5 minutes)

### Step 1: Get New OpenAI API Key (1 min)

⚠️ **CRITICAL:** Your old API key was exposed! Get a new one:

1. Go to https://platform.openai.com/api-keys
2. **Revoke** old keys if not already done
3. Click **"Create new secret key"**
4. **Copy** the key (starts with `sk-...`)

### Step 2: Configure Backend (1 min)

**Open:** `backend/.env`

**Update line 5** with your new key:
```env
OPENAI_API_KEY=sk-your-actual-new-key-here
```

**Save the file.**

### Step 3: Start Backend (2 min)

**Open Terminal 1 (Backend):**

```bash
# Navigate to backend
cd C:\Users\PMLS\OneDrive\Desktop\todo_phase4\backend

# Create virtual environment (first time only)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
# source venv/bin/activate

# Install dependencies (first time only)
pip install -r requirements.txt

# Start FastAPI server
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

**Expected output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

**Test it:** Open browser → http://localhost:8000

Should see:
```json
{"message": "AI Todo Chatbot is running!"}
```

### Step 4: Start Frontend (2 min)

**Open Terminal 2 (Frontend) - Keep backend running!**

```bash
# Navigate to frontend
cd C:\Users\PMLS\OneDrive\Desktop\todo_phase4\frontend

# Install dependencies (first time only)
npm install

# Start Next.js dev server
npm run dev
```

**Expected output:**
```
  ▲ Next.js 14.2.18
  - Local:        http://localhost:3000
  - Ready in 2.1s
```

**Test it:** Open browser → http://localhost:3000

Should see the **AI Todo Chatbot** interface!

## ✅ Testing Checklist

### Backend Tests

**Terminal 1 should show backend running on port 8000**

Test these endpoints in your browser:

- [ ] **Root:** http://localhost:8000/
  ```json
  {"message": "AI Todo Chatbot is running!"}
  ```

- [ ] **Health:** http://localhost:8000/health
  ```json
  {"status": "ok"}
  ```

- [ ] **Todos:** http://localhost:8000/todos
  ```json
  {"todos": []}
  ```

✅ All three working? Backend is good!

### Frontend Tests

**Terminal 2 should show frontend running on port 3000**

**Open:** http://localhost:3000

- [ ] Page loads without errors
- [ ] See "AI Todo Chatbot" header
- [ ] See empty todo list
- [ ] See chat interface

### Integration Tests

**Test 1: Add a Todo**
1. In todo input field, type: `Buy groceries`
2. Click "Add Todo"
3. ✅ Todo appears in list

**Test 2: AI Chat**
1. In chat interface, type: `Help me organize my tasks`
2. Click "Send"
3. ✅ AI responds (this uses OpenAI API)

**Test 3: CORS Working**
1. Open browser console (F12)
2. Check for errors
3. ✅ No CORS errors

## 🐛 Troubleshooting

### Backend Issues

#### Error: "OPENAI_API_KEY environment variable not set"

**Fix:**
```bash
# 1. Check backend/.env file exists
# 2. Verify OPENAI_API_KEY is set (no quotes needed)
# 3. Restart backend server
```

#### Error: "Address already in use"

**Fix:**
```bash
# Port 8000 is already in use
# Option 1: Stop other process using port 8000
# Option 2: Use different port
uvicorn src.main:app --reload --port 8001
```

#### Error: "No module named 'fastapi'"

**Fix:**
```bash
# Make sure venv is activated (you should see (venv) in terminal)
# Then install dependencies:
pip install -r requirements.txt
```

#### Error: "No module named 'dotenv'"

**Fix:**
```bash
pip install python-dotenv
```

### Frontend Issues

#### Error: "Cannot find module 'next'"

**Fix:**
```bash
# Make sure you're in frontend directory
cd frontend
npm install
```

#### Error: "Failed to fetch"

**Causes:**
1. Backend not running
2. Wrong API URL

**Fix:**
```bash
# 1. Check backend is running on port 8000
# 2. Check frontend/.env.local (if exists)
# 3. API URL should be http://localhost:8000
```

#### CORS Errors in Browser Console

**Fix:**
```bash
# 1. Check backend/.env has:
#    ALLOWED_ORIGINS=http://localhost:3000
# 2. Restart backend server
```

### Port Already in Use

**Frontend (port 3000):**
```bash
# Kill process using port 3000
# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -ti:3000 | xargs kill
```

**Backend (port 8000):**
```bash
# Windows:
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -ti:8000 | xargs kill
```

## 📝 Notes

### Development Workflow

**Both servers support hot reload:**
- Backend: Changes to `.py` files auto-restart
- Frontend: Changes to `.tsx` files auto-refresh

**Don't commit `.env`:**
- Already in `.gitignore`
- Never commit API keys!

### Environment Variables

**Backend (.env):**
```env
ALLOWED_ORIGINS=http://localhost:3000
OPENAI_API_KEY=sk-your-key
```

**Frontend (.env.local):** (optional for local dev)
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## 🎯 Success Criteria

You're ready to deploy when:

- ✅ Backend starts without errors
- ✅ Frontend starts without errors
- ✅ Can add todos
- ✅ AI chat responds
- ✅ No console errors
- ✅ Both servers restart on code changes

## 🚀 After Local Testing

Once everything works locally:

1. **Commit any changes:**
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git push origin main
   ```

2. **Deploy to Vercel:**
   Follow `VERCEL_QUICK_START.md`

## 📋 Quick Commands Reference

**Backend:**
```bash
cd backend
venv\Scripts\activate          # Windows
source venv/bin/activate       # Mac/Linux
pip install -r requirements.txt
uvicorn src.main:app --reload
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

**Both together (PowerShell):**
```powershell
# Terminal 1
cd backend; venv\Scripts\activate; uvicorn src.main:app --reload

# Terminal 2
cd frontend; npm run dev
```

Good luck! 🎉
