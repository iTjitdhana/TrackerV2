@echo off
echo ========================================
echo 🔧 แก้ไขปัญหา Draft Delete ไม่ทำงาน
echo ========================================

echo.
echo 📋 ปัญหาที่แก้ไข:
echo - Frontend ส่ง ID เป็น "draft_1753" แต่ backend ต้องการ "1753"
echo - Error: "Truncated incorrect INTEGER value: 'draft_1753'"
echo - แก้ไขโดยแยก ID จาก format "draft_1753" เป็น "1753"

echo.
echo 🔧 รีสตาร์ทระบบ...
echo.

echo 1. หยุดระบบปัจจุบัน...
taskkill /f /im node.exe >nul 2>&1
timeout /t 2 >nul

echo 2. รันระบบใหม่...
start "Backend" cmd /k "cd backend && npm run dev"
timeout /t 3 >nul

echo 3. รัน Frontend...
start "Frontend" cmd /k "cd frontend && npm run dev"
timeout /t 5 >nul

echo.
echo ✅ ระบบรีสตาร์ทเสร็จแล้ว!
echo.
echo 📋 การทดสอบ:
echo 1. เปิด http://localhost:3011
echo 2. ไปที่หน้าเพิ่มงานผลิต
echo 3. สร้างงานใหม่หรือเลือกงานที่มีอยู่
echo 4. ลองลบงาน Draft
echo 5. ควรลบได้โดยไม่มี error
echo.
echo 💡 ถ้ายังมีปัญหา ให้:
echo - ตรวจสอบ Console ใน Browser (F12)
echo - ตรวจสอบ Network tab ว่าการเรียก API สำเร็จ
echo - ตรวจสอบ Backend console ว่ามี error หรือไม่
echo.
pause
