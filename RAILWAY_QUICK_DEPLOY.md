# Quick Deploy to Railway (No Credit Card)

## Step-by-Step Railway Deployment

### 1. Sign Up & Create Project
1. Go to https://railway.app
2. Click "Login" → "Login with GitHub"
3. Authorize Railway
4. Click "New Project"
5. Select "Deploy from GitHub repo"
6. Choose your repository

### 2. Configure Service
Railway auto-detects Python, but we need to configure it:

1. Click on your deployed service
2. Go to "Settings" tab
3. Under "Build", add:
   - **Root Directory**: Leave empty or set to `/`
   - **Build Command**: `cd backend && pip install -r requirements.txt`
   - **Start Command**: `cd backend/src && uvicorn main:app --host 0.0.0.0 --port $PORT`

### 3. Set Environment Variables
1. Click "Variables" tab
2. Click "New Variable"
3. Add these:

```
ALLOWED_ORIGINS=*
```

(We'll update this with your Vercel URL later)

If using OpenAI:
```
OPENAI_API_KEY=your-key-here
```

### 4. Generate Public URL
1. Go to "Settings" tab
2. Scroll to "Networking"
3. Click "Generate Domain"
4. Copy your URL (e.g., `https://your-app.up.railway.app`)

### 5. Test Backend
Visit in browser:
- `https://your-app.up.railway.app/health`
- `https://your-app.up.railway.app/docs`

Should see `{"status":"ok"}`

### 6. Deploy Frontend to Vercel
Now deploy your frontend:

1. Go to https://vercel.com
2. "New Project" → Import your repo
3. **IMPORTANT**: Set "Root Directory" to `frontend`
4. Add Environment Variable:
   - Name: `NEXT_PUBLIC_API_URL`
   - Value: Your Railway URL (from step 4)
5. Click "Deploy"

### 7. Update CORS
After getting your Vercel URL:

1. Go back to Railway
2. Click "Variables"
3. Edit `ALLOWED_ORIGINS`
4. Change from `*` to your Vercel URL: `https://your-app.vercel.app`
5. Service will auto-redeploy

### 8. Test Complete App
Visit your Vercel URL and test the chat interface!

---

## Troubleshooting

### Build Fails
If build fails, check:
- Build command: `cd backend && pip install -r requirements.txt`
- Start command: `cd backend/src && uvicorn main:app --host 0.0.0.0 --port $PORT`

### Can't Access API
- Make sure domain is generated in Railway settings
- Check that service is running (green status)
- Visit `/health` endpoint to test

### CORS Errors
- Update `ALLOWED_ORIGINS` with exact Vercel URL
- Include `https://` protocol
- No trailing slash

---

## Railway Free Tier
- $5 credit per month
- ~500 hours of usage
- No credit card required initially
- Auto-sleeps after inactivity

---

**Total Setup Time**: 10-15 minutes
