# ระบบจัดการงานใหม่ (New Jobs Management System)

## 🎯 ภาพรวม
ระบบจัดการงานใหม่ถูกออกแบบมาเพื่อจัดการงานที่มี `job_code = "NEW"` โดยเฉพาะ ซึ่งเป็นงานที่เพิ่งเพิ่มเข้ามาในระบบและยังไม่ได้กำหนดรหัสงานจริงและ Process Steps

## 🚀 การเริ่มต้นใช้งาน

### วิธีที่ 1: ใช้ไฟล์ Batch (แนะนำ)
```bash
update-new-jobs-system.bat
```

### วิธีที่ 2: อัปเดตด้วยตนเอง
```bash
# 1. หยุด Frontend server
# 2. ล้าง cache
cd frontend
rmdir /s /q .next
npm run dev
```

## 📁 โครงสร้างไฟล์

### Backend Files
- `backend/controllers/newJobsController.js` - Controller สำหรับจัดการงานใหม่
- `backend/routes/newJobsRoutes.js` - API Routes สำหรับงานใหม่
- `backend/routes/index.js` - เพิ่ม routes ใหม่

### Frontend Files
- `frontend/app/manage-new-jobs/page.tsx` - หน้าเว็บจัดการงานใหม่
- `frontend/app/api/new-jobs/route.ts` - API proxy สำหรับงานใหม่
- `frontend/app/api/new-jobs/[id]/route.ts` - API proxy สำหรับ DELETE
- `frontend/app/api/new-jobs/process-steps/route.ts` - API proxy สำหรับ Process Steps
- `frontend/app/dashboard/page.tsx` - เพิ่มลิงก์ในหน้า Dashboard

## 🔧 API Endpoints

### Backend API
- `GET /api/new-jobs` - ดึงรายการงานที่มี job_code = "NEW"
- `GET /api/new-jobs/process-steps` - ดึง Process Steps สำหรับงานที่ระบุ
- `PUT /api/new-jobs/:work_plan_id` - อัปเดตข้อมูลงานและ Process Steps
- `DELETE /api/new-jobs/:work_plan_id` - ลบงานที่มี job_code = "NEW"

### Frontend API (Proxy)
- `GET /api/new-jobs` - Proxy ไปยัง Backend
- `PUT /api/new-jobs` - Proxy ไปยัง Backend
- `DELETE /api/new-jobs/[id]` - Proxy ไปยัง Backend
- `GET /api/new-jobs/process-steps` - Proxy ไปยัง Backend

## 🎨 ฟีเจอร์หลัก

### 1. แสดงรายการงานใหม่
- แสดงเฉพาะงานที่มี `job_code = "NEW"`
- เรียงลำดับตามวันที่ผลิต (ใหม่สุดก่อน)
- แสดง ID, รหัสงาน, ชื่องาน, วันที่ผลิต

### 2. แก้ไขข้อมูลงาน
- เปลี่ยนรหัสงานจาก "NEW" เป็นรหัสจริง
- แก้ไขชื่องาน
- จัดการ Process Steps

### 3. จัดการ Process Steps
- เพิ่ม Process Steps ใหม่
- แก้ไข Process Steps ที่มีอยู่
- ลบ Process Steps ที่ไม่ต้องการ
- กำหนดจำนวนคนงานสำหรับแต่ละขั้นตอน

### 4. ลบงาน
- ลบงานที่ไม่ต้องการ
- ลบ Process Steps ที่เกี่ยวข้องด้วย

## 🔄 การทำงานของระบบ

### 1. การดึงข้อมูล
```typescript
// ดึงรายการงานใหม่
const response = await fetch('/api/new-jobs');
const data = await response.json();
```

### 2. การอัปเดตข้อมูล
```typescript
// อัปเดตงานและ Process Steps
const response = await fetch(`/api/new-jobs?work_plan_id=${workPlanId}`, {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    work_plan_id: workPlanId,
    new_job_code: 'JOB001',
    new_job_name: 'งานใหม่',
    process_steps: [
      {
        process_number: 1,
        process_description: 'ขั้นตอนที่ 1',
        worker_count: 2
      }
    ]
  })
});
```

### 3. การลบข้อมูล
```typescript
// ลบงาน
const response = await fetch(`/api/new-jobs/${workPlanId}`, {
  method: 'DELETE'
});
```

## 🗄️ โครงสร้างฐานข้อมูล

### ตารางที่เกี่ยวข้อง
- `work_plans` - ข้อมูลงาน
- `process_steps` - ขั้นตอนการทำงาน

