# ระบบจัดการ Logs - คู่มือการใช้งาน

## 🎯 ภาพรวม
ระบบจัดการ Logs เป็นหน้าเว็บที่สร้างขึ้นเพื่อดูและแก้ไขข้อมูลในตาราง `logs` ซึ่งเก็บข้อมูลการทำงานของแต่ละงาน เช่น งานไหนเริ่มกี่โมง เสร็จกี่โมง

## 🚀 การเริ่มต้นระบบ

### วิธีที่ 1: ใช้ไฟล์ Batch (แนะนำ)
```bash
# เริ่มต้นระบบทั้งหมด
start-logs-system.bat

# ตรวจสอบสถานะระบบ
check-logs-system.bat
```

### วิธีที่ 2: เริ่มต้นด้วยตนเอง
```bash
# 1. เริ่มต้น Backend
cd backend
npm install
npm start

# 2. เริ่มต้น Frontend (ใน terminal ใหม่)
cd frontend
npm install
npm run dev
```

## 📱 การเข้าถึงระบบ

### URLs หลัก
- **Dashboard**: http://localhost:3011/dashboard
- **หน้า Logs**: http://localhost:3011/logs
- **แผนการผลิต**: http://localhost:3011/
- **ติดตามการผลิต**: http://localhost:3011/tracker

### การนำทาง
1. ไปที่หน้า Dashboard: `http://localhost:3011/dashboard`
2. คลิกที่ "ระบบจัดการ Logs" หรือไปที่ `/logs`

## 🎨 คุณสมบัติหลัก

### 1. ดูข้อมูล Logs
- ✅ แสดงรายการ Logs ทั้งหมดในรูปแบบตาราง
- ✅ แสดงข้อมูล: ID, งาน, หมายเลขกระบวนการ, สถานะ, เวลา, คำอธิบาย
- ✅ รองรับการกรองข้อมูลตาม:
  - งาน (Work Plan)
  - วันที่
  - สถานะ (เริ่มงาน/หยุดงาน)
  - รหัสงาน

### 2. เพิ่ม Log ใหม่
- ✅ เพิ่ม Log ใหม่ผ่าน Modal Dialog
- ✅ เลือกงานจากรายการ Work Plans
- ✅ ระบุหมายเลขกระบวนการ
- ✅ เลือกสถานะ (เริ่มงาน/หยุดงาน)
- ✅ กำหนดเวลาเริ่มต้น/สิ้นสุด

### 3. แก้ไข Log
- ✅ แก้ไขข้อมูล Log ที่มีอยู่
- ✅ อัปเดตงาน, หมายเลขกระบวนการ, สถานะ, เวลา
- ✅ บันทึกการเปลี่ยนแปลง

### 4. ลบ Log
- ✅ ลบ Log ที่ไม่ต้องการ
- ✅ มีการยืนยันก่อนลบ

## 🗄️ โครงสร้างข้อมูล

