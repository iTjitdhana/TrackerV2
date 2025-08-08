@echo off
echo ========================================
echo 🔧 แก้ไขปัญหา Dropdown ไม่แสดงปุ่มเพิ่มรายการใหม่
echo ========================================

echo.
echo 📋 ปัญหาที่แก้ไข:
echo - SearchBox ไม่แสดงปุ่ม "เพิ่มรายการใหม่" เมื่อไม่พบผลลัพธ์
echo - แก้ไขเงื่อนไข showAddNew ให้แสดงปุ่มเสมอเมื่อมีข้อความ
echo - ปรับโครงสร้าง dropdown ให้แสดงปุ่มเพิ่มรายการใหม่

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
echo 3. พิมพ์งานที่ไม่มีในระบบ เช่น "น้ำจิ้มเต้าเจี้ยว-ปลาจุ่ม 75 กรัม"
echo 4. ควรเห็นปุ่ม "➕ เพิ่มรายการใหม่" แสดงขึ้นมา
echo.
echo 💡 ถ้ายังไม่เห็นปุ่ม ให้:
echo - ตรวจสอบ Console ใน Browser (F12)
echo - ตรวจสอบ Network tab ว่าการเรียก API สำเร็จ
echo - ลองรีเฟรชหน้าเว็บ (Ctrl+F5)
echo.
pause
