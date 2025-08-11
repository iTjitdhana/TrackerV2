# Cache Clear Guide - แก้ไขปัญหา Code ไม่ Update

## 🎯 **ปัญหาที่พบ**
- Code ที่แก้ไขแล้วไม่ทำงาน
- งานพิเศษยังปนกับงานปกติ
- Browser ใช้ cache เก่า

## 🔧 **วิธีแก้ไข**

### **1. Restart Development Server**
```bash
# หยุด server (Ctrl+C)
# แล้วรันใหม่
cd frontend
npm run dev
```

### **2. Hard Refresh Browser**
- **Windows**: กด **Ctrl+Shift+R**
- **Mac**: กด **Cmd+Shift+R**
- หรือเปิด Developer Tools -> Network tab -> กดปุ่ม "Disable cache" แล้ว refresh

### **3. Clear Browser Cache**
1. เปิด Developer Tools (F12)
2. ไปที่ Application tab
3. เลือก Storage -> Clear storage
4. กดปุ่ม "Clear site data"

### **4. Disable Cache ใน Developer Tools**
1. เปิด Developer Tools (F12)
2. ไปที่ Network tab
3. กดปุ่ม "Disable cache" (รูปไอคอนถังขยะ)
4. Refresh หน้าเว็บ

### **5. ตรวจสอบ Code ที่แก้ไขแล้ว**
Code ที่แก้ไขแล้วควรมี:

```typescript
// งานปกติ (is_special !== 1 และ workflow_status_id !== 10)
const normalJobs = dayData.filter(item => 
  !defaultCodes.includes(item.job_code) && 
  item.is_special !== 1 && 
  item.workflow_status_id !== 10 && 
  !item.isDraft
);

// งานพิเศษ (is_special === 1 หรือ workflow_status_id === 10)
const specialJobs = dayData.filter(item => 
  !defaultCodes.includes(item.job_code) && 
  (item.is_special === 1 || item.workflow_status_id === 10) && 
  !item.isDraft
);

// Debug logs
console.log("🔍 [DEBUG] getSelectedDayProduction แยกงาน:");
console.log("🔍 [DEBUG] งานปกติ:", normalJobs.length, "รายการ");
console.log("🔍 [DEBUG] งานพิเศษ:", specialJobs.length, "รายการ");

// ลำดับการส่งคืน
return [...defaultDrafts, ...normalJobs, ...specialJobs, ...draftJobs];
```

## 🧪 **วิธีทดสอบ**

### **1. ตรวจสอบ Console Logs**
หลังจาก clear cache แล้ว ควรเห็น logs เหล่านี้:
```
🔍 [DEBUG] getSelectedDayProduction แยกงาน:
🔍 [DEBUG] งานปกติ: X รายการ
🔍 [DEBUG] งานพิเศษ: Y รายการ
🔍 [DEBUG] งานปกติ: [{job_name: "...", is_special: 0, workflow_status_id: 3}, ...]
🔍 [DEBUG] งานพิเศษ: [{job_name: "น้ำส้มตำไทย", is_special: 1, workflow_status_id: 10}, ...]
```

### **2. ตรวจสอบหน้าเว็บ**
1. เลือกวันที่ **11 ส.ค. 2568**
2. ตรวจสอบลำดับงาน:
   - งานปกติควรอยู่ด้านบน
   - งานพิเศษควรอยู่ด้านล่างสุด
   - "น้ำส้มตำไทย" ควรอยู่ท้ายสุด

### **3. ตรวจสอบ Network Tab**
1. เปิด Developer Tools -> Network tab
2. Refresh หน้าเว็บ
3. ตรวจสอบว่าไฟล์ JavaScript ถูกโหลดใหม่ (ไม่ใช่จาก cache)

## ⚠️ **ปัญหาที่อาจเกิดขึ้น**

### **1. ยังไม่เห็น Debug Logs**
- ตรวจสอบว่า server restart แล้ว
- ตรวจสอบว่า browser cache ถูก clear แล้ว
- ตรวจสอบว่า code ถูก save แล้ว

### **2. งานพิเศษยังปนอยู่**
- ตรวจสอบว่า function ถูกเรียกใช้
- ตรวจสอบว่า data ถูก filter ถูกต้อง
- ตรวจสอบว่า UI แสดงผลถูกต้อง

### **3. TypeScript Errors**
- ตรวจสอบว่า TypeScript compilation สำเร็จ
- ตรวจสอบว่า helper functions ทำงานถูกต้อง
- ตรวจสอบว่า interface ถูกต้อง

## 📝 **ขั้นตอนการแก้ไข**

### **ขั้นตอนที่ 1: Restart Server**
```bash
cd frontend
npm run dev
```

### **ขั้นตอนที่ 2: Clear Browser Cache**
1. กด **Ctrl+Shift+R** (Windows) หรือ **Cmd+Shift+R** (Mac)
2. หรือเปิด Developer Tools -> Network tab -> กดปุ่ม "Disable cache"

### **ขั้นตอนที่ 3: ตรวจสอบ Console Logs**
1. เปิด Developer Console (F12)
2. ล้าง console logs เก่า
3. Refresh หน้าเว็บ
4. ตรวจสอบ debug logs

### **ขั้นตอนที่ 4: ทดสอบการทำงาน**
1. เลือกวันที่ **11 ส.ค. 2568**
2. ตรวจสอบลำดับงานในหน้าเว็บ
3. ตรวจสอบ console logs

## 🔍 **การ Debug เพิ่มเติม**

### **1. ตรวจสอบ Code Version**
```javascript
// ใน console พิมพ์:
console.log("Code version:", Date.now());
```

### **2. ตรวจสอบ Data**
```javascript
// ใน console พิมพ์:
console.log("productionData:", productionData);
console.log("selectedDate:", selectedDate);
```

### **3. ตรวจสอบ Function Call**
```javascript
// ใน console พิมพ์:
console.log("getSelectedDayProduction function exists:", typeof getSelectedDayProduction);
```

## 📝 **สรุป**

**หากยังมีปัญหา:**
1. **Restart server** และ **clear browser cache**
2. ตรวจสอบ **console logs** เพื่อดูการทำงาน
3. ตรวจสอบ **code version** เพื่อให้แน่ใจว่าใช้ code ใหม่
4. ตรวจสอบ **data structure** เพื่อให้แน่ใจว่า filter ถูกต้อง

**Code ที่แก้ไขแล้วจะทำให้:**
- งานพิเศษอยู่ล่างสุดเสมอ
- มี debug logging เพื่อตรวจสอบการทำงาน
- ลำดับการแสดงผลถูกต้องตามที่ต้องการ
