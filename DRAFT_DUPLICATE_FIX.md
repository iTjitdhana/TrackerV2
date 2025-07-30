# Draft Duplicate Fix for Production_Planing.tsx

## การแก้ไขปัญหาการบันทึกแบบร่างของงานวันอื่น

### 1. ปัญหาที่พบ

#### ก่อนการแก้ไข
- ไม่สามารถบันทึกแบบร่างของงานวันอื่นได้
- ระบบแสดงข้อความ "ชื่องานนี้มีอยู่แล้ว" แม้ว่างานจะอยู่ในวันอื่น
- ฟังก์ชัน `isJobNameDuplicate` ตรวจสอบกับงานทั้งหมดในระบบ

#### สาเหตุของปัญหา
```typescript
// ฟังก์ชันเดิม - ตรวจสอบกับงานทั้งหมด
const isJobNameDuplicate = (name: string) => {
  const normalizedName = normalize(name);
  // ตรวจสอบกับ productionData ทั้งหมด (ทุกวัน)
  const isDuplicate = productionData.some(item => 
    normalize(item.job_name || '') === normalizedName
  );
  return isDuplicate;
};
```

### 2. การแก้ไข

#### หลังการแก้ไข
- สามารถบันทึกแบบร่างของงานวันอื่นได้
- ตรวจสอบซ้ำเฉพาะงานในวันที่เลือกเท่านั้น
- งานที่มีชื่อเดียวกันในวันอื่นสามารถบันทึกได้

#### การเปลี่ยนแปลงในฟังก์ชัน `isJobNameDuplicate`
```typescript
const isJobNameDuplicate = (name: string) => {
  const normalizedName = normalize(name);
  console.log('🔍 [DEBUG] Checking for duplicate job name:', name);
  console.log('🔍 [DEBUG] Normalized name:', normalizedName);
  console.log('🔍 [DEBUG] Selected date:', selectedDate);
  
  // กรองข้อมูลเฉพาะวันที่เลือก
  const jobsOfSelectedDate = productionData.filter(item => {
    const itemDate = item.production_date ? item.production_date.split('T')[0] : '';
    return itemDate === selectedDate;
  });
  
  console.log('🔍 [DEBUG] Jobs of selected date:', jobsOfSelectedDate.map(item => ({
    job_name: item.job_name || '',
    normalized: normalize(item.job_name || ''),
    production_date: item.production_date
  })));
  
  // ตรวจสอบซ้ำเฉพาะงานในวันที่เลือก
  const isDuplicate = jobsOfSelectedDate.some(item => 
    normalize(item.job_name || '') === normalizedName
  );
  console.log('🔍 [DEBUG] Is duplicate:', isDuplicate);
  return isDuplicate;
};
```

### 3. การทำงานใหม่

#### ขั้นตอนการตรวจสอบ
1. **กรองข้อมูลเฉพาะวันที่เลือก**
   ```typescript
   const jobsOfSelectedDate = productionData.filter(item => {
     const itemDate = item.production_date ? item.production_date.split('T')[0] : '';
     return itemDate === selectedDate;
   });
   ```

2. **ตรวจสอบซ้ำเฉพาะงานในวันนั้น**
   ```typescript
   const isDuplicate = jobsOfSelectedDate.some(item => 
     normalize(item.job_name || '') === normalizedName
   );
   ```

#### ตัวอย่างการทำงาน
```
วันที่เลือก: 2024-01-15
งานที่มีอยู่:
- 2024-01-15: "งาน A" ✅ (จะตรวจสอบซ้ำ)
- 2024-01-15: "งาน B" ✅ (จะตรวจสอบซ้ำ)
- 2024-01-16: "งาน A" ❌ (ไม่ตรวจสอบซ้ำ)
- 2024-01-17: "งาน A" ❌ (ไม่ตรวจสอบซ้ำ)

ผลลัพธ์:
- สามารถบันทึก "งาน A" ในวันที่ 2024-01-16 ได้ ✅
- สามารถบันทึก "งาน A" ในวันที่ 2024-01-17 ได้ ✅
- ไม่สามารถบันทึก "งาน A" ในวันที่ 2024-01-15 ได้ ❌ (ซ้ำ)
```

### 4. ผลลัพธ์

#### ✅ **สิ่งที่แก้ไขได้:**
- สามารถบันทึกแบบร่างของงานวันอื่นได้
- ตรวจสอบซ้ำเฉพาะงานในวันที่เลือกเท่านั้น
- งานที่มีชื่อเดียวกันในวันอื่นสามารถบันทึกได้
- ลดข้อผิดพลาด "ชื่องานนี้มีอยู่แล้ว" ที่ไม่จำเป็น

#### 🔍 **Debug Information:**
- เพิ่ม console.log เพื่อติดตามการทำงาน
- แสดงข้อมูลวันที่เลือก
- แสดงรายการงานในวันที่เลือก
- แสดงผลการตรวจสอบซ้ำ

### 5. การทดสอบ

#### สถานการณ์ทดสอบ
1. **บันทึกแบบร่างในวันปัจจุบัน**
   - ✅ ควรทำงานปกติ
   - ✅ ตรวจสอบซ้ำกับงานในวันเดียวกัน

2. **บันทึกแบบร่างในวันอื่น**
   - ✅ ควรทำงานได้
   - ✅ ไม่ตรวจสอบซ้ำกับงานในวันอื่น

3. **บันทึกแบบร่างชื่อซ้ำในวันเดียวกัน**
   - ❌ ควรแสดงข้อความ "ชื่องานนี้มีอยู่แล้ว"

4. **บันทึกแบบร่างชื่อซ้ำในวันอื่น**
   - ✅ ควรทำงานได้
   - ✅ ไม่แสดงข้อความซ้ำ

### 6. การใช้งาน

#### สำหรับผู้ใช้
1. เลือกวันที่ต้องการบันทึกแบบร่าง
2. กรอกข้อมูลงาน
3. กดปุ่ม "บันทึกแบบร่าง"
4. ระบบจะตรวจสอบซ้ำเฉพาะงานในวันที่เลือกเท่านั้น

#### สำหรับ Developer
- ฟังก์ชัน `isJobNameDuplicate` ถูกปรับปรุงให้ตรวจสอบเฉพาะวันที่เลือก
- เพิ่ม debug logs เพื่อติดตามการทำงาน
- การเปลี่ยนแปลงนี้มีผลกับทั้งการบันทึกแบบร่างและการบันทึกเสร็จสิ้น 