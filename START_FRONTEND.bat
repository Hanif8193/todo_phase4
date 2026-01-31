@echo off
cd /d %~dp0\frontend
echo.
echo ============================================
echo   Starting Frontend Server
echo ============================================
echo.

REM Check if node_modules exists
if not exist "node_modules\" (
    echo Installing dependencies... (this may take a few minutes)
    call npm install
)

echo.
echo ============================================
echo   Frontend starting on http://localhost:3000
echo   Press CTRL+C to stop
echo ============================================
echo.

REM Start server
call npm run dev
