# Start Backend Server
Write-Host "🚀 Starting Backend Server..." -ForegroundColor Cyan

# Navigate to backend directory
Set-Location -Path "$PSScriptRoot\backend"

# Check if venv exists
if (-not (Test-Path "venv")) {
    Write-Host "📦 Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate virtual environment
Write-Host "🔧 Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  WARNING: .env file not found!" -ForegroundColor Red
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Edit backend\.env and add your OpenAI API key!" -ForegroundColor Red
    Write-Host "Get it from: https://platform.openai.com/api-keys" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter after updating .env file"
}

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
pip install -q -r requirements.txt

# Check if uvicorn is installed
$uvicornInstalled = pip list | Select-String "uvicorn"
if (-not $uvicornInstalled) {
    Write-Host "📦 Installing uvicorn..." -ForegroundColor Yellow
    pip install uvicorn
}

Write-Host ""
Write-Host "✅ Backend starting on http://localhost:8000" -ForegroundColor Green
Write-Host "📝 Press CTRL+C to stop" -ForegroundColor Yellow
Write-Host ""

# Start server
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
