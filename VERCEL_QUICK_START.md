# Vercel Quick Start Checklist ✅

Follow this exact order. Total time: ~10 minutes.

## Before You Start

- [ ] Go to https://platform.openai.com/api-keys
- [ ] **Revoke old key** (the exposed one)
- [ ] **Create new key** and copy it
- [ ] Go to https://vercel.com and sign up/login

## Step 1: Push Code to GitHub (2 min)

```bash
cd C:\Users\PMLS\OneDrive\Desktop\todo_phase4
git add .
git commit -m "Ready for Vercel deployment"
git push origin main
```

## Step 2: Deploy Backend (3 min)

1. Go to https://vercel.com/new
2. Import your GitHub repo
3. **Settings:**
   - Root Directory: `backend` ← Click Edit!
   - Framework: Other
4. **Environment Variables** - Add these:
   ```
   OPENAI_API_KEY = sk-your-NEW-key-here
   ALLOWED_ORIGINS = *
   ```
5. Click **Deploy**
6. **Save backend URL:** `https://your-backend.vercel.app`

**Test it:** Visit `https://your-backend.vercel.app/health`
Should see: `{"status": "ok"}`

## Step 3: Deploy Frontend (3 min)

1. Go to https://vercel.com/new again
2. Import same GitHub repo
3. **Settings:**
   - Root Directory: `frontend` ← Click Edit!
   - Framework: Next.js (auto-detected)
4. **Environment Variables** - Add this:
   ```
   NEXT_PUBLIC_API_URL = https://your-backend.vercel.app
   ```
   ⚠️ Use YOUR actual backend URL from Step 2!
5. Click **Deploy**
6. **Save frontend URL:** `https://your-frontend.vercel.app`

**Test it:** Visit your frontend URL - should see the app!

## Step 4: Fix CORS (2 min)

1. Go to Vercel → Select backend project
2. Settings → Environment Variables
3. Edit `ALLOWED_ORIGINS`:
   ```
   https://your-frontend.vercel.app,http://localhost:3000
   ```
   ⚠️ Use YOUR actual frontend URL!
4. Deployments → Latest → Redeploy

## Step 5: Test Everything! (1 min)

Visit your frontend URL:
- [ ] Page loads
- [ ] Add a todo - works
- [ ] Chat with AI - works

## ✅ DONE!

**Your URLs:**
- Backend: `https://[your-backend].vercel.app`
- Frontend: `https://[your-frontend].vercel.app`

Share your frontend URL with anyone!

## Need Help?

**Backend not working?**
- Check: Vercel → Backend project → Deployments → Logs

**Frontend not connecting?**
- Check: `NEXT_PUBLIC_API_URL` has correct backend URL
- Check: CORS is configured with frontend URL

**Still stuck?**
- Share the error message
- Share Vercel deployment logs
