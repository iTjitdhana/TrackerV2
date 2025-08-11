@echo off
echo ========================================
echo 🐳 Push WorkplanV6 แยก Frontend/Backend
echo ========================================

echo.
echo 📋 กรุณาใส่ข้อมูล Docker Hub:
set /p username="Docker Hub Username: "
set /p version="Version (เช่น latest): "

if "%version%"=="" set version=latest

echo.
echo 📋 ข้อมูลที่จะใช้:
echo Username: %username%
echo Version: %version%
echo.

echo 🔍 ตรวจสอบ Docker...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker ไม่ได้ทำงาน กรุณาเริ่ม Docker ก่อน
    pause
    exit /b 1
)

echo 🔨 เริ่มต้น build Docker images...
echo.

echo 📦 Building frontend image...
docker build -t workplanv6-frontend:%version% .
if %errorlevel% neq 0 (
    echo ❌ Build frontend ไม่สำเร็จ
    pause
    exit /b 1
)

echo 📦 Building backend image...
docker build -t workplanv6-backend:%version% ./backend
if %errorlevel% neq 0 (
    echo ❌ Build backend ไม่สำเร็จ
    pause
    exit /b 1
)

echo 🔐 Login to Docker Hub...
docker login -u %username%
if %errorlevel% neq 0 (
    echo ❌ Login ไม่สำเร็จ กรุณาตรวจสอบ credentials
    pause
    exit /b 1
)

echo 🏷️ Tag images...
docker tag workplanv6-frontend:%version% %username%/workplanv6-frontend:%version%
docker tag workplanv6-backend:%version% %username%/workplanv6-backend:%version%

echo 📤 Push frontend image...
docker push %username%/workplanv6-frontend:%version%
if %errorlevel% neq 0 (
    echo ❌ Push frontend ไม่สำเร็จ
    pause
    exit /b 1
)

echo 📤 Push backend image...
docker push %username%/workplanv6-backend:%version%
if %errorlevel% neq 0 (
    echo ❌ Push backend ไม่สำเร็จ
    pause
    exit /b 1
)

echo.
echo ✅ Push สำเร็จ!
echo.
echo 📋 Images ที่ push แล้ว:
echo   - %username%/workplanv6-frontend:%version%
echo   - %username%/workplanv6-backend:%version%
echo.
echo 🌐 Docker Hub URLs:
echo   - https://hub.docker.com/r/%username%/workplanv6-frontend
echo   - https://hub.docker.com/r/%username%/workplanv6-backend
echo.
echo 📝 คำสั่งสำหรับ pull ในเครื่องอื่น:
echo   - docker pull %username%/workplanv6-frontend:%version%
echo   - docker pull %username%/workplanv6-backend:%version%
echo.
pause
