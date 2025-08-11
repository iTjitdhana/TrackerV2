# การปรับปรุงระบบรายงานสถิติงาน

## 🎯 ปัญหาที่แก้ไข

### ปัญหาเดิม:
1. **มีข้อมูลใน Database แต่ไม่แสดง** - งานที่มี logs แต่ไม่แสดงว่าเสร็จสิ้น
2. **แสดงข้อมูลงานที่ผลิตซ้ำกัน** - การนับความถี่ผิด เนื่องจากนับ work_plans ซ้ำ

## 🔧 การแก้ไขที่ทำ

### 1. ปรับปรุงการประมวลผล Logs (`reportRoutes.js`)

#### เดิม:
```javascript
const startLog = logs.find(log => log.status === 'start');
const stopLog = logs.find(log => log.status === 'stop');
```

#### ใหม่:
```javascript
const getCompletedDuration = (logs) => {
  const startLogs = logs.filter(log => log.status === 'start').sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  const stopLogs = logs.filter(log => log.status === 'stop').sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  
  // จับคู่ start-stop logs อย่างถูกต้อง
  for (let i = 0; i < Math.min(startLogs.length, stopLogs.length); i++) {
    // คำนวณเวลารวมจากหลายรอบ
  }
}
```

**ผลลัพธ์:** แก้ปัญหางานที่มี logs หลายรอบแต่ไม่แสดงเป็นเสร็จสิ้น

### 2. ปรับปรุงการจัดกลุ่มข้อมูล (`calculateJobStatistics`)

#### เดิม:
```javascript
// จัดกลุ่มตาม job_code เท่านั้น
const key = job.job_code;
frequency: jobGroup.jobs.length // นับ work_plans ทั้งหมด
```

#### ใหม่:
```javascript
// ใช้ Set เพื่อหลีกเลี่ยงการนับซ้ำ
unique_productions: new Set(),
production_dates: new Set(),

// สร้าง unique key
const uniqueKey = `${job.job_code}_${job.production_date}_${job.work_plan_id}`;
jobGroup.unique_productions.add(uniqueKey);

frequency: actualFrequency = jobGroup.unique_productions.size
```

**ผลลัพธ์:** แก้ปัญหาการนับงานซ้ำ และแสดงความถี่ที่ถูกต้อง

### 3. ปรับปรุง SQL Query

#### เดิม:
```sql
SELECT wp.id, wp.job_code, wp.job_name...
FROM work_plans wp
LEFT JOIN production_rooms pr ON wp.production_room_id = pr.id
```

#### ใหม่:
```sql
SELECT DISTINCT wp.id, wp.job_code, wp.job_name...
FROM work_plans wp
LEFT JOIN production_rooms pr ON wp.production_room_id = pr.id
WHERE wp.job_code IS NOT NULL 
  AND wp.job_code != ''
  AND wp.job_name IS NOT NULL 
  AND wp.job_name != ''
ORDER BY wp.production_date DESC, wp.job_code ASC
```

**ผลลัพธ์:** กรองข้อมูลที่ไม่สมบูรณ์และเรียงลำดับที่เหมาะสม

### 4. เพิ่มสถานะงานที่ละเอียดขึ้น

#### เดิม:
- เสร็จสิ้น / ไม่เสร็จสิ้น

#### ใหม่:
- **ไม่เริ่มงาน** - ไม่มี logs เลย
- **เสร็จสิ้น** - มี completed sessions
- **กำลังดำเนินการ** - มี start logs แต่ยังไม่มี stop logs
- **เริ่มแล้วแต่ไม่เสร็จ** - มี logs แต่ไม่มี completed sessions

### 5. เพิ่ม Debug Logging

เพิ่ม console.log เพื่อติดตามการทำงาน:
- จำนวน logs ของแต่ละ work plan
- การคำนวณ duration แต่ละ session
- สถิติการจัดกลุ่มงาน
- ผลลัพธ์สุดท้าย

## 📊 ข้อมูลใหม่ที่เพิ่มเข้ามา

### Response Structure ใหม่:
```json
{
  "summary": {
    "total_jobs": 100,
    "completed_jobs": 75,
    "in_progress_jobs": 15,
    "not_started_jobs": 10,
    "jobs_with_completed_sessions": 75
  },
  "job_statistics": [
    {
      "job_code": "12345",
      "job_name": "งานตัวอย่าง",
      "frequency": 5,                    // จำนวนการผลิตที่ไม่ซ้ำ
      "total_work_plans": 8,             // จำนวน work plans ทั้งหมด
      "production_dates_count": 3,        // จำนวนวันที่ผลิต
      "total_completed": 4,
      "total_with_logs": 6,
      "accuracy_rate": 80
    }
  ]
}
```

## 🧪 การทดสอบ

### ไฟล์ทดสอบ:
- `test-improved-reports.js` - ทดสอบ API
- `test-improved-reports.bat` - เรียกใช้ทดสอบ

### วิธีทดสอบ:
```bash
# 1. เรียกใช้ batch file
./test-improved-reports.bat

# 2. หรือทดสอบด้วยตนเอง
node test-improved-reports.js

# 3. ทดสอบผ่าน browser
http://localhost:3000/reports

# 4. ทดสอบ API โดยตรง
curl "http://localhost:3001/api/reports/production-analysis?limit=10000"
```

## 🎯 ผลลัพธ์ที่คาดหวัง

### ก่อนปรับปรุง:
- งานที่มี logs แต่ไม่แสดงเป็นเสร็จสิ้น
- ความถี่งานผิด (นับซ้ำ)
- ข้อมูลสถิติไม่ตรงกับความเป็นจริง

### หลังปรับปรุง:
- ✅ งานที่มี logs แสดงสถานะที่ถูกต้อง
- ✅ ความถี่งานแสดงจำนวนการผลิตจริง
- ✅ สถิติตรงกับข้อมูลใน database
- ✅ มี debug information สำหรับการแก้ปัญหา

## 🔍 การตรวจสอบเพิ่มเติม

### SQL queries สำหรับตรวจสอบ:
```sql
-- ตรวจสอบงานซ้ำ
SELECT job_code, COUNT(*) as count 
FROM work_plans 
GROUP BY job_code 
HAVING COUNT(*) > 1;

-- ตรวจสอบงานที่มี logs
SELECT wp.job_code, wp.job_name, COUNT(l.id) as log_count
FROM work_plans wp
LEFT JOIN logs l ON wp.id = l.work_plan_id
GROUP BY wp.id
HAVING log_count > 0;
```

## 🚀 การใช้งาน

ระบบจะทำงานโดยอัตโนมัติหลังจากการปรับปรุง ไม่ต้องเปลี่ยนแปลงอะไรใน frontend เนื่องจาก API response structure ยังคงเดิม แต่เพิ่มข้อมูลใหม่เข้าไป

### สำหรับผู้ใช้:
- เข้าไปที่หน้า Reports ตามปกติ
- ข้อมูลจะแสดงความถี่และสถานะที่ถูกต้องขึ้น

### สำหรับ Developer:
- ดู console logs เพื่อ debug
- ใช้ test files เพื่อตรวจสอบการทำงาน
- ตรวจสอบ API response ใหม่