# WorkplansV4 - คู่มือการติดตั้งและใช้งาน

## 🚀 การติดตั้งครั้งแรก

### 1. Clone Repository จาก GitHub
```bash
git clone https://github.com/iTjitdhana/WorkplansV4.git
cd WorkplansV4
```

### 2. ติดตั้ง Dependencies

#### Backend
```bash
cd backend
npm install
```

#### Frontend
```bash
cd frontend
npm install
```

### 3. ตั้งค่าฐานข้อมูล MySQL
- สร้างฐานข้อมูลชื่อ `esp_tracker`
- Import ไฟล์ `backend/esp_tracker (6).sql`
- ตรวจสอบการตั้งค่าในไฟล์ `backend/config/database.js`

### 4. การรันระบบ

#### วิธีที่ 1: ใช้ Script อัตโนมัติ (แนะนำ)

**Windows:**
```bash
start-dev.bat
```

**Linux/Mac:**
```bash
./start-dev.sh
```

#### วิธีที่ 2: รันแยกกัน

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

## 🌐 การเข้าถึงระบบ

- **หน้าหลัก (แผนการผลิต)**: http://192.168.0.94:3011
- **หน้า Tracker**: http://192.168.0.94:3011/tracker
- **Backend API**: http://192.168.0.94:3101

## 📱 การใช้งานระบบ

### 1. หน้าแผนการผลิต (http://192.168.0.94:3011)
- สร้างแผนการผลิตใหม่
- แก้ไขแบบร่าง
- ดูแผนการผลิตรายวัน/รายสัปดาห์
- ส่งข้อมูลไป Google Sheets

### 2. หน้า Tracker (http://192.168.0.94:3011/tracker)
- ติดตามการทำงานแบบเรียลไทม์
- บันทึกเวลาเริ่ม/หยุดงาน
- ดูสถิติการทำงาน

## 🔧 การแก้ไขปัญหาเบื้องต้น

### Backend ไม่เริ่มต้น
1. ตรวจสอบ Port 3101 ว่าว่างหรือไม่
2. ตรวจสอบการเชื่อมต่อฐานข้อมูล MySQL
3. ตรวจสอบไฟล์ `backend/config/database.js`

### Frontend ไม่เริ่มต้น
1. ตรวจสอบ Port 3011 ว่าว่างหรือไม่
2. ลบโฟลเดอร์ `.next` และรันใหม่
3. ตรวจสอบ Node.js version (ต้อง 18+)

### API ไม่ทำงาน
1. ตรวจสอบ CORS settings ใน `backend/server.js`
2. ตรวจสอบ IP Address configuration
3. ตรวจสอบ firewall settings

## 📊 ฐานข้อมูล

### ตารางหลัก
- `work_plans` - แผนการผลิต
- `work_plan_drafts` - แบบร่างแผนการผลิต
- `users` - ผู้ใช้งาน
- `machines` - เครื่องจักร
- `production_rooms` - ห้องผลิต
- `process_steps` - ขั้นตอนการผลิต
- `logs` - บันทึกการทำงาน

## 🔄 การอัพเดทระบบ

```bash
git pull origin main
cd backend && npm install
cd ../frontend && npm install
```

## 📞 การติดต่อสอบถาม

- แผนกเทคโนโลยีสารสนเทศ
- บริษัท จิตต์ธนา จำกัด (สำนักงานใหญ่)

---
**อัพเดทล่าสุด**: มกราคม 2025 