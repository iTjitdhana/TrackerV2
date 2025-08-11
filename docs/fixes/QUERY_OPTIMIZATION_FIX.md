# การแก้ไขปัญหา Query ที่ทำให้ได้ข้อมูลไม่ครบ

## ปัญหาที่พบ
- ฐานข้อมูล `esp_tracker_empty` มี 134 งาน
- แต่หน้าเว็บแสดงแค่ 50 งาน
- ปัญหาเกิดจากการ query ที่ใช้ `ORDER BY` ที่อาจทำให้ได้ข้อมูลไม่ครบ

## สาเหตุของปัญหา

### 1. การใช้ ORDER BY ใน Query หลัก
Query เดิมใช้:
```sql
ORDER BY wp.production_date DESC, wp.start_time ASC
```

ซึ่งอาจทำให้:
- ได้เฉพาะข้อมูลล่าสุด
- มีปัญหาเรื่อง timezone conversion
- ข้อมูลที่มี `production_date` เป็น NULL จะถูกเรียงลำดับไม่ถูกต้อง

### 2. การใช้ LIMIT กับ ORDER BY
การใช้ `ORDER BY` ร่วมกับ `LIMIT` อาจทำให้ได้ข้อมูลไม่ครบถ้วน

## การแก้ไขที่ทำ

### 1. ลบ ORDER BY ออกจาก Query หลัก
แก้ไขในไฟล์ `backend/routes/reportRoutes.js`:

```javascript
// ก่อนแก้ไข
const analysisQuery = `
  SELECT 
    wp.id as work_plan_id,
    wp.job_code,
    wp.job_name,
    ...
  FROM work_plans wp
  LEFT JOIN production_rooms pr ON wp.production_room_id = pr.id
  ORDER BY wp.production_date DESC, wp.start_time ASC
  LIMIT ${safeLimit}
`;

// หลังแก้ไข
const analysisQuery = `
  SELECT 
    wp.id as work_plan_id,
    wp.job_code,
    wp.job_name,
    ...
  FROM work_plans wp
  LEFT JOIN production_rooms pr ON wp.production_room_id = pr.id
  LIMIT ${safeLimit}
`;
```

### 2. เพิ่มการ Log เพื่อตรวจสอบ
เพิ่มการ log เพื่อตรวจสอบจำนวนข้อมูลที่ได้:

```javascript
console.log('📊 Total work plans processed:', jobsWithLogs.length);
console.log('📊 Unique job codes found:', new Set(jobsWithLogs.map(job => job.job_code)).size);
```

## ไฟล์ SQL สำหรับการตรวจสอบ

### 1. `debug_query_issue.sql`
- ตรวจสอบปัญหาการ query
- ทดสอบ query ที่ระบบใช้จริง
- ตรวจสอบข้อมูล production_date

### 2. `check_job_statistics_calculation.sql`
- ตรวจสอบการคำนวณ job statistics
- ตรวจสอบ job_code ที่มีปัญหา
- ตรวจสอบ records ที่ไม่มี production_date

## ผลลัพธ์ที่คาดหวัง

หลังจากแก้ไขแล้ว:
- ระบบควรแสดงงานทั้งหมด 134 งาน
- ไม่มีปัญหาเรื่อง ORDER BY
- ข้อมูลครบถ้วนมากขึ้น

## การทดสอบ

### 1. รัน SQL Queries
รัน queries ในไฟล์ `debug_query_issue.sql` และ `check_job_statistics_calculation.sql` เพื่อตรวจสอบข้อมูล

### 2. ทดสอบหน้า Reports
- เปิดหน้า Reports
- สร้างรายงาน
- ตรวจสอบจำนวนงานที่แสดง

### 3. ตรวจสอบ Logs
ดู logs ของ backend เพื่อตรวจสอบ:
```
📊 Total work plans processed: [จำนวน]
📊 Unique job codes found: [จำนวน]
📊 Job statistics calculated: [จำนวน] unique job types
```

## หมายเหตุ

- การลบ ORDER BY อาจทำให้ข้อมูลไม่เรียงลำดับตามวันที่
- การเรียงลำดับจะทำใน frontend แทน
- หากยังมีปัญหา อาจต้องตรวจสอบการคำนวณ job_statistics ในฟังก์ชัน `calculateJobStatistics` 