# Complete Deployment Guide: Frontend (Vercel) + Backend (Render/Railway)

This guide walks you through deploying your AI Todo Chatbot with the frontend on Vercel and backend on Render or Railway.

## Overview

- **Frontend**: Next.js 14 deployed to Vercel
- **Backend**: FastAPI deployed to Render (recommended) or Railway
- **Total Setup Time**: ~20-30 minutes

## Prerequisites

- [ ] Git repository with your code
- [ ] GitHub account (or GitLab/Bitbucket)
- [ ] Code pushed to repository

## Part 1: Deploy Backend (Choose One)

### Option A: Render (Recommended)

Render offers an easy deployment with a generous free tier.

#### Step 1: Sign Up
1. Go to [render.com](https://render.com)
2. Sign up with GitHub (easiest)

#### Step 2: Create Web Service
1. Click "New +" → "Web Service"
2. Connect your repository
3. Select your `todo_pase4` repository

#### Step 3: Configure
Fill in these settings:
- **Name**: `todo-chatbot-backend`
- **Region**: Select closest to you
- **Branch**: `main`
- **Root Directory**: `backend`
- **Runtime**: `Python 3`
- **Build Command**: `pip install -r requirements.txt`
- **Start Command**: `cd src && uvicorn main:app --host 0.0.0.0 --port $PORT`

#### Step 4: Environment Variables
Click "Advanced" → Add Environment Variables:

| Key | Value |
|-----|-------|
| `PYTHON_VERSION` | `3.11.0` |
| `ALLOWED_ORIGINS` | `https://your-app.vercel.app` (update after frontend deployment) |
| `OPENAI_API_KEY` | Your OpenAI key (if using AI features) |

#### Step 5: Deploy
1. Click "Create Web Service"
2. Wait 3-5 minutes for deployment
3. Copy your backend URL (e.g., `https://todo-chatbot-backend.onrender.com`)

#### Step 6: Test Backend
Visit in browser:
- Health: `https://your-backend.onrender.com/health`
- Docs: `https://your-backend.onrender.com/docs`

You should see `{"status":"ok"}` for health.

### Option B: Railway

Railway provides $5 free credit monthly.

#### Step 1: Sign Up
1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub

#### Step 2: Create Project
1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Select your repository

#### Step 3: Configure
1. Click on the service created
2. Go to "Settings"
3. Set **Root Directory**: `backend` (if needed)

#### Step 4: Environment Variables
Go to "Variables" tab and add:

| Key | Value |
|-----|-------|
| `ALLOWED_ORIGINS` | `https://your-app.vercel.app` |
| `OPENAI_API_KEY` | Your OpenAI key |

#### Step 5: Deploy
1. Railway deploys automatically
2. Go to "Settings" → "Generate Domain"
3. Copy your domain (e.g., `your-app.up.railway.app`)

#### Step 6: Test Backend
Visit:
- Health: `https://your-app.up.railway.app/health`
- Docs: `https://your-app.up.railway.app/docs`

---

## Part 2: Deploy Frontend to Vercel

### Using Vercel Dashboard (Easier)

#### Step 1: Sign Up
1. Go to [vercel.com](https://vercel.com)
2. Sign up with GitHub

#### Step 2: Import Project
1. Click "Add New..." → "Project"
2. Import your Git repository
3. Select your repository

#### Step 3: Configure
- **Framework Preset**: Next.js (auto-detected)
- **Root Directory**: `frontend` ⚠️ Important!
- **Build Command**: `npm run build` (default)
- **Output Directory**: `.next` (default)
- **Install Command**: `npm install` (default)

#### Step 4: Environment Variables
Before deploying, add this variable:

| Name | Value |
|------|-------|
| `NEXT_PUBLIC_API_URL` | Your backend URL from Part 1 |

Example: `https://todo-chatbot-backend.onrender.com`

#### Step 5: Deploy
1. Click "Deploy"
2. Wait 2-3 minutes
3. Copy your Vercel URL (e.g., `https://todo-chatbot.vercel.app`)

#### Step 6: Test Frontend
1. Visit your Vercel URL
2. Try the chat interface
3. Add a todo and verify it appears in the list

### Using Vercel CLI (Alternative)

#### Step 1: Install CLI
```bash
npm install -g vercel
```

#### Step 2: Login
```bash
vercel login
```

#### Step 3: Deploy
```bash
cd frontend
vercel
```

Follow prompts:
- Set up and deploy? **Y**
- Which scope? Select your account
- Link to existing project? **N**
- Project name? `todo-chatbot`
- In which directory? `./`
- Override settings? **N**

#### Step 4: Add Environment Variable
```bash
vercel env add NEXT_PUBLIC_API_URL
```
Enter your backend URL when prompted.

#### Step 5: Deploy to Production
```bash
vercel --prod
```

---

## Part 3: Connect Frontend and Backend

### Update Backend CORS

Now that you have your Vercel URL, update the backend:

#### For Render:
1. Go to Render Dashboard → Your Service
2. Environment → Edit `ALLOWED_ORIGINS`
3. Change to: `https://your-app.vercel.app`
4. Save (auto-redeploys)

#### For Railway:
1. Go to Railway Dashboard → Your Project
2. Variables → Edit `ALLOWED_ORIGINS`
3. Set to: `https://your-app.vercel.app`
4. Deploy (if not automatic)

### Verify Connection

1. Visit your Vercel frontend
2. Open browser DevTools (F12)
3. Go to Console tab
4. Try adding a todo
5. Should see no CORS errors

---

## Part 4: Verification Checklist

- [ ] Backend health endpoint returns `{"status":"ok"}`
- [ ] Backend API docs accessible at `/docs`
- [ ] Frontend loads without errors
- [ ] Can add todos via chat interface
- [ ] Todos appear in the todo list
- [ ] No CORS errors in browser console
- [ ] Environment variables set correctly

---

## Troubleshooting

### CORS Errors

**Symptom**: Red errors in browser console about CORS

**Solution**:
1. Check `ALLOWED_ORIGINS` in backend includes your exact Vercel URL
2. No trailing slash: ✅ `https://app.vercel.app` ❌ `https://app.vercel.app/`
3. Include protocol: ✅ `https://` ❌ `app.vercel.app`
4. Redeploy backend after changes

### Frontend Can't Reach Backend

**Symptom**: "Failed to fetch" errors

**Solution**:
1. Verify `NEXT_PUBLIC_API_URL` in Vercel settings
2. Test backend URL directly in browser
3. Check backend is not sleeping (Render free tier spins down)
4. Redeploy frontend after env var changes

### Backend Deployment Failed

**Symptom**: Build errors on Render/Railway

**Solution**:
1. Check Python version matches (3.11)
2. Verify `requirements.txt` exists in backend directory
3. Check build logs for specific errors
4. Ensure start command includes `cd src`

### Frontend Build Failed

**Symptom**: Vercel deployment fails

**Solution**:
1. Verify Root Directory is set to `frontend`
2. Check `package.json` exists in frontend directory
3. Look at build logs for specific errors
4. Try building locally first: `npm run build`

---

## Local Development

### Backend
```bash
cd backend/src
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r ../requirements.txt
uvicorn main:app --reload --port 8000
```

Test at: http://localhost:8000/docs

### Frontend
```bash
cd frontend
npm install
cp .env.local.example .env.local
# Edit .env.local to set NEXT_PUBLIC_API_URL=http://localhost:8000
npm run dev
```

Test at: http://localhost:3000

---

## Deployment URLs Summary

After deployment, you should have:

| Service | URL | Example |
|---------|-----|---------|
| Backend | Render/Railway URL | `https://todo-chatbot-backend.onrender.com` |
| Frontend | Vercel URL | `https://todo-chatbot.vercel.app` |
| API Docs | Backend URL + `/docs` | `https://todo-chatbot-backend.onrender.com/docs` |

---

## Cost Overview

| Platform | Free Tier | Limits |
|----------|-----------|--------|
| Vercel | Yes | 100 GB bandwidth, unlimited projects |
| Render | Yes | 750 hours/month, spins down after 15min inactivity |
| Railway | $5 credit | ~100-200 hours depending on usage |

**Total Monthly Cost**: $0 (with free tiers) or ~$5-10 if you upgrade

---

## Next Steps

1. **Custom Domain**: Add your own domain in Vercel settings
2. **Database**: Replace in-memory storage with PostgreSQL
3. **Authentication**: Add user authentication
4. **Monitoring**: Set up error tracking (Sentry)
5. **CI/CD**: Automatic deployments on git push (already set up!)

---

## Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Render Documentation](https://render.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [Next.js Documentation](https://nextjs.org/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com)

---

## Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Review deployment logs on respective platforms
3. Test components individually (backend, then frontend)
4. Check browser console for client-side errors
5. Review backend logs for server-side errors

---

**Deployment Date**: 2026-01-30
**Status**: Ready to Deploy ✅
