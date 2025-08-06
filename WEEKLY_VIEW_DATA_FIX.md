# การแก้ไขปัญหาการดึงข้อมูลในหน้ารายสัปดาห์

## 🔍 **ปัญหาที่พบ**
หน้ารายสัปดาห์ (`WeekilyView.tsx`) ไม่แสดงข้อมูลงานบางวันแม้ว่าในฐานข้อมูลจะมีข้อมูลอยู่

## 🐛 **สาเหตุของปัญหา**

### 1. **ใช้ข้อมูล Mock แทนข้อมูลจริง**
- `WeekilyView.tsx` ใช้ข้อมูล mock แทนการดึงข้อมูลจาก API
- ข้อมูล mock มีวันที่เฉพาะบางวันเท่านั้น (เช่น 2025-07-14, 2025-07-15, 2025-07-17)

### 2. **ปัญหาการเปรียบเทียบวันที่**
- ใช้ `date.toISOString().split("T")[0]` ซึ่งอาจทำให้เกิด timezone issues
- ไม่ใช้ฟังก์ชัน `formatDateForAPI()` ที่แก้ไขแล้ว

## ✅ **การแก้ไขที่ทำ**

### 1. **เพิ่มการดึงข้อมูลจริงจาก API**
```typescript
// เพิ่ม state สำหรับข้อมูล
const [productionData, setProductionData] = useState<any[]>([])
const [loading, setLoading] = useState(false)

// ฟังก์ชันดึงข้อมูลจาก API
const loadProductionData = async () => {
  setLoading(true);
  try {
    // ดึงข้อมูลจาก work plans และ drafts
    const [plansResponse, draftsResponse] = await Promise.all([
      fetch(getApiUrl('/api/work-plans')),
      fetch(getApiUrl('/api/work-plans/drafts'))
    ]);

    const plans = await plansResponse.json();
    const drafts = await draftsResponse.json();

    // รวมข้อมูลจาก drafts และ plans
    const allData = [
      ...(drafts.data || []).map((d: any) => {
        // แปลงข้อมูล drafts
        return {
          id: `draft_${d.id}`,
          date: d.production_date,
          title: d.job_name,
          room: d.production_room_id || d.production_room || 'ไม่ระบุ',
          staff: operatorNames,
          time: `${d.start_time || ''} - ${d.end_time || ''}`,
          status: status,
          recordStatus: recordStatus,
          notes: d.notes || '',
          isDraft: true,
        };
      }),
      ...(plans.data || []).map((p: any) => {
        // แปลงข้อมูล work plans
        return {
          id: p.id,
          date: p.production_date,
          title: p.job_name,
          room: draft?.production_room_id || draft?.production_room || 'ไม่ระบุ',
          staff: p.operators || '',
          time: `${p.start_time || ''} - ${p.end_time || ''}`,
          status: status,
          recordStatus: status_name,
          notes: draft?.notes || '',
          isDraft: false,
        };
      })
    ];

    setProductionData(allData);
  } catch (error) {
    console.error('Error loading production data:', error);
  } finally {
    setLoading(false);
  }
};
```

### 2. **แก้ไขการเปรียบเทียบวันที่**
```typescript
// เดิม (มีปัญหา)
const dateStr = date.toISOString().split("T")[0]

// ใหม่ (แก้ไขแล้ว)
const dateStr = formatDateForAPI(date)
```

### 3. **เพิ่มปุ่ม Refresh และ Loading State**
```typescript
// เพิ่มปุ่ม refresh ใน header
<Button
  variant="ghost"
  size="sm"
  onClick={loadProductionData}
  disabled={loading}
  className="text-white hover:bg-green-700 border border-green-500 rounded-lg px-2 py-1 text-xs"
>
  <RefreshCw className={`w-3 h-3 sm:w-4 sm:h-4 ${loading ? 'animate-spin' : ''}`} />
  <span className="hidden sm:inline ml-1">รีเฟรช</span>
</Button>

{loading && (
  <span className="text-xs text-green-100">กำลังโหลด...</span>
)}
```

### 4. **เพิ่ม Debug Logging**
```typescript
// เพิ่ม debug logs เพื่อตรวจสอบข้อมูล
console.log('🔍 [DEBUG] Week range:', weekStart, 'to', weekEnd);
console.log('🔍 [DEBUG] Available dates in productionData:', productionData.map(item => item.date));
console.log('📊 [DEBUG] Week production data:', weekProduction);
```

## 🔧 **การเปลี่ยนแปลงหลัก**

### ไฟล์ที่แก้ไข:
- `WeekilyView.tsx`

### การเปลี่ยนแปลง:
1. **ลบข้อมูล mock** และแทนที่ด้วยการดึงข้อมูลจริงจาก API
2. **เพิ่ม state management** สำหรับข้อมูลและ loading state
3. **แก้ไขการเปรียบเทียบวันที่** ให้ใช้ `formatDateForAPI()`
4. **เพิ่มปุ่ม refresh** และแสดงสถานะ loading
5. **เพิ่ม debug logging** เพื่อตรวจสอบข้อมูล

## 📊 **ผลลัพธ์ที่คาดหวัง**

### ก่อนแก้ไข:
- หน้ารายสัปดาห์แสดงข้อมูล mock เท่านั้น
- บางวันไม่มีข้อมูลแม้ว่าในฐานข้อมูลจะมี
- ไม่สามารถ refresh ข้อมูลได้

### หลังแก้ไข:
- หน้ารายสัปดาห์แสดงข้อมูลจริงจากฐานข้อมูล
- ทุกวันที่มีข้อมูลในฐานข้อมูลจะแสดงผล
- สามารถ refresh ข้อมูลได้
- มีการแสดงสถานะ loading

## 🧪 **การทดสอบ**

1. **เปิดหน้ารายสัปดาห์** และตรวจสอบว่าข้อมูลแสดงถูกต้อง
2. **เปลี่ยนสัปดาห์** และตรวจสอบว่าข้อมูลอัปเดต
3. **กดปุ่ม refresh** และตรวจสอบว่าข้อมูลโหลดใหม่
4. **ตรวจสอบ console logs** เพื่อดู debug information

## 📝 **หมายเหตุ**

- การแก้ไขนี้ใช้ API endpoints เดียวกับหน้ารายวัน
- ข้อมูลจะถูกดึงจากทั้ง `work_plans` และ `work_plan_drafts` tables
- การเปรียบเทียบวันที่ใช้ฟังก์ชัน `formatDateForAPI()` ที่แก้ไข timezone issues แล้ว 