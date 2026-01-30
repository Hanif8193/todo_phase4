# Master Deployment Script
# This script will deploy both backend and frontend automatically

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   AI TODO CHATBOT - AUTO DEPLOYMENT   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will:" -ForegroundColor Yellow
Write-Host "  1. Deploy backend to Railway" -ForegroundColor White
Write-Host "  2. Deploy frontend to Vercel" -ForegroundColor White
Write-Host "  3. Configure CORS" -ForegroundColor White
Write-Host ""
Write-Host "Total time: ~20 minutes" -ForegroundColor Yellow
Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Host "ERROR: Node.js is not installed" -ForegroundColor Red
    Write-Host "Please install from: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ Node.js installed" -ForegroundColor Green

# Check npm
$npm = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npm) {
    Write-Host "ERROR: npm is not installed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ npm installed" -ForegroundColor Green

Write-Host ""
Read-Host "Press ENTER to start deployment (or CTRL+C to cancel)"

# ============================================
# STEP 1: DEPLOY BACKEND
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "STEP 1: DEPLOYING BACKEND TO RAILWAY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check/Install Railway CLI
$railwayCli = Get-Command railway -ErrorAction SilentlyContinue
if (-not $railwayCli) {
    Write-Host "Installing Railway CLI..." -ForegroundColor Yellow
    npm install -g @railway/cli
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install Railway CLI" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Logging in to Railway..." -ForegroundColor Yellow
Write-Host "(Browser will open - login with GitHub)" -ForegroundColor Gray
railway login

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Railway login failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Logged in to Railway" -ForegroundColor Green

# Deploy backend
Set-Location backend

Write-Host ""
Write-Host "Creating Railway project..." -ForegroundColor Yellow
railway init

Write-Host ""
Write-Host "Deploying backend..." -ForegroundColor Yellow
Write-Host "(This may take 2-3 minutes)" -ForegroundColor Gray
railway up

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Backend deployment failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

Write-Host ""
Write-Host "Generating public domain..." -ForegroundColor Yellow
railway domain

# Get the URL
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "BACKEND DEPLOYED SUCCESSFULLY! ✓" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Go back to root
Set-Location ..

# Ask user for backend URL
Write-Host "Copy your Railway URL from above" -ForegroundColor Yellow
Write-Host "Example: https://your-app.up.railway.app" -ForegroundColor Gray
Write-Host ""
$backendUrl = Read-Host "Paste your Railway URL here"

if ([string]::IsNullOrWhiteSpace($backendUrl)) {
    Write-Host "ERROR: Backend URL is required to continue" -ForegroundColor Red
    exit 1
}

# ============================================
# STEP 2: DEPLOY FRONTEND
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "STEP 2: DEPLOYING FRONTEND TO VERCEL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check/Install Vercel CLI
$vercelCli = Get-Command vercel -ErrorAction SilentlyContinue
if (-not $vercelCli) {
    Write-Host "Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install Vercel CLI" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Logging in to Vercel..." -ForegroundColor Yellow
Write-Host "(Browser will open)" -ForegroundColor Gray
vercel login

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Vercel login failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Logged in to Vercel" -ForegroundColor Green

# Create env file
Write-Host ""
Write-Host "Setting backend URL..." -ForegroundColor Yellow
Set-Content -Path "frontend\.env.local" -Value "NEXT_PUBLIC_API_URL=$backendUrl"
Write-Host "✓ Environment configured" -ForegroundColor Green

# Install dependencies
Set-Location frontend

Write-Host ""
Write-Host "Installing dependencies..." -ForegroundColor Yellow
Write-Host "(This may take 1-2 minutes)" -ForegroundColor Gray
npm install --silent

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install dependencies" -ForegroundColor Red
    Set-Location ..
    exit 1
}

Write-Host "✓ Dependencies installed" -ForegroundColor Green

# Deploy to Vercel
Write-Host ""
Write-Host "Deploying to Vercel..." -ForegroundColor Yellow
Write-Host ""
Write-Host "When prompted:" -ForegroundColor Yellow
Write-Host "  Set up and deploy? → Y" -ForegroundColor White
Write-Host "  Which scope? → (select your account)" -ForegroundColor White
Write-Host "  Link to existing project? → N" -ForegroundColor White
Write-Host "  Project name? → todo-chatbot" -ForegroundColor White
Write-Host "  In which directory? → ./" -ForegroundColor White
Write-Host "  Want to override? → N" -ForegroundColor White
Write-Host ""
Read-Host "Press ENTER to continue"

vercel --prod

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Frontend deployment failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

Set-Location ..

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "FRONTEND DEPLOYED SUCCESSFULLY! ✓" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# ============================================
# STEP 3: UPDATE CORS
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "STEP 3: CONFIGURE CORS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Copy your Vercel URL from above" -ForegroundColor Yellow
Write-Host "Example: https://todo-chatbot.vercel.app" -ForegroundColor Gray
Write-Host ""
$frontendUrl = Read-Host "Paste your Vercel URL here"

if ([string]::IsNullOrWhiteSpace($frontendUrl)) {
    Write-Host "WARNING: Skipping CORS configuration" -ForegroundColor Yellow
    Write-Host "You'll need to update this manually later" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Updating CORS settings..." -ForegroundColor Yellow

    Set-Location backend
    railway variables set ALLOWED_ORIGINS=$frontendUrl

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ CORS configured" -ForegroundColor Green
    } else {
        Write-Host "WARNING: CORS update failed" -ForegroundColor Yellow
        Write-Host "Update manually at: https://railway.app" -ForegroundColor Yellow
    }

    Set-Location ..
}

# ============================================
# COMPLETION
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   DEPLOYMENT COMPLETE! 🎉" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your URLs:" -ForegroundColor Yellow
Write-Host "  Backend:  $backendUrl" -ForegroundColor White
Write-Host "  Frontend: $frontendUrl" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Visit your frontend URL" -ForegroundColor White
Write-Host "  2. Test the chat interface" -ForegroundColor White
Write-Host "  3. Check browser console (F12) for errors" -ForegroundColor White
Write-Host ""
Write-Host "If you see CORS errors:" -ForegroundColor Yellow
Write-Host "  1. Go to https://railway.app" -ForegroundColor White
Write-Host "  2. Click your project → Variables" -ForegroundColor White
Write-Host "  3. Set ALLOWED_ORIGINS to: $frontendUrl" -ForegroundColor White
Write-Host ""
Write-Host "Enjoy your deployed app! ✨" -ForegroundColor Cyan
Write-Host ""