### ตาราง Logs
```sql
CREATE TABLE `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `work_plan_id` int DEFAULT NULL,
  `process_number` int DEFAULT NULL,
  `status` enum('start','stop') NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `work_plan_id` (`work_plan_id`),
  CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`work_plan_id`) REFERENCES `work_plans` (`id`) ON DELETE CASCADE
);
```

### ความหมายของฟิลด์
- `id`: รหัส Log (Auto Increment)
- `work_plan_id`: รหัสงาน (เชื่อมโยงกับตาราง work_plans)
- `process_number`: หมายเลขกระบวนการ
- `status`: สถานะ ('start' = เริ่มงาน, 'stop' = หยุดงาน)
- `timestamp`: เวลาที่บันทึก Log

## 🔧 API Endpoints

### Backend API (Node.js - Port 3001)
- `GET /api/logs` - ดึงข้อมูล Logs ทั้งหมด
- `GET /api/logs/:id` - ดึงข้อมูล Log ตาม ID
- `POST /api/logs` - สร้าง Log ใหม่
- `PUT /api/logs/:id` - อัปเดต Log
- `DELETE /api/logs/:id` - ลบ Log

### Frontend API (Next.js - Port 3011)
- `GET /api/logs` - Proxy ไปยัง Backend API
- `POST /api/logs` - Proxy ไปยัง Backend API
- `PUT /api/logs/[id]` - Proxy ไปยัง Backend API
- `DELETE /api/logs/[id]` - Proxy ไปยัง Backend API

## 📖 การใช้งาน

### 1. ดูข้อมูล Logs
1. เข้าไปที่หน้า `/logs`
2. ระบบจะแสดงรายการ Logs ทั้งหมด
3. ใช้ตัวกรองด้านบนเพื่อกรองข้อมูลตามต้องการ

### 2. เพิ่ม Log ใหม่
1. คลิกปุ่ม "เพิ่ม Log" ที่มุมขวาบน
2. กรอกข้อมูลในฟอร์ม:
   - เลือกงาน
   - ระบุหมายเลขกระบวนการ
   - เลือกสถานะ
   - กำหนดเวลา
3. คลิก "เพิ่ม Log"

### 3. แก้ไข Log
1. คลิกปุ่ม "แก้ไข" (ไอคอนดินสอ) ในแถวที่ต้องการ
2. แก้ไขข้อมูลในฟอร์ม
3. คลิก "บันทึกการเปลี่ยนแปลง"

### 4. ลบ Log
1. คลิกปุ่ม "ลบ" (ไอคอนถังขยะ) ในแถวที่ต้องการ
2. ยืนยันการลบ

## 🎨 การแสดงผล

### สถานะ
- 🟢 **เริ่มงาน** (start) - แสดงด้วย Badge สีเขียว
- 🔴 **หยุดงาน** (stop) - แสดงด้วย Badge สีแดง

### เวลา
- แสดงในรูปแบบ `dd/MM/yyyy HH:mm:ss` (ภาษาไทย)
- ใช้ timezone ของประเทศไทย

### งาน
- แสดงในรูปแบบ `รหัสงาน - ชื่องาน`
- หากไม่มีข้อมูลงาน จะแสดง `ID: [work_plan_id]`

## 🔧 การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

#### 1. ไม่สามารถเชื่อมต่อ API ได้
**อาการ**: หน้าเว็บแสดง "Failed to fetch logs"
**วิธีแก้**:
- ตรวจสอบว่า Backend server ทำงานอยู่ที่ port 3001
- รัน `check-logs-system.bat` เพื่อตรวจสอบสถานะ
- ตรวจสอบไฟล์ `.env.local` ใน frontend

#### 2. ไม่แสดงข้อมูล Logs
**อาการ**: ตารางแสดง "ไม่พบข้อมูล Logs"
**วิธีแก้**:
- ตรวจสอบการเชื่อมต่อฐานข้อมูล MySQL
- ตรวจสอบว่าตาราง `logs` มีข้อมูล
- ตรวจสอบ foreign key constraints

#### 3. ไม่สามารถเพิ่ม/แก้ไข Log ได้
**อาการ**: แสดง error เมื่อบันทึกข้อมูล
**วิธีแก้**:
- ตรวจสอบ validation rules
- ตรวจสอบ foreign key constraints
- ตรวจสอบ console ใน browser

#### 4. หน้าเว็บไม่โหลด
**อาการ**: หน้าเว็บแสดง error หรือไม่โหลด
**วิธีแก้**:
- ตรวจสอบว่า Frontend server ทำงานอยู่ที่ port 3011
- ตรวจสอบ dependencies: `npm install`
- ตรวจสอบ TypeScript errors

### การ Debug
```bash
# ตรวจสอบ Backend logs
cd backend
npm start

# ตรวจสอบ Frontend logs
cd frontend
npm run dev

# ตรวจสอบ Database
mysql -u root -p
USE your_database_name;
SELECT * FROM logs LIMIT 10;
```

## 📁 โครงสร้างไฟล์

```
Frontend_workplanV3.4Deploy/
├── backend/
│   ├── controllers/
│   │   └── logController.js
│   ├── models/
│   │   └── Log.js
│   ├── routes/
│   │   └── logRoutes.js
│   └── server.js
├── frontend/
│   ├── app/
│   │   ├── logs/
│   │   │   └── page.tsx
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── api/
│   │   │   ├── logs/
│   │   │   │   ├── route.ts
│   │   │   │   └── [id]/
│   │   │   │       └── route.ts
│   │   │   └── work-plans/
│   │   │       └── route.ts
│   │   └── layout.tsx
│   └── components/
│       └── Navigation.tsx
├── start-logs-system.bat
├── check-logs-system.bat
└── LOGS_SYSTEM_README.md
```

## 🚀 การพัฒนาต่อ

### คุณสมบัติที่อาจเพิ่มในอนาคต
- 📊 การส่งออกข้อมูลเป็น Excel/PDF
- 📈 กราฟแสดงสถิติการทำงาน
- 🔔 การแจ้งเตือนเมื่องานล่าช้า
- 🔗 การเชื่อมโยงกับระบบอื่นๆ
- 👥 การจัดการสิทธิ์ผู้ใช้
- 📱 Mobile App
- 🔍 การค้นหาขั้นสูง
- 📅 Calendar View

## 📞 การสนับสนุน

หากมีปัญหาหรือคำถาม สามารถ:
1. ตรวจสอบไฟล์ `LOGS_PAGE_GUIDE.md` สำหรับรายละเอียดเพิ่มเติม
2. รัน `check-logs-system.bat` เพื่อตรวจสอบสถานะระบบ
3. ตรวจสอบ console ใน browser สำหรับ error messages
4. ติดต่อทีมพัฒนา

---

**หมายเหตุ**: ระบบนี้ใช้ Next.js 15, React 19, และ Tailwind CSS สำหรับ frontend และ Node.js สำหรับ backend 