# การอัปเดต Input วันที่และเวลา

## 🎯 ภาพรวม
ระบบได้ถูกอัปเดตให้แยกการแก้ไขวันที่และเวลาในหน้า Popup โดย:
- **วันที่**: ใช้ date picker
- **เวลา**: ใช้ text input แบบพิมพ์ได้ในรูปแบบ HH:mm:ss

## 🚀 การอัปเดต

### วิธีที่ 1: ใช้ไฟล์ Batch (แนะนำ)
```bash
update-datetime-input.bat
```

### วิธีที่ 2: อัปเดตด้วยตนเอง
```bash
# 1. หยุด Frontend server
# 2. ล้าง cache
cd frontend
rmdir /s /q .next
npm run dev
```

## 📝 การเปลี่ยนแปลงที่ทำ

### 1. **formData State**
```typescript
// เดิม
const [formData, setFormData] = useState({
  work_plan_id: '',
  process_number: '',
  status: 'start' as 'start' | 'stop',
  timestamp: new Date().toISOString().slice(0, 16)
});

// ใหม่
const [formData, setFormData] = useState({
  work_plan_id: '',
  process_number: '',
  status: 'start' as 'start' | 'stop',
  date: new Date().toISOString().slice(0, 10),
  time: new Date().toLocaleTimeString('en-GB', { hour12: false }).slice(0, 8)
});
```

### 2. **ฟังก์ชันใหม่**
```typescript
// ฟังก์ชันสำหรับรวมวันที่และเวลาเป็น timestamp
const combineDateTime = (date: string, time: string) => {
  return `${date}T${time}`;
};

// ฟังก์ชันสำหรับแยกวันที่และเวลาจาก timestamp
const splitDateTime = (timestamp: string) => {
  const date = new Date(timestamp);
  return {
    date: date.toISOString().slice(0, 10),
    time: date.toLocaleTimeString('en-GB', { hour12: false }).slice(0, 8)
  };
};
```

### 3. **UI Components**
```tsx
// เดิม
<div>
  <Label htmlFor="timestamp">เวลา</Label>
  <Input
    id="timestamp"
    type="datetime-local"
    value={formData.timestamp}
    onChange={(e) => setFormData({...formData, timestamp: e.target.value})}
  />
</div>

// ใหม่
<div className="grid grid-cols-2 gap-4">
  <div>
    <Label htmlFor="date">วันที่</Label>
    <Input
      id="date"
      type="date"
      value={formData.date}
      onChange={(e) => setFormData({...formData, date: e.target.value})}
    />
  </div>
  <div>
    <Label htmlFor="time">เวลา (HH:mm:ss)</Label>
    <Input
      id="time"
      type="text"
      value={formData.time}
      onChange={(e) => setFormData({...formData, time: e.target.value})}
      placeholder="16:01:32"
    />
  </div>
</div>
```

## 🎨 คุณสมบัติใหม่

### ✅ ข้อดี
- **แยกการแก้ไข**: วันที่และเวลาอยู่คนละช่อง
- **ความยืดหยุ่น**: เวลาสามารถพิมพ์ได้อิสระ
- **ความแม่นยำ**: สามารถระบุวินาทีได้
- **UI ที่ดีขึ้น**: ใช้ grid layout แสดงผลสวยงาม

### 📊 การใช้งาน
- **วันที่**: คลิกเลือกจาก date picker
- **เวลา**: พิมพ์ในรูปแบบ HH:mm:ss
- **ตัวอย่าง**: 16:01:32, 09:30:00, 23:59:59

## 🔧 การใช้งาน

### 1. เพิ่ม Log ใหม่
1. คลิกปุ่ม "เพิ่ม Log"
2. เลือกวันที่จาก date picker
3. พิมพ์เวลาในรูปแบบ HH:mm:ss
4. คลิก "เพิ่ม Log"

### 2. แก้ไข Log
1. คลิกปุ่ม "แก้ไข" (ไอคอนดินสอ)
2. แก้ไขวันที่และเวลาตามต้องการ
3. คลิก "บันทึกการเปลี่ยนแปลง"

### 3. รูปแบบเวลาที่รองรับ
- ✅ `16:01:32` - ชั่วโมง:นาที:วินาที
- ✅ `09:30:00` - เวลาเช้า
- ✅ `23:59:59` - เวลากลางคืน
- ✅ `00:00:00` - เที่ยงคืน

## 🎯 ตัวอย่างการใช้งาน

### การเพิ่ม Log ใหม่
```
วันที่: 2025-01-31
เวลา: 16:01:32
ผลลัพธ์: 2025-01-31T16:01:32
```

### การแก้ไข Log
```
วันที่เดิม: 2025-01-30
เวลาเดิม: 14:30:00
แก้ไขเป็น:
- วันที่: 2025-01-31
- เวลา: 16:01:32
ผลลัพธ์: 2025-01-31T16:01:32
```

## 🔍 การตรวจสอบ

### 1. ตรวจสอบใน Browser
- เปิดหน้า Logs: http://localhost:3011/logs
- คลิก "เพิ่ม Log" หรือ "แก้ไข Log"
- ตรวจสอบว่ามีช่องวันที่และเวลาคนละช่อง

### 2. ตรวจสอบการทำงาน
- ทดสอบการเลือกวันที่
- ทดสอบการพิมพ์เวลา
- ทดสอบการบันทึกข้อมูล

### 3. ตรวจสอบข้อมูล
- ดูในตาราง Logs ว่าข้อมูลถูกบันทึกถูกต้อง
- ตรวจสอบรูปแบบ timestamp ในฐานข้อมูล

## 🚨 การแก้ไขปัญหา

### เวลาไม่ถูกบันทึก
```bash
# ตรวจสอบรูปแบบเวลา
# ต้องเป็น HH:mm:ss
# ตัวอย่าง: 16:01:32
```

### วันที่ไม่ถูกบันทึก
```bash
# ตรวจสอบการเลือกวันที่
# ต้องเลือกจาก date picker
```

### Error เมื่อบันทึก
```bash
# ตรวจสอบ console ใน browser
# ตรวจสอบ network tab
# ตรวจสอบ backend logs
```

## 📱 การทดสอบ

### ข้อความภาษาไทย
- ✅ วันที่
- ✅ เวลา (HH:mm:ss)
- ✅ เพิ่ม Log ใหม่
- ✅ แก้ไข Log

### UI Components
- ✅ Date Picker
- ✅ Time Input
- ✅ Grid Layout
- ✅ Form Validation

### การทำงาน
- ✅ การเลือกวันที่
- ✅ การพิมพ์เวลา
- ✅ การบันทึกข้อมูล
- ✅ การแสดงผลในตาราง

## 🎉 ผลลัพธ์

หลังจากอัปเดตแล้ว คุณจะได้:
- ✅ การแก้ไขวันที่และเวลาที่แยกกัน
- ✅ ความยืดหยุ่นในการระบุเวลา
- ✅ UI ที่ใช้งานง่าย
- ✅ ความแม่นยำในการระบุวินาที
- ✅ การแสดงผลที่สวยงาม

---

**หมายเหตุ**: เวลาจะถูกบันทึกในรูปแบบ ISO 8601 (YYYY-MM-DDTHH:mm:ss) ในฐานข้อมูล 