# Special Jobs Sorting Fix Report

## 🎯 **ปัญหาที่พบ**

### **อาการของปัญหา**
- งานพิเศษ (status_id = 10) ปนกับงานปกติ
- งานพิเศษไม่ได้อยู่ด้านล่างสุดตามที่ต้องการ
- การเรียงลำดับไม่แยกงานพิเศษออกมา

### **สาเหตุของปัญหา**
- Logic การเรียงลำดับใน `handleSyncDrafts` ไม่ได้แยกงานพิเศษออกมา
- ใช้การเรียงลำดับแบบเดียวกับงานปกติ
- ไม่มีการตรวจสอบ `workflow_status_id = 10`

## 🔧 **การแก้ไขที่ทำ**

### **1. แก้ไข Logic การเรียงลำดับ**
**ไฟล์:** `frontend/Production_Planing.tsx` (บรรทัด 1250-1285)

**เปลี่ยนจาก:**
```typescript
// เรียงงานตาม logic หน้าเว็บ
const filtered = productionData
  .filter(item => item.production_date === selectedDate && !(item.isDraft && defaultCodes.includes(item.job_code)))
  .sort((a, b) => {
    // เรียงตามเวลาและผู้ปฏิบัติงาน
  });
```

**เป็น:**
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

// เรียงงานปกติตาม logic หน้าเว็บ
const sortedNormalJobs = normalJobs.sort((a, b) => {
  // เรียงตามเวลาและผู้ปฏิบัติงาน
});

// เรียงงานพิเศษตามเวลา
const sortedSpecialJobs = specialJobs.sort((a, b) => {
  const timeA = a.start_time || "00:00";
  const timeB = b.start_time || "00:00";
  return timeA.localeCompare(timeB);
});

// รวมงานปกติ + งานพิเศษ (งานพิเศษอยู่ด้านล่างสุด)
const filtered = [...sortedNormalJobs, ...sortedSpecialJobs];
```

### **2. เพิ่ม workflow_status_id ใน Interface**
**ไฟล์:** `frontend/types/production.ts`

```typescript
export interface ProductionItem {
  // ... existing properties
  workflow_status_id?: number; // รองรับ workflow status ID
}
```

### **3. Import Helper Functions**
**ไฟล์:** `frontend/Production_Planing.tsx`

```typescript
import { getOperatorsArray, getOperatorsString } from "@/lib/utils";
```

## 📊 **ผลลัพธ์ที่คาดหวัง**

### **ลำดับการแสดงผลใน Google Sheet:**
1. **งานปกติ** - เรียงตามเวลาและผู้ปฏิบัติงาน
2. **งานพิเศษ** - เรียงตามเวลา (อยู่ด้านล่างสุด)

### **ตัวอย่างลำดับ:**
```
งานที่ 1: งานปกติ - อาร์ม (08:00-10:00)
งานที่ 2: งานปกติ - จรัญ (09:00-11:00)
งานที่ 3: งานปกติ - พี่ตุ่น (10:00-12:00)
...
งานที่ N: งานพิเศษ - แมน (09:30-11:00) ← อยู่ด้านล่างสุด
```

## ⚠️ **ปัญหาที่เหลืออยู่ (Type Errors)**

### **1. Operators Type Issues**
- ยังมี `operators.split()` ในหลายจุด
- ต้องใช้ `getOperatorsArray()` helper function แทน

### **2. Boolean Comparison Issues**
- ยังมีการเปรียบเทียบ boolean กับ number
- ต้องแก้ไข logic การเปรียบเทียบ

### **3. Missing Properties**
- `production_room` property ไม่มีใน interface
- ต้องเพิ่มหรือใช้ property ที่ถูกต้อง

## 🚀 **ขั้นตอนต่อไป**

### **1. แก้ไข Type Errors**
```typescript
// แก้ไขการใช้ operators
const operatorA = getOperatorsArray(a.operators)[0] || "";
const operatorB = getOperatorsArray(b.operators)[0] || "";

// แก้ไขการเปรียบเทียบ boolean
if (item.workflow_status_id === 10) // แทน item.is_special === true
```

### **2. ทดสอบการเรียงลำดับ**
1. สร้างงานปกติและงานพิเศษ
2. กดปุ่ม Sync
3. ตรวจสอบลำดับใน Google Sheet
4. ตรวจสอบ console logs

### **3. ตรวจสอบ Data Structure**
- ตรวจสอบว่า `workflow_status_id` มีค่าถูกต้อง
- ตรวจสอบว่า data มาจาก API ถูกต้อง

## 📝 **สรุป**

**การแก้ไขนี้จะทำให้:**
1. **งานพิเศษอยู่ด้านล่างสุด** ตามที่ต้องการ
2. **งานปกติเรียงตาม logic เดิม** (เวลา + ผู้ปฏิบัติงาน)
3. **งานพิเศษเรียงตามเวลา** เท่านั้น

**วิธีทดสอบ:**
1. สร้างงานปกติและงานพิเศษ
2. กดปุ่ม Sync
3. ตรวจสอบลำดับใน Google Sheet

**หากยังมีปัญหา:**
1. ตรวจสอบ `workflow_status_id` ในฐานข้อมูล
2. ตรวจสอบ console logs
3. แก้ไข type errors ที่เหลือ
