# Free Backend Deployment Options (No Credit Card Required)

Since Render now requires a credit card, here are the best alternatives:

## Quick Comparison

| Platform | Setup Time | Credit Card? | Free Tier | Best For |
|----------|------------|--------------|-----------|----------|
| **Railway** | 10 min | No (initially) | $5 credit/month | **Recommended - Easiest** |
| **PythonAnywhere** | 15 min | Never | Forever free | Small demos, learning |
| **Deta Space** | 5 min | Never | Forever free | Quick deployment |
| Render | 10 min | Yes (required) | 750 hrs/month | If you have a card |

---

## Option 1: Railway ⭐ RECOMMENDED

**Best for**: Most users, production-ready apps

### Pros
- No credit card needed initially
- $5 free credit per month (~500 hours)
- Modern interface
- Auto-deployments from GitHub
- Good performance

### Cons
- Credit runs out if heavily used
- Requires card after free credit ends

### Quick Start
See `RAILWAY_QUICK_DEPLOY.md` for detailed steps.

**Summary**:
1. Sign up at railway.app with GitHub
2. "New Project" → "Deploy from GitHub"
3. Set build/start commands
4. Generate domain
5. Done!

**Your backend will be**: `https://your-app.up.railway.app`

---

## Option 2: PythonAnywhere

**Best for**: Learning, demos, small projects

### Pros
- 100% free forever
- Never requires credit card
- Simple setup
- Reliable uptime

### Cons
- Only 1 web app on free tier
- Limited CPU time daily
- URL is `username.pythonanywhere.com`
- Slower than other options

### Quick Start
See `PYTHONANYWHERE_DEPLOY.md` for detailed steps.

**Your backend will be**: `https://YOUR_USERNAME.pythonanywhere.com`

---

## Option 3: Deta Space (Fastest Setup)

**Best for**: Quick prototypes, instant deployment

### Pros
- Completely free forever
- No credit card ever
- Super fast deployment
- Great for APIs

### Cons
- Newer platform (less mature)
- Limited documentation

### Quick Setup

1. **Install Deta CLI**:
```bash
# Windows PowerShell
iwr https://get.deta.dev/cli.ps1 -useb | iex

# Mac/Linux
curl -fsSL https://get.deta.dev/cli.sh | sh
```

2. **Login**:
```bash
deta login
```

3. **Deploy**:
```bash
cd backend
deta new --python
```

4. **Update for FastAPI**:
Create `backend/.deta/prog_info` and edit as needed.

See Deta docs: https://deta.space/docs

---

## Recommended Path

### For Most People:
1. **Try Railway first** (easiest, no card)
   - Follow `RAILWAY_QUICK_DEPLOY.md`
   - If $5 credit isn't enough, move to next option

2. **Use PythonAnywhere as backup**
   - Follow `PYTHONANYWHERE_DEPLOY.md`
   - 100% free forever

### For Quick Testing:
- Use Deta Space if you just need something running fast

### If You Have a Credit Card:
- Render is still good (they won't charge you on free tier)

---

## My Recommendation

**Start with Railway** because:
- ✅ No credit card needed now
- ✅ Easiest setup (10 minutes)
- ✅ Professional URLs
- ✅ Good performance
- ✅ Auto-deploys from Git
- ✅ $5 free credit goes a long way

**Fallback to PythonAnywhere** if:
- ❌ Railway asks for card
- ❌ You run out of credits
- ✅ You want something permanent and free

---

## Step-by-Step: Railway Deployment

Since Railway is recommended, here's the complete process:

### 1. Prepare Code (1 minute)
Make sure your code is pushed to GitHub:
```bash
git add .
git commit -m "Ready for deployment"
git push
```

### 2. Deploy Backend to Railway (10 minutes)

1. Go to https://railway.app
2. Click "Login" → "Login with GitHub"
3. Click "New Project" → "Deploy from GitHub repo"
4. Select your repository

**Configure the service:**
- Click on the service created
- Go to "Settings"
- Set these commands:
  - **Build**: `cd backend && pip install -r requirements.txt`
  - **Start**: `cd backend/src && uvicorn main:app --host 0.0.0.0 --port $PORT`

**Add environment variables:**
- Go to "Variables" tab
- Add: `ALLOWED_ORIGINS` = `*` (temporary)

**Generate domain:**
- Settings → Networking → "Generate Domain"
- Copy your URL: `https://your-app.up.railway.app`

**Test it:**
- Visit `https://your-app.up.railway.app/health`
- Should see `{"status":"ok"}`

### 3. Deploy Frontend to Vercel (5 minutes)

1. Go to https://vercel.com
2. "New Project" → Import your repository
3. **Set Root Directory**: `frontend` ⚠️ IMPORTANT
4. Add environment variable:
   - `NEXT_PUBLIC_API_URL` = Your Railway URL
5. Click "Deploy"
6. Copy your Vercel URL

### 4. Update CORS (2 minutes)

1. Go back to Railway
2. Variables → Edit `ALLOWED_ORIGINS`
3. Change to your Vercel URL: `https://your-app.vercel.app`
4. Railway will auto-redeploy

### 5. Test! (1 minute)

Visit your Vercel URL and:
- ✅ Chat interface loads
- ✅ Can send messages
- ✅ Todos appear
- ✅ No errors in console (F12)

**Total Time: ~20 minutes**

---

## Need Help?

### Railway Not Working?
- Check build logs in Railway dashboard
- Verify build/start commands are correct
- Make sure `PORT` variable is used (Railway sets it automatically)

### PythonAnywhere Issues?
- See `PYTHONANYWHERE_DEPLOY.md` troubleshooting section
- Check error logs in PythonAnywhere Web tab

### General Issues?
1. Test backend URL directly: `/health` endpoint
2. Check browser console for errors (F12)
3. Verify environment variables are set
4. Ensure CORS origins match exactly

---

## Files You Need

- ✅ `RAILWAY_QUICK_DEPLOY.md` - Railway step-by-step
- ✅ `PYTHONANYWHERE_DEPLOY.md` - PythonAnywhere step-by-step
- ✅ `VERCEL_DEPLOYMENT_GUIDE.md` - Original full guide
- ✅ `backend/DEPLOYMENT.md` - All platform options

---

**Last Updated**: 2026-01-30
**Recommended**: Railway (no credit card, easiest setup)
