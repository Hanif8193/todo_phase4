# Start Frontend Server
Write-Host "🚀 Starting Frontend Server..." -ForegroundColor Cyan

# Navigate to frontend directory
Set-Location -Path "$PSScriptRoot\frontend"

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies (this may take a few minutes)..." -ForegroundColor Yellow
    npm install
}

Write-Host ""
Write-Host "✅ Frontend starting on http://localhost:3000" -ForegroundColor Green
Write-Host "📝 Press CTRL+C to stop" -ForegroundColor Yellow
Write-Host ""

# Start server
npm run dev
