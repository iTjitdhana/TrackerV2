# ระบบเวลาการผลิต (Production Times System)

## ภาพรวม

ระบบเวลาการผลิตถูกสร้างขึ้นเพื่อดึงข้อมูล logs จาก database อีกตัว (192.168.0.93) และแสดงเวลาการผลิตแต่ละครั้ง พร้อมกับสถิติและรายงานสรุปรายวัน

## Logic การทำงาน

### 🔄 ขั้นตอนการดึงข้อมูล

1. **ดึงข้อมูลจาก Database หลัก (192.168.0.94)**
   - ดึงข้อมูล work_plans ตามเงื่อนไขที่กำหนด (วันที่, job_code, work_plan_id)
   - ได้ข้อมูล: id, job_code, job_name, production_date, start_time, end_time

2. **เทียบข้อมูลกับ Database Logs (192.168.0.93)**
   - ใช้ job_code และ production_date เพื่อหา work_plan ที่ตรงกัน
   - ได้ work_plan_id ที่ตรงกันใน database logs

3. **ดึงข้อมูล Logs และคำนวณเวลา**
   - ใช้ work_plan_id ที่ได้ไปดึงข้อมูล logs
   - คำนวณเวลาจาก start/stop logs
   - จัดกลุ่มตาม process_number

### 📊 การคำนวณเวลา

```javascript
// ตัวอย่าง Logic
for (const workPlan of workPlans) {
  // 1. หา work_plan ที่ตรงกันใน logs database
  const matchingWorkPlans = await logsConnection.execute(`
    SELECT id FROM work_plans 
    WHERE job_code = ? AND DATE(production_date) = ?
  `, [workPlan.job_code, workPlan.production_date]);

  if (matchingWorkPlans.length > 0) {
    const targetWorkPlan = matchingWorkPlans[0];
    
    // 2. ดึง logs สำหรับ work plan นี้
    const logs = await logsConnection.execute(`
      SELECT * FROM logs WHERE work_plan_id = ?
    `, [targetWorkPlan.id]);

    // 3. คำนวณเวลา
    const processGroups = groupLogsByProcess(logs);
    const durations = calculateDurations(processGroups);
  }
}
```

## ฟีเจอร์หลัก

### 1. หน้าวิชาการผลิต (`/production-times`)
- แสดงรายละเอียดเวลาการผลิตแต่ละครั้ง
- ค้นหาตามวันที่ผลิต, Work Plan ID, หรือ Job Code
- แสดงข้อมูล Raw Logs
- คำนวณเวลารวมของแต่ละงาน

### 2. หน้าสถิติ (`/production-times/stats`)
- สถิติเวลาการผลิตตามช่วงวันที่
- เปรียบเทียบเวลาต่ำสุด/สูงสุด/เฉลี่ย
- กรองตาม Job Code
- แสดงสถิติรายละเอียดตามงาน

### 3. หน้าสรุปรายวัน (Daily Summary)
- สรุปงานประจำวันพร้อมเวลาจริง
- เปรียบเทียบกับแผนการผลิต
- แสดงสถานะงาน (เสร็จแล้ว/กำลังทำ/รอเริ่ม)
- คำนวณความแตกต่างของเวลา

## API Endpoints

### 1. `/api/logs/production-times`
**GET** - ดึงข้อมูลเวลาการผลิต
- `workPlanId` - ค้นหาตาม Work Plan ID
- `productionDate` - ค้นหาตามวันที่ผลิต
- `jobCode` - ค้นหาตาม Job Code

### 2. `/api/logs/production-times/stats`
**GET** - ดึงสถิติเวลาการผลิต
- `startDate` - วันที่เริ่มต้น
- `endDate` - วันที่สิ้นสุด
- `jobCode` - กรองตาม Job Code

### 3. `/api/logs/daily-summary`
**GET** - ดึงสรุปรายวัน
- `productionDate` - วันที่ผลิต

## โครงสร้างข้อมูล

### Production Time Object
```typescript
{
  workPlanId: number
  processNumber: number
  jobCode: string
  jobName: string
  productionDate: string
  startTime: string
  endTime: string
  durationMs: number
  durationMinutes: number
  durationHours: number
  durationFormatted: string
  matchingWorkPlanId: number // ID จาก logs database
}
```

### Daily Job Object
```typescript
{
  workPlanId: number
  jobCode: string
  jobName: string
  productionDate: string
  plannedStartTime: string
  plannedEndTime: string
  plannedDurationMinutes: number
  actualStartTime: string | null
  actualEndTime: string | null
  actualDurationMinutes: number
  timeVarianceMinutes: number
  status: 'completed' | 'in-progress' | 'not-started'
  completedProcesses: number
  totalProcesses: number
  logs: any[]
  matchingWorkPlanId: number | null // ID จาก logs database
}
```

