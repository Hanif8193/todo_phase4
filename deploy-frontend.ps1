# Automated Frontend Deployment Script
# This script will deploy your frontend to Vercel

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Frontend Deployment to Vercel" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Vercel CLI is installed
Write-Host "Checking for Vercel CLI..." -ForegroundColor Yellow
$vercelCli = Get-Command vercel -ErrorAction SilentlyContinue

if (-not $vercelCli) {
    Write-Host "Vercel CLI not found. Installing..." -ForegroundColor Yellow

    Write-Host "Running: npm install -g vercel" -ForegroundColor Gray
    npm install -g vercel

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install Vercel CLI" -ForegroundColor Red
        Write-Host "Please run: npm install -g vercel" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Vercel CLI installed successfully! ✓" -ForegroundColor Green
} else {
    Write-Host "Vercel CLI already installed ✓" -ForegroundColor Green
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 1: Login to Vercel" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "A browser window will open. Please:" -ForegroundColor Yellow
Write-Host "1. Login with GitHub (or email)" -ForegroundColor Yellow
Write-Host "2. Come back to this terminal" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press ENTER to open browser and login"

vercel login

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Vercel login failed" -ForegroundColor Red
    exit 1
}

Write-Host "Logged in successfully! ✓" -ForegroundColor Green
Write-Host ""

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 2: Backend URL" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Enter your Railway backend URL" -ForegroundColor Yellow
Write-Host "Example: https://your-app.up.railway.app" -ForegroundColor Gray
Write-Host ""
$backendUrl = Read-Host "Backend URL"

if ([string]::IsNullOrWhiteSpace($backendUrl)) {
    Write-Host "ERROR: Backend URL is required" -ForegroundColor Red
    exit 1
}

# Create .env.local file
Write-Host ""
Write-Host "Creating environment file..." -ForegroundColor Yellow
Set-Content -Path "frontend\.env.local" -Value "NEXT_PUBLIC_API_URL=$backendUrl"
Write-Host "Environment file created ✓" -ForegroundColor Green

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 3: Install Dependencies" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

Set-Location frontend

Write-Host "Installing packages..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "Dependencies installed ✓" -ForegroundColor Green

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Step 4: Deploy to Vercel" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "When prompted:" -ForegroundColor Yellow
Write-Host "- Set up and deploy? → Y" -ForegroundColor White
Write-Host "- Which scope? → Select your account" -ForegroundColor White
Write-Host "- Link to existing project? → N" -ForegroundColor White
Write-Host "- What's your project's name? → todo-chatbot (or any name)" -ForegroundColor White
Write-Host "- In which directory is your code located? → ./" -ForegroundColor White
Write-Host "- Want to override settings? → N" -ForegroundColor White
Write-Host ""
Read-Host "Press ENTER to start deployment"

vercel --prod

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Green
Write-Host "Deployment Complete! ✓" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your app is now live!" -ForegroundColor Green
Write-Host ""
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "Run: ./update-cors.ps1 and paste your Vercel URL" -ForegroundColor White
Write-Host ""

# Go back to root
Set-Location ..
