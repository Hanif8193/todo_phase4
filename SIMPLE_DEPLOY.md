# Simple 3-Step Deployment

I've created automated scripts for you. Just run these commands!

## Prerequisites

You need Node.js and npm installed. Check by running:
```powershell
node --version
npm --version
```

If not installed, download from: https://nodejs.org

---

## Step 1: Deploy Backend (10 minutes)

Open PowerShell in this folder and run:

```powershell
.\deploy-backend.ps1
```

**What it does:**
1. Installs Railway CLI
2. Opens browser for you to login with GitHub
3. Creates and deploys your backend
4. Gives you a URL

**Copy the Railway URL** when done!

---

## Step 2: Deploy Frontend (5 minutes)

```powershell
.\deploy-frontend.ps1
```

**What it does:**
1. Installs Vercel CLI
2. Opens browser for you to login
3. Asks for your Railway URL (paste it)
4. Deploys your frontend
5. Gives you a Vercel URL

**Copy the Vercel URL** when done!

---

## Step 3: Update CORS (2 minutes)

You need to update your backend to allow your frontend:

### Option A: Via Railway Dashboard
1. Go to https://railway.app
2. Click on your project
3. Click "Variables" tab
4. Find `ALLOWED_ORIGINS`
5. Change value to your Vercel URL
6. Click "Deploy"

### Option B: Via CLI
```powershell
cd backend
railway variables set ALLOWED_ORIGINS=https://your-app.vercel.app
```

Replace `https://your-app.vercel.app` with your actual Vercel URL!

---

## Test Your App

1. Visit your Vercel URL
2. Try adding a todo
3. Check if it appears in the list
4. Open browser console (F12) - should have no errors

---

## If Something Goes Wrong

### Script won't run?
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Railway login fails?
- Make sure you have a GitHub account
- Try running: `railway login` manually

### Vercel deployment fails?
- Make sure you're in the right directory
- Try running: `cd frontend` then `vercel`

### Can't connect frontend to backend?
- Check that you entered the correct Railway URL
- Make sure CORS is updated with your Vercel URL

---

## That's it!

Your app should be live in ~20 minutes total.

**Backend**: Your Railway URL
**Frontend**: Your Vercel URL

Both are free and will stay online!
