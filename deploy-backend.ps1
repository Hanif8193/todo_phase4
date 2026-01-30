# Automated Backend Deployment Script
# This script will deploy your backend to Railway

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Backend Deployment to Railway" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
Write-Host "Checking for Railway CLI..." -ForegroundColor Yellow
$railwayCli = Get-Command railway -ErrorAction SilentlyContinue

if (-not $railwayCli) {
    Write-Host "Railway CLI not found. Installing..." -ForegroundColor Yellow

    # Install Railway CLI
    Write-Host "Running: npm install -g @railway/cli" -ForegroundColor Gray
    npm install -g @railway/cli

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install Railway CLI" -ForegroundColor Red
        Write-Host "Please run: npm install -g @railway/cli" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Railway CLI installed successfully!" -ForegroundColor Green
} else {
    Write-Host "Railway CLI already installed ✓" -ForegroundColor Green
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 1: Login to Railway" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "A browser window will open. Please:" -ForegroundColor Yellow
Write-Host "1. Login with GitHub" -ForegroundColor Yellow
Write-Host "2. Authorize Railway" -ForegroundColor Yellow
Write-Host "3. Come back to this terminal" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press ENTER to open browser and login"

railway login

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Railway login failed" -ForegroundColor Red
    exit 1
}

Write-Host "Logged in successfully! ✓" -ForegroundColor Green
Write-Host ""

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 2: Create Railway Project" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Go to backend directory
Set-Location backend

Write-Host "Initializing Railway project..." -ForegroundColor Yellow
railway init

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to initialize Railway project" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 3: Deploy Backend" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "Deploying to Railway..." -ForegroundColor Yellow
railway up

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 4: Get Backend URL" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "Generating public URL..." -ForegroundColor Yellow
railway domain

Write-Host ""
Write-Host "==================================" -ForegroundColor Green
Write-Host "Backend Deployment Complete! ✓" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your backend is now live!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Copy your Railway URL from above" -ForegroundColor White
Write-Host "2. Run: ./deploy-frontend.ps1" -ForegroundColor White
Write-Host "3. Paste your Railway URL when prompted" -ForegroundColor White
Write-Host ""

# Go back to root
Set-Location ..
