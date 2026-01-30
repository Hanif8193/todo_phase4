# Backend Deployment Guide

This guide covers deploying the FastAPI backend to various platforms.

## Recommended Platforms

1. **Render** - Easy, free tier available
2. **Railway** - Modern, simple setup
3. **Fly.io** - Edge deployment
4. **Heroku** - Classic PaaS

## Prerequisites

- Git repository with your code pushed
- Backend code tested locally
- Environment variables ready

## Option 1: Deploy to Render (Recommended)

Render offers a generous free tier and easy deployment.

### Steps:

1. **Sign up** at [render.com](https://render.com)

2. **Create New Web Service**:
   - Click "New" → "Web Service"
   - Connect your Git repository
   - Select the repository

3. **Configure**:
   - **Name**: `todo-chatbot-backend`
   - **Region**: Choose closest to your users
   - **Branch**: `main`
   - **Root Directory**: `backend`
   - **Runtime**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `cd src && uvicorn main:app --host 0.0.0.0 --port $PORT`

4. **Environment Variables**:
   Click "Advanced" → "Add Environment Variable":
   - `PYTHON_VERSION` = `3.11.0`
   - `ALLOWED_ORIGINS` = `https://your-frontend.vercel.app`
   - `OPENAI_API_KEY` = `your-api-key` (if using AI features)

5. **Deploy**: Click "Create Web Service"

6. **Get URL**: Once deployed, copy your service URL (e.g., `https://todo-chatbot-backend.onrender.com`)

### Using render.yaml

Alternatively, Render can auto-detect the `render.yaml` file:

1. Update `backend/render.yaml` with your settings
2. Push to Git
3. Create new "Blueprint" in Render dashboard
4. Connect repository and deploy

## Option 2: Deploy to Railway

Railway offers $5 free credit monthly.

### Steps:

1. **Sign up** at [railway.app](https://railway.app)

2. **Create New Project**:
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Connect and select your repository

3. **Configure**:
   - Railway will auto-detect Python
   - Set **Root Directory**: `backend` (if needed)
   - Railway uses `railway.json` automatically

4. **Environment Variables**:
   Go to "Variables" tab:
   - `ALLOWED_ORIGINS` = `https://your-frontend.vercel.app`
   - `OPENAI_API_KEY` = `your-api-key`
   - `PORT` = `8000` (Railway sets this automatically)

5. **Deploy**: Railway deploys automatically

6. **Get URL**: Go to "Settings" → "Generate Domain"

## Option 3: Deploy to Fly.io

Fly.io deploys to edge locations globally.

### Steps:

1. **Install Fly CLI**:
```bash
# Windows (PowerShell)
iwr https://fly.io/install.ps1 -useb | iex

# Mac/Linux
curl -L https://fly.io/install.sh | sh
```

2. **Login**:
```bash
flyctl auth login
```

3. **Initialize**:
```bash
cd backend
flyctl launch
```

4. **Configure** when prompted:
   - App name: `todo-chatbot-backend`
   - Region: Choose closest
   - Database: No (using in-memory for now)
   - Deploy: No (we'll set env vars first)

5. **Set Environment Variables**:
```bash
flyctl secrets set ALLOWED_ORIGINS=https://your-frontend.vercel.app
flyctl secrets set OPENAI_API_KEY=your-api-key
```

6. **Deploy**:
```bash
flyctl deploy
```

7. **Get URL**: `https://todo-chatbot-backend.fly.dev`

## Option 4: Deploy to Heroku

Note: Heroku no longer has a free tier, but is included for completeness.

### Steps:

1. **Install Heroku CLI**:
```bash
# Windows
winget install Heroku.HerokuCLI

# Mac
brew install heroku/brew/heroku
```

2. **Login**:
```bash
heroku login
```

3. **Create App**:
```bash
cd backend
heroku create todo-chatbot-backend
```

4. **Set Buildpack**:
```bash
heroku buildpacks:set heroku/python
```

5. **Set Environment Variables**:
```bash
heroku config:set ALLOWED_ORIGINS=https://your-frontend.vercel.app
heroku config:set OPENAI_API_KEY=your-api-key
```

6. **Deploy**:
```bash
git subtree push --prefix backend heroku main
```

7. **Get URL**: `https://todo-chatbot-backend.herokuapp.com`

## Post-Deployment Steps

### 1. Test Your Backend

Visit these endpoints to verify deployment:

- Health check: `https://your-backend-url.com/health`
- API docs: `https://your-backend-url.com/docs`
- Get todos: `https://your-backend-url.com/todos`

### 2. Update Frontend

Update your Vercel frontend environment variable:

```bash
# From frontend directory
vercel env add NEXT_PUBLIC_API_URL production
# Enter your backend URL: https://your-backend-url.com
```

Or in Vercel Dashboard:
- Go to your project
- Settings → Environment Variables
- Add/Update `NEXT_PUBLIC_API_URL` with your backend URL
- Redeploy frontend

### 3. Update CORS

If you deployed the backend first, update the CORS origins:

For Render/Railway/Fly:
1. Go to your service settings
2. Update `ALLOWED_ORIGINS` to include your Vercel domain
3. Redeploy

### 4. Test End-to-End

1. Visit your Vercel frontend URL
2. Try adding a todo
3. Check the chat interface
4. Verify todos appear in the list

## Troubleshooting

### CORS Errors

If you see CORS errors in the browser console:

1. Verify `ALLOWED_ORIGINS` includes your Vercel domain
2. Make sure it's a comma-separated list: `https://app1.vercel.app,https://app2.vercel.app`
3. For development, you can temporarily use `*` but change for production

### Port Issues

Most platforms set `$PORT` automatically. The start command uses:
```bash
uvicorn main:app --host 0.0.0.0 --port $PORT
```

If your platform doesn't set `$PORT`, hardcode it:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Module Import Errors

If you see module import errors:

1. Verify `requirements.txt` is in the root backend directory
2. Check the start command includes `cd src`
3. Ensure all dependencies are listed in requirements.txt

### Health Check Failures

If health checks fail:

1. Check logs on your platform
2. Verify the `/health` endpoint works locally
3. Make sure the port is correct

## Monitoring

### Render
- Logs: Dashboard → Your Service → Logs
- Metrics: Dashboard → Your Service → Metrics

### Railway
- Logs: Project → Deployments → View Logs
- Metrics: Project → Metrics tab

### Fly.io
```bash
flyctl logs
flyctl status
```

## Costs

| Platform | Free Tier | Notes |
|----------|-----------|-------|
| Render | 750 hours/month | Spins down after inactivity |
| Railway | $5/month credit | ~100 hours runtime |
| Fly.io | 3 shared VMs | 160GB bandwidth |
| Heroku | None | Starts at $7/month |

## Next Steps

1. Set up monitoring and alerts
2. Add database for persistent storage
3. Implement authentication
4. Set up CI/CD pipeline
5. Configure custom domain

## Support

For platform-specific issues:
- Render: https://render.com/docs
- Railway: https://docs.railway.app
- Fly.io: https://fly.io/docs
- Heroku: https://devcenter.heroku.com