## การคำนวณเวลา

### 1. เวลาการผลิต
- คำนวณจาก logs ที่มี status = 'start' และ 'stop'
- จัดกลุ่มตาม work_plan_id และ process_number
- คำนวณระยะเวลาระหว่าง start และ stop

### 2. สถานะงาน
- **completed**: งานเสร็จสมบูรณ์ (มี start และ stop logs)
- **in-progress**: งานกำลังดำเนินการ (มี start แต่ไม่มี stop)
- **not-started**: งานยังไม่เริ่มต้น (ไม่มี logs)

### 3. ความแตกต่างของเวลา
- คำนวณจาก actualDuration - plannedDuration
- แสดงเป็นนาที (บวก = ล่าช้า, ลบ = เร็วกว่าแผน)

## การตั้งค่า Database

### Database Configuration

#### Database หลัก (192.168.0.94)
```javascript
{
  host: '192.168.0.94',
  user: 'jitdhana',
  password: 'iT12345$',
  database: 'esp_tracker'
}
```

#### Database Logs (192.168.0.93)
```javascript
{
  host: '192.168.0.93',
  user: 'it.jitdhana',
  password: 'iT12345$',
  database: 'esp_tracker'
}
```

### Tables ที่ใช้
- **Database หลัก**: `work_plans` - ข้อมูลแผนการผลิต
- **Database Logs**: `work_plans`, `logs` - ข้อมูล logs การผลิต

## การใช้งาน

### 1. เข้าถึงหน้าวิชาการผลิต
```
http://localhost:3000/production-times
```

### 2. เข้าถึงหน้าสถิติ
```
http://localhost:3000/production-times/stats
```

### 3. ดูสรุปรายวัน
```
http://localhost:3000/daily-summary
```

## การพัฒนาต่อ

### ฟีเจอร์ที่อาจเพิ่มเติม
1. การส่งออกรายงานเป็น Excel/PDF
2. การแจ้งเตือนเมื่องานล่าช้า
3. การวิเคราะห์แนวโน้มเวลาการผลิต
4. การเปรียบเทียบประสิทธิภาพระหว่างเครื่องจักร
5. การติดตามเวลาพักงาน

### การปรับปรุงประสิทธิภาพ
1. การ cache ข้อมูลสถิติ
2. การ optimize SQL queries
3. การ pagination สำหรับข้อมูลจำนวนมาก
4. การ real-time updates

## การแก้ไขปัญหา

### ปัญหาที่พบบ่อย
1. **ไม่สามารถเชื่อมต่อ database ได้**
   - ตรวจสอบการตั้งค่า host, user, password
   - ตรวจสอบ network connectivity

2. **ไม่พบข้อมูล**
   - ตรวจสอบวันที่ที่เลือก
   - ตรวจสอบว่ามี logs ใน database หรือไม่
   - ตรวจสอบว่า job_code ตรงกันในทั้งสอง database

3. **การคำนวณเวลาผิด**
   - ตรวจสอบ format ของ timestamp ใน logs
   - ตรวจสอบการจับคู่ start/stop logs

4. **ไม่พบ work_plan ที่ตรงกัน**
   - ตรวจสอบว่า job_code และ production_date ตรงกันในทั้งสอง database
   - ตรวจสอบการ sync ข้อมูลระหว่าง database

## การทดสอบ

### ทดสอบ API
```bash
# ทดสอบดึงข้อมูลเวลาการผลิต
curl "http://localhost:3000/api/logs/production-times?productionDate=2025-01-15"

# ทดสอบดึงสถิติ
curl "http://localhost:3000/api/logs/production-times/stats?startDate=2025-01-01&endDate=2025-01-31"

# ทดสอบดึงสรุปรายวัน
curl "http://localhost:3000/api/logs/daily-summary?productionDate=2025-01-15"
```

### ทดสอบ UI
1. เปิดหน้า `/production-times`
2. เลือกวันที่ที่มีข้อมูล
3. ตรวจสอบการแสดงผลข้อมูล
4. ทดสอบการค้นหาและกรองข้อมูล

## การ Debug

### Console Logs
ระบบจะแสดง console logs เพื่อช่วยในการ debug:
- จำนวน work plans ที่พบจาก database หลัก
- การประมวลผลแต่ละ work plan
- จำนวน matching work plans ที่พบใน logs database
- จำนวน logs ที่พบสำหรับแต่ละ work plan
- สถานะและเวลาของแต่ละงาน

### ตัวอย่าง Logs
```
Found 17 work plans for date 2025-01-15
Processing work plan: 235052 - น้ำพริกแคปคลุก 200 กรัม (กระปุก)
Found 1 matching work plans in logs database
Found 8 logs for work plan ID 123
Job 235052: completed, 4/4 processes completed, 180 minutes actual
```
