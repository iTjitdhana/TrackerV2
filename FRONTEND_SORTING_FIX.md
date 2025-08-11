# Frontend Sorting Fix for Special Jobs

## 🎯 **ปัญหาที่พบ**
- งานพิเศษยังปนกับงานปกติในหน้าเว็บ
- ลำดับการแสดงผลไม่แยกงานพิเศษออกมา
- งานพิเศษไม่ได้อยู่ล่างสุดเสมอ

## 🔧 **การแก้ไขที่ทำ**

### **1. แก้ไข getSortedDailyProduction Function**
**ไฟล์:** `frontend/Production_Planing.tsx` (บรรทัด 2082-2140)

**เปลี่ยนลำดับการส่งคืน:**
```typescript
// เดิม: default -> งานปกติเสร็จแล้ว -> งานพิเศษเสร็จแล้ว -> งานปกติแบบร่าง -> งานพิเศษแบบร่าง
return [
  ...defaultDrafts,
  ...normalCompleted,
  ...specialCompleted,  // ← งานพิเศษอยู่ตรงกลาง
  ...normalDrafts,
  ...specialDrafts
];

// ใหม่: default -> งานปกติเสร็จแล้ว -> งานปกติแบบร่าง -> งานพิเศษเสร็จแล้ว -> งานพิเศษแบบร่าง
return [
  ...defaultDrafts,
  ...normalCompleted,
  ...normalDrafts,
  ...specialCompleted,  // ← งานพิเศษอยู่ล่างสุดเสมอ
  ...specialDrafts
];
```

### **2. แก้ไขการใช้ operators.split()**
**เปลี่ยนจาก:**
```typescript
const opA = (a.operators || "").split(", ")[0] || "";
const opB = (b.operators || "").split(", ")[0] || "";
```

**เป็น:**
```typescript
const opA = getOperatorsArray(a.operators)[0] || "";
const opB = getOperatorsArray(b.operators)[0] || "";
```

### **3. ลำดับการแสดงผลใหม่**
1. **งาน Default (A, B, C, D)** - อยู่บนสุด
2. **งานปกติที่เสร็จแล้ว** - เรียงตามเวลาและผู้ปฏิบัติงาน
3. **งานปกติแบบร่าง** - เรียงตามเวลาที่สร้าง
4. **งานพิเศษที่เสร็จแล้ว** - เรียงตามเวลา (อยู่ล่างสุด)
5. **งานพิเศษแบบร่าง** - เรียงตามเวลาที่สร้าง (อยู่ล่างสุด)

## 📊 **ผลลัพธ์ที่คาดหวัง**

### **ลำดับการแสดงผลในหน้าเว็บ:**
```
งานที่ 1: แป้งจุ้ยก๊วย (งานปกติ) - พี่ภา (08:00-15:00)
งานที่ 2: น้ำพริกแคปคลุก (งานปกติ) - อาร์ม (09:30-14:00)
งานที่ 3: น้ำจิ้ม Meating house (งานปกติ) - พี่ตุ่น (09:30-11:30)
งานที่ 4: กุ้งบิดน้ำ (งานปกติ) - แมน (09:30-14:00)
...
งานที่ N: น้ำส้มตำไทย (งานพิเศษ) - จรัญ (09:30-11:00) ← อยู่ล่างสุดเสมอ
```

### **การแยกงานพิเศษ:**
- **งานปกติ**: `is_special !== 1` และ `workflow_status_id !== 10`
- **งานพิเศษ**: `is_special === 1` หรือ `workflow_status_id === 10`

## 🧪 **วิธีทดสอบ**

### **1. ตรวจสอบหน้าเว็บ**
1. เปิดหน้าเว็บ
2. เลือกวันที่ **11 ส.ค. 2568**
3. ตรวจสอบลำดับงาน:
   - งานปกติควรอยู่ด้านบน
   - งานพิเศษควรอยู่ด้านล่างสุด
   - "น้ำส้มตำไทย" ควรอยู่ท้ายสุด

### **2. ตรวจสอบ Console Logs**
เมื่อกดปุ่ม Sync ควรเห็น:
```
🔍 [DEBUG] แยกงานพิเศษ:
🔍 [DEBUG] งานปกติ: X รายการ
🔍 [DEBUG] งานพิเศษ: Y รายการ
🔍 [DEBUG] ข้อมูลที่ส่งไป Google Sheet:
🔍 [DEBUG] ลำดับงาน: [...]
```

### **3. ตรวจสอบ Google Sheet**
- งานปกติควรอยู่ด้านบน
- งานพิเศษควรอยู่ด้านล่างสุด
- ไม่ควรมีงานพิเศษปนกับงานปกติ

## 🔍 **การ Debug เพิ่มเติม**

### **1. ตรวจสอบข้อมูลในฐานข้อมูล**
```sql
-- ตรวจสอบงานพิเศษ
SELECT id, job_name, is_special, workflow_status_id, production_date 
FROM work_plans 
WHERE production_date = '2025-08-11' 
AND (is_special = 1 OR workflow_status_id = 10);

-- ตรวจสอบงานปกติ
SELECT id, job_name, is_special, workflow_status_id, production_date 
FROM work_plans 
WHERE production_date = '2025-08-11' 
AND (is_special != 1 OR is_special IS NULL) 
AND (workflow_status_id != 10 OR workflow_status_id IS NULL);
```

### **2. ตรวจสอบ Frontend Data**
```javascript
// ใน console พิมพ์:
console.log("productionData:", productionData);
console.log("selectedDate:", selectedDate);
```

## ⚠️ **ปัญหาที่อาจเกิดขึ้น**

### **1. งานพิเศษยังปนอยู่**
- ตรวจสอบค่า `is_special` และ `workflow_status_id` ในฐานข้อมูล
- ตรวจสอบว่า logic การแยกงานถูกต้อง
- ตรวจสอบว่า function ถูกเรียกใช้

### **2. ลำดับไม่ถูกต้อง**
- ตรวจสอบว่า `getSortedDailyProduction` ถูกเรียกใช้
- ตรวจสอบว่า data ถูก sort ถูกต้อง
- ตรวจสอบว่า UI แสดงผลถูกต้อง

### **3. Type Errors**
- ตรวจสอบว่า TypeScript compilation สำเร็จ
- ตรวจสอบว่า helper functions ทำงานถูกต้อง
- ตรวจสอบว่า interface ถูกต้อง

## 📝 **สรุป**

**การแก้ไขนี้จะทำให้:**
1. **งานพิเศษอยู่ล่างสุดเสมอ** ในหน้าเว็บ
2. **ลำดับการแสดงผลถูกต้อง** ตามที่ต้องการ
3. **การแยกงานพิเศษชัดเจน** ระหว่างงานปกติและงานพิเศษ

**วิธีทดสอบ:**
1. เปิดหน้าเว็บ
2. ตรวจสอบลำดับงานในหน้าเว็บ
3. กดปุ่ม Sync และตรวจสอบ Google Sheet
4. ตรวจสอบ console logs

**หากยังมีปัญหา:**
1. ตรวจสอบข้อมูลในฐานข้อมูล
2. ตรวจสอบ console logs
3. ตรวจสอบ logic การแยกงาน
