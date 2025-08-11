@echo off
REM 🚀 Build and Start Frontend Production
REM สำหรับ build และ start frontend ใน production mode

echo.
echo ================================
echo Build and Start Frontend Production
echo ================================
echo.

echo [INFO] Building frontend for production...
echo.

REM Step 1: Install dependencies
echo [STEP 1] Install Dependencies
echo ================================
cd frontend
echo [INFO] Installing dependencies...
call npm install --legacy-peer-deps
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    echo [INFO] Trying with --force...
    call npm install --force
)
echo [SUCCESS] Dependencies installed
echo.

REM Step 2: Build for production
echo [STEP 2] Build for Production
echo ================================
echo [INFO] Building frontend...
call npm run build
if %errorlevel% neq 0 (
    echo [ERROR] Build failed
    echo [INFO] Please check the errors above
    pause
    exit /b 1
)
echo [SUCCESS] Frontend built successfully
echo.

REM Step 3: Start production server
echo [STEP 3] Start Production Server
echo ================================
echo [INFO] Starting production server...
echo [INFO] Frontend will be available at:
echo - Local: http://localhost:3011
echo - Network: http://192.168.0.94:3011
echo.
echo [INFO] Press Ctrl+C to stop the server
echo.
call npm start 