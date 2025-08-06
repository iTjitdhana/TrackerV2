# การแก้ไขปัญหา LIMIT ที่ยังเป็น 50

## ปัญหาที่พบ
- Frontend ส่ง `limit=10000` แต่ backend ยังใช้ `LIMIT 50`
- ระบบแสดงงานได้เพียง 50 งาน แทนที่จะเป็น 134 งาน

## สาเหตุของปัญหา

### 1. การคำนวณ safeLimit
โค้ดเดิม:
```javascript
const safeLimit = Number.isInteger(parseInt(limit)) ? parseInt(limit) : 10000;
```

ปัญหาคือ:
- `parseInt(limit)` อาจได้ `NaN` หาก limit ไม่ใช่ตัวเลข
- `Number.isInteger(NaN)` จะได้ `false`
- ทำให้ `safeLimit` ใช้ค่า default 10000 แต่บางครั้งอาจใช้ค่า 50

### 2. การส่งค่า limit จาก frontend
Frontend ส่ง:
```typescript
const response = await fetch(`/api/reports/production-analysis?start_date=${startDateStr}&end_date=${endDateStr}&limit=10000`);
```

แต่ backend ได้รับ `limit=50` ซึ่งอาจเกิดจาก:
- การแปลงค่าผิดพลาดใน API route
- การ override ค่าใน middleware
- การ cache หรือการส่งค่าผิดพลาด

## การแก้ไขที่ทำ

### 1. บังคับใช้ limit = 10000 เสมอ
แก้ไขในไฟล์ `backend/routes/reportRoutes.js`:

```javascript
// ก่อนแก้ไข
const safeLimit = Number.isInteger(parseInt(limit)) ? parseInt(limit) : 10000;

// หลังแก้ไข
const safeLimit = 10000;
```

### 2. เพิ่มการ Log เพื่อตรวจสอบ
เพิ่มการ log เพื่อตรวจสอบค่า limit:

```javascript
console.log('🔍 Raw limit value:', limit);
console.log('🔍 Limit type:', typeof limit);
console.log('🔍 Parsed limit:', parseInt(limit));
console.log('🔍 Safe limit calculated:', safeLimit);
console.log('🔍 Original limit from request:', limit);
```

### 3. เพิ่มการ Log ใน Frontend API
เพิ่มการ log ในไฟล์ `frontend/app/api/reports/production-analysis/route.ts`:

```typescript
console.log('[DEBUG] Query parameters:', Object.fromEntries(params.entries()));
console.log('[DEBUG] Limit parameter:', params.get('limit'));
```

## ผลลัพธ์ที่คาดหวัง

หลังจากแก้ไขแล้ว:
- ระบบจะใช้ `LIMIT 10000` เสมอ
- ควรแสดงงานทั้งหมด 134 งาน
- ไม่มีปัญหาเรื่อง limit อีกต่อไป

## การทดสอบ

### 1. ตรวจสอบ Logs
ดู logs ของ backend เพื่อตรวจสอบ:
```
🔍 Raw limit value: 10000
🔍 Safe limit calculated: 10000
📊 Results count: [จำนวนที่มากกว่า 50]
```

### 2. ตรวจสอบ Frontend Logs
ดู logs ของ frontend เพื่อตรวจสอบ:
```
[DEBUG] Limit parameter: 10000
```

### 3. ทดสอบหน้า Reports
- เปิดหน้า Reports
- สร้างรายงาน
- ตรวจสอบจำนวนงานที่แสดง (ควรเป็น 134 งาน)

## หมายเหตุ

- การบังคับใช้ limit = 10000 อาจทำให้ query ช้าลง
- หากมีข้อมูลมากกว่า 10,000 รายการ อาจต้องปรับ limit เพิ่มขึ้น
- การแก้ไขนี้เป็นการแก้ไขชั่วคราว เพื่อให้ได้ข้อมูลครบถ้วน 