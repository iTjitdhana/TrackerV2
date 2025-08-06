# คู่มือการ Optimize ประสิทธิภาพระบบ

## 📋 ไฟล์สคริปต์ที่สร้างขึ้น

### 1. ไฟล์ทดสอบ API Performance
- **`optimize-system.ps1`** - ทดสอบ API Performance (PowerShell)
- **`optimize-system.bat`** - ทดสอบ API Performance (Batch)

### 2. ไฟล์ทดสอบ Database Performance
- **`test-db-performance.ps1`** - ทดสอบ Database Performance แบบละเอียด

### 3. ไฟล์ Optimize Database
- **`optimize-database-indexes.sql`** - เพิ่ม Indexes สำหรับ Database

### 4. ไฟล์รัน Optimize ทั้งหมด
- **`run-optimize.ps1`** - เมนูหลักสำหรับรัน Optimize ทั้งหมด

## 🚀 วิธีการใช้งาน

### วิธีที่ 1: ใช้เมนูหลัก (แนะนำ)
```powershell
.\run-optimize.ps1
```

### วิธีที่ 2: รันแยกกัน

#### ทดสอบ API Performance:
```powershell
.\optimize-system.ps1
```

#### ทดสอบ Database Performance:
```powershell
.\test-db-performance.ps1
```

#### เพิ่ม Database Indexes:
```powershell
# รันผ่านเมนูหลัก หรือใช้ MySQL client โดยตรง
mysql -u root -p < optimize-database-indexes.sql
```

## 📊 สิ่งที่ทดสอบ

### API Performance Test
1. **Backend Connection** - ทดสอบการเชื่อมต่อ Backend
2. **Work Plans API** - ทดสอบการดึงข้อมูล Work Plans
3. **Drafts API** - ทดสอบการดึงข้อมูล Drafts
4. **Sync API** - ทดสอบการ Sync Drafts to Plans
5. **Reports API** - ทดสอบการดึงข้อมูล Reports
6. **Users API** - ทดสอบการดึงข้อมูล Users
7. **Machines API** - ทดสอบการดึงข้อมูล Machines

### Database Performance Test
1. **Work Plans Count** - ทดสอบการนับจำนวน Work Plans
2. **Work Plans By Date** - ทดสอบการดึงข้อมูลตามวันที่
3. **Drafts Query** - ทดสอบการดึงข้อมูล Drafts
4. **JOIN Query** - ทดสอบการ JOIN ข้อมูล
5. **GROUP BY Query** - ทดสอบการ GROUP BY
6. **LIKE Query** - ทดสอบการค้นหาแบบ LIKE
7. **ORDER BY Query** - ทดสอบการ ORDER BY

## 🎯 เกณฑ์การประเมิน

### API Performance
- **🚀 เร็วมาก**: น้อยกว่า 1 วินาที
- **⚡ เร็ว**: 1-3 วินาที
- **⏳ ปานกลาง**: 3-5 วินาที
- **🐌 ช้า**: มากกว่า 5 วินาที

### Database Performance
- **🚀 เร็วมาก**: น้อยกว่า 50ms
- **⚡ เร็ว**: 50-100ms
- **⏳ ปานกลาง**: 100-200ms
- **🐌 ช้า**: มากกว่า 200ms

## 🔧 การ Optimize ที่แนะนำ

### 1. Database Indexes
```sql
-- Indexes หลักที่แนะนำ
CREATE INDEX idx_work_plans_production_date ON work_plans(production_date);
CREATE INDEX idx_work_plans_job_code ON work_plans(job_code);
CREATE INDEX idx_work_plans_status_id ON work_plans(status_id);
CREATE INDEX idx_drafts_workflow_status ON work_plan_drafts(workflow_status_id);
CREATE INDEX idx_drafts_production_date ON work_plan_drafts(production_date);
```

### 2. Caching
- ใช้ Redis สำหรับ caching ข้อมูลที่เรียกบ่อย
- Cache ผลลัพธ์ของ API ที่ใช้บ่อย
- Cache ข้อมูล Users, Machines, Production Rooms

### 3. Query Optimization
- ใช้ LIMIT ใน queries ที่ไม่ต้องการข้อมูลทั้งหมด
- หลีกเลี่ยง SELECT * ใช้เฉพาะ columns ที่ต้องการ
- ใช้ EXPLAIN เพื่อตรวจสอบ query performance

### 4. Connection Pooling
- ตั้งค่า connection pool ให้เหมาะสม
- ใช้ connection pooling ใน production

## 📈 การติดตามผล

### ก่อน Optimize
1. รัน `test-db-performance.ps1`
2. บันทึกผลลัพธ์

### หลัง Optimize
1. เพิ่ม Database Indexes
2. รัน `test-db-performance.ps1` อีกครั้ง
3. เปรียบเทียบผลลัพธ์

### การเปรียบเทียบ
- เปรียบเทียบเวลาเฉลี่ย
- เปรียบเทียบเวลาสูงสุด-ต่ำสุด
- ดูจำนวน queries ที่สำเร็จ

## 🛠️ การแก้ไขปัญหา

### ปัญหา: Backend ไม่เชื่อมต่อ
```powershell
# ตรวจสอบว่า Backend รันอยู่
cd backend
npm start
```

### ปัญหา: Database ไม่เชื่อมต่อ
```powershell
# ตรวจสอบ MySQL service
net start mysql
```

### ปัญหา: Indexes ไม่สามารถเพิ่มได้
```sql
-- ตรวจสอบสิทธิ์
SHOW GRANTS FOR CURRENT_USER();

-- ตรวจสอบ Indexes ที่มีอยู่
SHOW INDEX FROM work_plans;
```

## 📝 บันทึกผลการทดสอบ

### ตัวอย่างผลลัพธ์
```
📊 สถิติโดยรวม:
   จำนวน API ที่ทดสอบ: 7
   จำนวน API ที่สำเร็จ: 7
   เวลารวม: 2450 ms
   เวลาเฉลี่ย: 350 ms

🎯 การประเมินประสิทธิภาพ:
   ⚡ ระบบทำงานเร็ว (1-3 วินาที)
```

## 🔄 การทดสอบเป็นประจำ

### ทดสอบทุกสัปดาห์
1. รัน API Performance Test
2. รัน Database Performance Test
3. บันทึกผลลัพธ์

### ทดสอบหลังการเปลี่ยนแปลง
1. ทดสอบหลังเพิ่มข้อมูลใหม่
2. ทดสอบหลังปรับปรุง code
3. ทดสอบหลังเพิ่ม features ใหม่

## 📞 การติดต่อ

หากมีปัญหาหรือต้องการความช่วยเหลือ:
1. ตรวจสอบ log ใน Backend console
2. ตรวจสอบ error messages
3. ใช้ Developer Tools ใน browser
4. ตรวจสอบ Network tab สำหรับ API calls 