### การอัปเดตฐานข้อมูล
1. อัปเดต `work_plans` (job_code, job_name)
2. ลบ Process Steps เดิม (ถ้ามี)
3. เพิ่ม Process Steps ใหม่ (ถ้ามี)
4. ใช้ Transaction เพื่อความปลอดภัย

## 🎯 การใช้งาน

### 1. เข้าสู่ระบบ
- เปิดหน้า Dashboard: http://localhost:3011/dashboard
- คลิกที่ "จัดการงานใหม่"

### 2. ดูรายการงานใหม่
- ระบบจะแสดงรายการงานที่มี `job_code = "NEW"`
- หากไม่มีงานใหม่ จะแสดงข้อความ "ไม่พบงานที่มี job_code = NEW"

### 3. แก้ไขงาน
- คลิกปุ่ม "แก้ไข" ที่งานที่ต้องการ
- กรอกรหัสงานใหม่ (เช่น: JOB001)
- กรอกชื่องานใหม่
- เพิ่ม/แก้ไข Process Steps

### 4. จัดการ Process Steps
- คลิก "เพิ่มขั้นตอน" เพื่อเพิ่ม Process Step ใหม่
- กรอกจำนวนคนงาน (ไม่บังคับ)
- กรอกคำอธิบายขั้นตอน
- คลิกไอคอนถังขยะเพื่อลบขั้นตอน

### 5. บันทึกการเปลี่ยนแปลง
- คลิก "บันทึกการเปลี่ยนแปลง"
- ระบบจะอัปเดตฐานข้อมูล
- แสดงข้อความสำเร็จ

### 6. ลบงาน
- คลิกปุ่ม "ลบ" ที่งานที่ต้องการ
- ยืนยันการลบ
- ระบบจะลบงานและ Process Steps ที่เกี่ยวข้อง

## 🔍 การตรวจสอบ

### 1. ตรวจสอบใน Browser
- เปิดหน้า: http://localhost:3011/manage-new-jobs
- ตรวจสอบว่าหน้าแสดงผลถูกต้อง
- ตรวจสอบว่ามีปุ่ม "แก้ไข" และ "ลบ"

### 2. ตรวจสอบ API
- เปิด Developer Tools > Network
- ตรวจสอบ API calls ไปยัง `/api/new-jobs`
- ตรวจสอบ response status และ data

### 3. ตรวจสอบฐานข้อมูล
```sql
-- ตรวจสอบงานที่มี job_code = "NEW"
SELECT * FROM work_plans WHERE job_code = 'NEW';

-- ตรวจสอบ Process Steps
SELECT * FROM process_steps WHERE job_code = 'NEW';
```

## 🚨 การแก้ไขปัญหา

### หน้าเว็บไม่แสดงผล
```bash
# ตรวจสอบ Frontend server
# ตรวจสอบ console ใน browser
# ตรวจสอบ network tab
```

### API ไม่ทำงาน
```bash
# ตรวจสอบ Backend server
# ตรวจสอบ database connection
# ตรวจสอบ API routes
```

### ข้อมูลไม่ถูกบันทึก
```bash
# ตรวจสอบ database transaction
# ตรวจสอบ foreign key constraints
# ตรวจสอบ API response
```

## 📱 การทดสอบ

### ข้อความภาษาไทย
- ✅ จัดการงานใหม่
- ✅ รายการงานใหม่ (job_code = "NEW")
- ✅ แก้ไขงานใหม่
- ✅ เพิ่มขั้นตอน
- ✅ บันทึกการเปลี่ยนแปลง

### UI Components
- ✅ ตารางแสดงรายการงาน
- ✅ Dialog แก้ไขข้อมูล
- ✅ Form สำหรับ Process Steps
- ✅ ปุ่มเพิ่ม/ลบ Process Steps

### การทำงาน
- ✅ การดึงข้อมูลงานใหม่
- ✅ การแก้ไขข้อมูลงาน
- ✅ การจัดการ Process Steps
- ✅ การลบงาน

## 🎉 ผลลัพธ์

หลังจากอัปเดตแล้ว คุณจะได้:
- ✅ หน้าเว็บสำหรับจัดการงานใหม่
- ✅ ระบบจัดการ Process Steps ที่ยืดหยุ่น
- ✅ API ที่ครบครันสำหรับจัดการข้อมูล
- ✅ UI ที่ใช้งานง่ายและสวยงาม
- ✅ การจัดการฐานข้อมูลที่ปลอดภัย

---

**หมายเหตุ**: ระบบจะจัดการเฉพาะงานที่มี `job_code = "NEW"` เท่านั้น เพื่อความปลอดภัยของข้อมูล 