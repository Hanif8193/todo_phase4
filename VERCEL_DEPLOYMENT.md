# 🚀 Complete Vercel Deployment Guide

Deploy both backend (FastAPI) and frontend (Next.js) to Vercel in 10 minutes!

## Prerequisites

- GitHub account
- Vercel account (free tier is fine) - Sign up at https://vercel.com
- New OpenAI API key (revoke the old one first!)
- Git repository with your code

## Part 1: Prepare Your Repository

### Step 1: Revoke Old API Key

1. Go to https://platform.openai.com/api-keys
2. Delete the exposed key: `sk-proj-z6QibH3...`
3. Create new secret key
4. **Copy and save it** - you'll need it soon

### Step 2: Commit Your Updated Code

```bash
cd C:\Users\PMLS\OneDrive\Desktop\todo_phase4

# Add all changes
git add .

# Commit
git commit -m "Configure for Vercel deployment"

# Push to GitHub
git push origin main
```

## Part 2: Deploy Backend to Vercel

### Step 1: Create New Vercel Project for Backend

1. Go to https://vercel.com/dashboard
2. Click **"Add New..."** → **"Project"**
3. Import your GitHub repository: `todo_phase4`
4. Click **"Import"**

### Step 2: Configure Backend Project

**Project Settings:**
- **Project Name:** `todo-phase4-backend` (or your choice)
- **Framework Preset:** Other
- **Root Directory:** `backend` ← **IMPORTANT: Click "Edit" and select "backend"**
- **Build Command:** Leave empty
- **Output Directory:** Leave empty
- **Install Command:** `pip install -r requirements.txt`

### Step 3: Add Environment Variables

In the same configuration screen, scroll to **"Environment Variables"**:

Add these variables:

| Name | Value |
|------|-------|
| `OPENAI_API_KEY` | `sk-your-NEW-api-key-here` |
| `ALLOWED_ORIGINS` | `*` (we'll update this later) |

Click **"Add"** for each one.

### Step 4: Deploy Backend

Click **"Deploy"**

Wait 1-2 minutes for deployment to complete.

### Step 5: Get Backend URL

After deployment succeeds:
- Copy your backend URL (e.g., `https://todo-phase4-backend.vercel.app`)
- **Save this URL** - you'll need it for frontend

### Step 6: Test Backend

Visit these URLs:

1. **Root:** `https://your-backend.vercel.app/`
   - Should show: `{"message": "AI Todo Chatbot is running!"}`

2. **Health:** `https://your-backend.vercel.app/health`
   - Should show: `{"status": "ok"}`

3. **Todos:** `https://your-backend.vercel.app/todos`
   - Should show: `{"todos": []}`

✅ If all three work, backend is deployed successfully!

## Part 3: Deploy Frontend to Vercel

### Step 1: Create New Vercel Project for Frontend

1. Back on Vercel dashboard
2. Click **"Add New..."** → **"Project"**
3. Import the same GitHub repository: `todo_phase4`
4. Click **"Import"**

### Step 2: Configure Frontend Project

**Project Settings:**
- **Project Name:** `todo-phase4-frontend` (or your choice)
- **Framework Preset:** Next.js
- **Root Directory:** `frontend` ← **IMPORTANT: Click "Edit" and select "frontend"**
- **Build Command:** `npm run build`
- **Output Directory:** `.next`
- **Install Command:** `npm install`

### Step 3: Add Environment Variable

In **"Environment Variables"** section:

| Name | Value |
|------|-------|
| `NEXT_PUBLIC_API_URL` | `https://your-backend.vercel.app` |

⚠️ **Replace** `https://your-backend.vercel.app` with your actual backend URL from Part 2, Step 5!

Click **"Add"**.

### Step 4: Deploy Frontend

Click **"Deploy"**

Wait 1-2 minutes for deployment to complete.

### Step 5: Get Frontend URL

After deployment succeeds:
- Your frontend URL: `https://todo-phase4-frontend.vercel.app`
- **Open it** in your browser

## Part 4: Update CORS Settings

Now that you have the frontend URL, update backend CORS:

### Step 1: Update Backend Environment Variable

1. Go to Vercel dashboard
2. Select your **backend** project
3. Go to **Settings** → **Environment Variables**
4. Find `ALLOWED_ORIGINS`
5. Click **"Edit"**
6. Change value to: `https://your-frontend.vercel.app,http://localhost:3000`
   - Replace `https://your-frontend.vercel.app` with your actual frontend URL
7. Click **"Save"**

### Step 2: Redeploy Backend

1. Go to **Deployments** tab
2. Click the **"..."** menu on the latest deployment
3. Click **"Redeploy"**
4. Wait for redeployment to complete

## Part 5: Test Everything

### Test 1: Frontend Loads

Visit: `https://your-frontend.vercel.app`

You should see:
- "AI Todo Chatbot" header
- Todo list (empty)
- Chat interface

### Test 2: Add a Todo

1. In the todo input field, type: "Buy groceries"
2. Click "Add Todo"
3. Todo should appear in the list

### Test 3: AI Chat

1. In chat interface, type: "Help me organize my tasks"
2. Click "Send"
3. AI should respond (using OpenAI API)

## ✅ Success Checklist

- [ ] Old API key revoked
- [ ] New API key created
- [ ] Backend deployed to Vercel
- [ ] Backend health check works
- [ ] Frontend deployed to Vercel
- [ ] Frontend loads successfully
- [ ] Can add todos
- [ ] AI chat responds
- [ ] CORS configured correctly

## Common Issues & Fixes

### Issue: "Module not found: openai"

**Fix:**
1. Check `backend/requirements.txt` includes `openai==1.50.0`
2. Redeploy backend

### Issue: "OPENAI_API_KEY not set"

**Fix:**
1. Go to backend project → Settings → Environment Variables
2. Verify `OPENAI_API_KEY` is set
3. Redeploy

### Issue: CORS errors in browser console

**Fix:**
1. Update `ALLOWED_ORIGINS` in backend environment variables
2. Include your actual frontend URL
3. Redeploy backend

### Issue: Frontend can't connect to backend

**Fix:**
1. Go to frontend project → Settings → Environment Variables
2. Verify `NEXT_PUBLIC_API_URL` points to backend URL
3. Redeploy frontend

## Updating Your Deployments

Vercel auto-deploys when you push to GitHub!

```bash
# Make changes
git add .
git commit -m "Your update message"
git push origin main

# Vercel automatically deploys both projects!
```

## Cost

Both deployments are **FREE** on Vercel's Hobby plan!

---

**🎉 Congratulations!** Your app is now live on Vercel!
