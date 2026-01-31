@echo off
cd /d %~dp0\backend
echo.
echo ============================================
echo   Starting Backend Server
echo ============================================
echo.

REM Check if venv exists
if not exist "venv\" (
    echo Creating virtual environment...
    python -m venv venv
)

REM Activate venv
call venv\Scripts\activate.bat

REM Install/upgrade dependencies
echo Installing dependencies...
pip install -q uvicorn fastapi pydantic openai python-dotenv

echo.
echo ============================================
echo   Backend starting on http://localhost:8000
echo   Press CTRL+C to stop
echo ============================================
echo.

REM Start server
python -m uvicorn src.main:app --reload --host 127.0.0.1 --port 8000
