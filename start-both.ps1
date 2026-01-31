# Start Both Backend and Frontend
Write-Host "🚀 Starting Todo App - Backend & Frontend" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found! Install Python 3.10+" -ForegroundColor Red
    exit 1
}

# Check if Node is installed
try {
    $nodeVersion = node --version 2>&1
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found! Install Node.js 18+" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "⚠️  IMPORTANT: Make sure you have updated backend\.env with your OpenAI API key!" -ForegroundColor Yellow
Write-Host "Get it from: https://platform.openai.com/api-keys" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to continue or CTRL+C to cancel..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host ""
Write-Host "📋 Opening two terminal windows..." -ForegroundColor Yellow
Write-Host ""

# Start backend in new window
Write-Host "Starting Backend Server..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PSScriptRoot\start-backend.ps1"

# Wait a bit for backend to start
Start-Sleep -Seconds 3

# Start frontend in new window
Write-Host "Starting Frontend Server..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PSScriptRoot\start-frontend.ps1"

Write-Host ""
Write-Host "✅ Both servers are starting!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Backend:  http://localhost:8000" -ForegroundColor Cyan
Write-Host "📍 Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "🧪 Test Backend:  http://localhost:8000/health" -ForegroundColor Yellow
Write-Host "🧪 Test Frontend: http://localhost:3000" -ForegroundColor Yellow
Write-Host ""
Write-Host "📝 To stop: Close the terminal windows or press CTRL+C in each" -ForegroundColor Yellow
Write-Host ""
