@echo off
echo ========================================
echo 🚀 ติดตั้ง Node.js และ npm
echo ========================================

echo.
echo 📋 ขั้นตอนการติดตั้ง:
echo 1. ตรวจสอบ Node.js ที่มีอยู่
echo 2. ดาวน์โหลด Node.js (ถ้าจำเป็น)
echo 3. ติดตั้ง Node.js
echo 4. ตรวจสอบการติดตั้ง
echo.

REM ตรวจสอบ Node.js ที่มีอยู่
echo 🔍 ตรวจสอบ Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js ติดตั้งแล้ว
    node --version
    echo.
    echo 🔍 ตรวจสอบ npm...
    npm --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ npm ติดตั้งแล้ว
        npm --version
        echo.
        echo 🎉 Node.js และ npm พร้อมใช้งาน!
        pause
        exit /b 0
    )
)

echo ❌ ไม่พบ Node.js หรือ npm
echo.
echo 💡 วิธีการติดตั้ง Node.js:
echo.
echo วิธีที่ 1: ดาวน์โหลดจากเว็บไซต์
echo 1. ไปที่ https://nodejs.org/
echo 2. ดาวน์โหลด Node.js LTS version
echo 3. รันไฟล์ติดตั้ง
echo 4. เปิด Command Prompt ใหม่
echo.
echo วิธีที่ 2: ใช้ Chocolatey (ถ้ามี)
echo 1. เปิด Command Prompt แบบ Administrator
echo 2. รัน: choco install nodejs
echo.
echo วิธีที่ 3: ใช้ winget (Windows 10/11)
echo 1. เปิด Command Prompt แบบ Administrator
echo 2. รัน: winget install OpenJS.NodeJS
echo.
echo หลังจากติดตั้งแล้ว ให้รันไฟล์นี้อีกครั้ง
echo.
pause 