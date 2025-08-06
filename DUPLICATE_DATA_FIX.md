# การแก้ไขปัญหาข้อมูลซ้ำในรายงาน

## ปัญหาที่พบ
- ข้อมูลในตารางแสดงงานเดียวกันหลายครั้ง
- งาน "235222 ซี่โครงตุ๋น 170 กรัม" ปรากฏ 3 ครั้งด้วยสถิติที่แตกต่างกัน
- การคำนวณ job_statistics ไม่ถูกต้อง

## สาเหตุของปัญหา

### 1. การจัดกลุ่มงานไม่ถูกต้อง
โค้ดเดิมจัดกลุ่มงานตาม `job_code` อย่างเดียว:
```javascript
// จัดกลุ่มงานตาม job_code
jobs.forEach(job => {
  if (job.job_code) {
    if (!jobMap.has(job.job_code)) {
      jobMap.set(job.job_code, []);
    }
    jobMap.get(job.job_code).push(job);
  }
});
```

ปัญหาคือ:
- งานเดียวกันอาจมี `job_name` ที่แตกต่างกัน
- ข้อมูลอาจถูกบันทึกหลายครั้งด้วยข้อมูลที่แตกต่างกัน
- การจัดกลุ่มตาม `job_code` อย่างเดียวทำให้ได้ข้อมูลไม่ครบถ้วน

### 2. ข้อมูลในฐานข้อมูลซ้ำกัน
- งานเดียวกันอาจถูกบันทึกหลายครั้ง
- `job_name` อาจแตกต่างกันสำหรับ `job_code` เดียวกัน
- ข้อมูลอาจถูกอัปเดตหลายครั้ง

## การแก้ไขที่ทำ

### 1. ปรับปรุงการจัดกลุ่มงาน
แก้ไขในไฟล์ `backend/routes/reportRoutes.js`:

```javascript
// ก่อนแก้ไข
// จัดกลุ่มงานตาม job_code
jobs.forEach(job => {
  if (job.job_code) {
    if (!jobMap.has(job.job_code)) {
      jobMap.set(job.job_code, []);
    }
    jobMap.get(job.job_code).push(job);
  }
});

// หลังแก้ไข
// จัดกลุ่มงานตาม job_code และ job_name ร่วมกัน
jobs.forEach(job => {
  if (job.job_code && job.job_name) {
    const key = `${job.job_code}_${job.job_name}`;
    if (!jobMap.has(key)) {
      jobMap.set(key, {
        job_code: job.job_code,
        job_name: job.job_name,
        jobs: []
      });
    }
    jobMap.get(key).jobs.push(job);
  }
});
```

### 2. เพิ่มการเรียงลำดับ
เพิ่มการเรียงลำดับตาม frequency จากมากไปน้อย:
```javascript
// เรียงลำดับตาม frequency จากมากไปน้อย
jobStats.sort((a, b) => b.frequency - a.frequency);
```

### 3. เพิ่มการ Log เพื่อตรวจสอบ
เพิ่มการ log เพื่อตรวจสอบการจัดกลุ่ม:
```javascript
console.log('📊 Sample job statistics:', jobStatistics.slice(0, 3));
```

## ไฟล์ SQL สำหรับการตรวจสอบ

### `check_duplicate_jobs.sql`
- ตรวจสอบ job_code ที่ซ้ำกัน
- ตรวจสอบ job_code และ job_name ที่ซ้ำกัน
- ตรวจสอบข้อมูลที่ซ้ำกันของ job_code เฉพาะ
- ตรวจสอบ job_name ที่แตกต่างกันสำหรับ job_code เดียวกัน

## ผลลัพธ์ที่คาดหวัง

หลังจากแก้ไขแล้ว:
- งานเดียวกันจะแสดงเพียงครั้งเดียว
- สถิติจะถูกคำนวณจากข้อมูลทั้งหมดของงานนั้น
- ไม่มีข้อมูลซ้ำกันในรายงาน

## การทดสอบ

### 1. รัน SQL Queries
รัน queries ในไฟล์ `check_duplicate_jobs.sql` เพื่อตรวจสอบข้อมูลที่ซ้ำกัน

### 2. ทดสอบหน้า Reports
- เปิดหน้า Reports
- สร้างรายงาน
- ตรวจสอบว่าไม่มีข้อมูลซ้ำกัน

### 3. ตรวจสอบ Logs
ดู logs ของ backend เพื่อตรวจสอบ:
```
📊 Job statistics calculated: [จำนวน] unique job types
📊 Sample job statistics: [ตัวอย่างข้อมูล]
```

## หมายเหตุ

- การจัดกลุ่มตาม `job_code` และ `job_name` ร่วมกันจะทำให้ได้ข้อมูลที่แม่นยำมากขึ้น
- หากยังมีข้อมูลซ้ำกัน อาจต้องตรวจสอบข้อมูลในฐานข้อมูล
- การเรียงลำดับตาม frequency จะทำให้งานที่ผลิตบ่อยแสดงก่อน 