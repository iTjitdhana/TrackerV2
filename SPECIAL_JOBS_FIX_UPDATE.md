# Special Jobs Fix Update Report

## 🎯 **ปัญหาที่พบ**

### **อาการของปัญหา**
- งานพิเศษยังปนกับงานปกติใน Google Sheet
- การแยกงานพิเศษไม่ทำงานตามที่คาดหวัง
- Logic การเรียงลำดับไม่สอดคล้องกัน

### **สาเหตุของปัญหา**
1. **Logic ไม่สอดคล้องกัน**
   - `getSortedDailyProduction` ใช้ `is_special === 1`
   - `handleSyncDrafts` ใช้ `workflow_status_id === 10`
   - ทำให้การแยกงานพิเศษไม่ตรงกัน

2. **Type Issues**
   - `is_special` ใน interface เป็น `boolean` แต่ในฐานข้อมูลเป็น `number`
   - การเปรียบเทียบไม่ถูกต้อง

## 🔧 **การแก้ไขที่ทำ**

### **1. แก้ไข Logic การแยกงานพิเศษ**
**ไฟล์:** `frontend/Production_Planing.tsx` (บรรทัด 1250-1270)

**เปลี่ยนจาก:**
```typescript
// แยกงานปกติและงานพิเศษ (status_id = 10)
const normalJobs = productionData.filter(item => 
  item.production_date === selectedDate && 
  !(item.isDraft && defaultCodes.includes(item.job_code)) &&
  item.workflow_status_id !== 10 // ไม่ใช่งานพิเศษ
);

const specialJobs = productionData.filter(item => 
  item.production_date === selectedDate && 
  !(item.isDraft && defaultCodes.includes(item.job_code)) &&
  item.workflow_status_id === 10 // งานพิเศษ
);
```

**เป็น:**
```typescript
// แยกงานปกติและงานพิเศษ (ใช้ is_special = 1 หรือ workflow_status_id = 10)
const normalJobs = productionData.filter(item => 
  item.production_date === selectedDate && 
  !(item.isDraft && defaultCodes.includes(item.job_code)) &&
  item.is_special !== 1 && 
  item.workflow_status_id !== 10 // ไม่ใช่งานพิเศษ
);

const specialJobs = productionData.filter(item => 
  item.production_date === selectedDate && 
  !(item.isDraft && defaultCodes.includes(item.job_code)) &&
  (item.is_special === 1 || item.workflow_status_id === 10) // งานพิเศษ
);
```

### **2. แก้ไข Interface Type**
**ไฟล์:** `frontend/types/production.ts`

```typescript
export interface ProductionItem {
  // ... existing properties
  is_special?: boolean | number; // รองรับ special jobs (boolean หรือ number)
  workflow_status_id?: number; // รองรับ workflow status ID
}
```

### **3. เพิ่ม Debug Logging**
```typescript
// Debug: แสดงข้อมูลการแยกงาน
console.log("🔍 [DEBUG] แยกงานพิเศษ:");
console.log("🔍 [DEBUG] งานปกติ:", normalJobs.length, "รายการ");
console.log("🔍 [DEBUG] งานพิเศษ:", specialJobs.length, "รายการ");
console.log("🔍 [DEBUG] งานปกติ:", normalJobs.map(item => ({ 
  job_name: item.job_name, 
  is_special: item.is_special, 
  workflow_status_id: item.workflow_status_id 
})));
console.log("🔍 [DEBUG] งานพิเศษ:", specialJobs.map(item => ({ 
  job_name: item.job_name, 
  is_special: item.is_special, 
  workflow_status_id: item.workflow_status_id 
})));
```

## 📊 **ผลลัพธ์ที่คาดหวัง**

### **การแยกงานพิเศษ:**
- **งานปกติ**: `is_special !== 1` และ `workflow_status_id !== 10`
- **งานพิเศษ**: `is_special === 1` หรือ `workflow_status_id === 10`

### **ลำดับการแสดงผล:**
1. **งานปกติ** - เรียงตามเวลาและผู้ปฏิบัติงาน
2. **งานพิเศษ** - เรียงตามเวลา (อยู่ด้านล่างสุด)

## 🧪 **วิธีทดสอบ**

### **1. ตรวจสอบ Console Logs**
เมื่อกดปุ่ม Sync ควรเห็น:
```
🔍 [DEBUG] แยกงานพิเศษ:
🔍 [DEBUG] งานปกติ: X รายการ
🔍 [DEBUG] งานพิเศษ: Y รายการ
🔍 [DEBUG] งานปกติ: [{job_name: "...", is_special: 0, workflow_status_id: 3}, ...]
🔍 [DEBUG] งานพิเศษ: [{job_name: "...", is_special: 1, workflow_status_id: 10}, ...]
```

### **2. ตรวจสอบ Google Sheet**
- งานปกติควรอยู่ด้านบน
- งานพิเศษควรอยู่ด้านล่างสุด
- ไม่ควรมีงานพิเศษปนกับงานปกติ

### **3. ตรวจสอบฐานข้อมูล**
```sql
-- ตรวจสอบงานพิเศษ
SELECT * FROM work_plans 
WHERE is_special = 1 OR workflow_status_id = 10 
AND production_date = '2025-08-11';

-- ตรวจสอบงานปกติ
SELECT * FROM work_plans 
WHERE (is_special != 1 OR is_special IS NULL) 
AND (workflow_status_id != 10 OR workflow_status_id IS NULL)
AND production_date = '2025-08-11';
```

## ⚠️ **ปัญหาที่เหลืออยู่**

### **1. Type Errors**
- ยังมี `operators.split()` ในหลายจุด
- ต้องใช้ `getOperatorsArray()` helper function แทน

### **2. Missing Properties**
- `production_room` property ไม่มีใน interface
- ต้องเพิ่มหรือใช้ property ที่ถูกต้อง

## 🚀 **ขั้นตอนต่อไป**

### **1. ทดสอบการแยกงานพิเศษ**
1. สร้างงานปกติและงานพิเศษ
2. กดปุ่ม Sync
3. ตรวจสอบ console logs
4. ตรวจสอบลำดับใน Google Sheet

### **2. แก้ไข Type Errors**
- แก้ไขการใช้ operators
- เพิ่ม missing properties ใน interface

### **3. ตรวจสอบ Data Consistency**
- ตรวจสอบว่า data ในฐานข้อมูลถูกต้อง
- ตรวจสอบว่า API ส่งข้อมูลถูกต้อง

## 📝 **สรุป**

**การแก้ไขนี้จะทำให้:**
1. **Logic การแยกงานพิเศษสอดคล้องกัน** ระหว่าง UI และ Google Sheet
2. **งานพิเศษอยู่ด้านล่างสุด** ตามที่ต้องการ
3. **มี debug logging** เพื่อตรวจสอบการทำงาน

**วิธีทดสอบ:**
1. กดปุ่ม Sync
2. ตรวจสอบ console logs
3. ตรวจสอบลำดับใน Google Sheet

**หากยังมีปัญหา:**
1. ตรวจสอบ console logs เพื่อดูการแยกงาน
2. ตรวจสอบข้อมูลในฐานข้อมูล
3. แก้ไข type errors ที่เหลือ
