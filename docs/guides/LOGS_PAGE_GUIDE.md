# ระบบจัดการ Logs - คู่มือการใช้งาน

## ภาพรวม
ระบบจัดการ Logs เป็นหน้าเว็บที่สร้างขึ้นเพื่อดูและแก้ไขข้อมูลในตาราง `logs` ซึ่งเก็บข้อมูลการทำงานของแต่ละงาน เช่น งานไหนเริ่มกี่โมง เสร็จกี่โมง

## คุณสมบัติหลัก

### 1. ดูข้อมูล Logs
- แสดงรายการ Logs ทั้งหมดในรูปแบบตาราง
- แสดงข้อมูล: ID, งาน, หมายเลขกระบวนการ, สถานะ, เวลา, คำอธิบาย
- รองรับการกรองข้อมูลตาม:
  - งาน (Work Plan)
  - วันที่
  - สถานะ (เริ่มงาน/หยุดงาน)
  - รหัสงาน

### 2. เพิ่ม Log ใหม่
- เพิ่ม Log ใหม่ผ่าน Modal Dialog
- เลือกงานจากรายการ Work Plans
- ระบุหมายเลขกระบวนการ
- เลือกสถานะ (เริ่มงาน/หยุดงาน)
- กำหนดเวลาเริ่มต้น/สิ้นสุด

### 3. แก้ไข Log
- แก้ไขข้อมูล Log ที่มีอยู่
- อัปเดตงาน, หมายเลขกระบวนการ, สถานะ, เวลา
- บันทึกการเปลี่ยนแปลง

### 4. ลบ Log
- ลบ Log ที่ไม่ต้องการ
- มีการยืนยันก่อนลบ

## การเข้าถึง

### URL
```
http://localhost:3000/logs
```

### การนำทาง
1. ไปที่หน้า Dashboard: `http://localhost:3000/dashboard`
2. คลิกที่ "ระบบจัดการ Logs" หรือไปที่ `/logs`

## โครงสร้างข้อมูล

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

## API Endpoints

### Backend API (Node.js)
- `GET /api/logs` - ดึงข้อมูล Logs ทั้งหมด
- `GET /api/logs/:id` - ดึงข้อมูล Log ตาม ID
- `POST /api/logs` - สร้าง Log ใหม่
- `PUT /api/logs/:id` - อัปเดต Log
- `DELETE /api/logs/:id` - ลบ Log

### Frontend API (Next.js)
- `GET /api/logs` - Proxy ไปยัง Backend API
- `POST /api/logs` - Proxy ไปยัง Backend API
- `PUT /api/logs/[id]` - Proxy ไปยัง Backend API
- `DELETE /api/logs/[id]` - Proxy ไปยัง Backend API

## การใช้งาน

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

## การแสดงผล

### สถานะ
- 🟢 **เริ่มงาน** (start) - แสดงด้วย Badge สีเขียว
- 🔴 **หยุดงาน** (stop) - แสดงด้วย Badge สีแดง

### เวลา
- แสดงในรูปแบบ `dd/MM/yyyy HH:mm:ss` (ภาษาไทย)
- ใช้ timezone ของประเทศไทย

### งาน
- แสดงในรูปแบบ `รหัสงาน - ชื่องาน`
- หากไม่มีข้อมูลงาน จะแสดง `ID: [work_plan_id]`

## การติดตั้งและรัน

### 1. Backend (Node.js)
```bash
cd backend
npm install
npm start
```

### 2. Frontend (Next.js)
```bash
cd frontend
npm install
npm run dev
```

### 3. ฐานข้อมูล
- ตรวจสอบให้แน่ใจว่า MySQL ทำงานอยู่
- รัน SQL script สำหรับสร้างตาราง logs (หากยังไม่มี)

## การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

1. **ไม่สามารถเชื่อมต่อ API ได้**
   - ตรวจสอบว่า Backend server ทำงานอยู่
   - ตรวจสอบ URL ใน environment variables

2. **ไม่แสดงข้อมูล Logs**
   - ตรวจสอบการเชื่อมต่อฐานข้อมูล
   - ตรวจสอบว่าตาราง logs มีข้อมูล

3. **ไม่สามารถเพิ่ม/แก้ไข Log ได้**
   - ตรวจสอบ validation rules
   - ตรวจสอบ foreign key constraints

## การพัฒนาต่อ

### คุณสมบัติที่อาจเพิ่มในอนาคต
- การส่งออกข้อมูลเป็น Excel/PDF
- กราฟแสดงสถิติการทำงาน
- การแจ้งเตือนเมื่องานล่าช้า
- การเชื่อมโยงกับระบบอื่นๆ
- การจัดการสิทธิ์ผู้ใช้

## การสนับสนุน

หากมีปัญหาหรือคำถาม สามารถติดต่อทีมพัฒนาได้ 