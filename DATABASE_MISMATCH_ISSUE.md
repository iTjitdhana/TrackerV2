# ปัญหาความไม่ตรงกันของฐานข้อมูล

## ปัญหาที่พบ
- ระบบแสดงงานได้เพียง 50 งาน แต่ในฐานข้อมูล `esp_tracker` มี 134 งาน
- ระบบใช้ฐานข้อมูล `esp_tracker_empty` แต่ข้อมูลที่ต้องการอยู่ใน `esp_tracker`

## สาเหตุของปัญหา

### 1. การตั้งค่าฐานข้อมูล
ระบบถูกตั้งค่าให้ใช้ฐานข้อมูล `esp_tracker_empty` ในไฟล์ `backend/config/database.js`:

```javascript
database: process.env.DB_NAME || 'esp_tracker_empty',
```

### 2. ข้อมูลในฐานข้อมูล
- **esp_tracker**: มี 134 งาน (ข้อมูลที่ต้องการ)
- **esp_tracker_empty**: มีข้อมูลน้อยกว่า (ข้อมูลที่ระบบใช้)

## วิธีแก้ไข

### วิธีที่ 1: เปลี่ยนฐานข้อมูลที่ระบบใช้
แก้ไขไฟล์ `backend/config/database.js`:

```javascript
// เปลี่ยนจาก
database: process.env.DB_NAME || 'esp_tracker_empty',

// เป็น
database: process.env.DB_NAME || 'esp_tracker',
```

### วิธีที่ 2: ใช้ Environment Variable
ตั้งค่า environment variable ในไฟล์ `.env`:

```env
DB_NAME=esp_tracker
```

### วิธีที่ 3: คัดลอกข้อมูลจาก esp_tracker ไป esp_tracker_empty
```sql
-- คัดลอกข้อมูลจาก esp_tracker ไป esp_tracker_empty
INSERT INTO esp_tracker_empty.work_plans 
SELECT * FROM esp_tracker.work_plans;

-- คัดลอกข้อมูล logs
INSERT INTO esp_tracker_empty.logs 
SELECT * FROM esp_tracker.logs;
```

## การตรวจสอบ

### 1. ตรวจสอบฐานข้อมูลที่ใช้จริง
รัน SQL query ใน `check_esp_tracker_empty.sql` เพื่อดูข้อมูลในฐานข้อมูลที่ระบบใช้

### 2. ตรวจสอบการตั้งค่า
ดู log ของระบบเมื่อเริ่มต้น:
```
🔧 Database Configuration:
   Database: esp_tracker_empty
```

### 3. ตรวจสอบข้อมูลในแต่ละฐานข้อมูล
รัน SQL query ใน `check_database_job_codes.sql` เพื่อเปรียบเทียบข้อมูล

## ผลลัพธ์ที่คาดหวัง

หลังจากแก้ไขแล้ว ระบบควรแสดง:
- จำนวนงานทั้งหมด: 134 งาน
- รายการงานครบถ้วน
- สถิติที่ถูกต้อง

## หมายเหตุ

- ตรวจสอบให้แน่ใจว่าฐานข้อมูล `esp_tracker` มีข้อมูลครบถ้วน
- หากใช้วิธีที่ 3 ต้องคัดลอกข้อมูลทั้งหมดที่เกี่ยวข้อง
- หลังแก้ไขต้อง restart backend server 