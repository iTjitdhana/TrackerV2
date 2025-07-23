# 🔧 การแก้ไขปัญหา Database Schema

## ปัญหาที่พบ
```
Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'IF NOT EXISTS `status_id` int(11) DEFAULT 1 COMMENT 'สถานะการผ' at line 2
```

## สาเหตุ
MySQL เวอร์ชันเก่าไม่รองรับ `ADD COLUMN IF NOT EXISTS` และ `ADD CONSTRAINT IF NOT EXISTS`

## วิธีแก้ไข

### วิธีที่ 1: ใช้ไฟล์ fix_database_simple.sql (แนะนำ)

1. **เปิด phpMyAdmin**
2. **เลือกฐานข้อมูล `esp_tracker`**
3. **ไปที่แท็บ SQL**
4. **Copy และ paste เนื้อหาจากไฟล์ `fix_database_simple.sql`**
5. **กด Execute**

### วิธีที่ 2: รันทีละคำสั่ง

#### ขั้นตอนที่ 1: สร้างตาราง production_statuses
```sql
CREATE TABLE IF NOT EXISTS `production_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'ชื่อสถานะ',
  `description` text COMMENT 'คำอธิบายสถานะ',
  `color` varchar(7) NOT NULL COMMENT 'สีของสถานะ (hex code)',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'สถานะการใช้งาน (1=ใช้งาน, 0=ไม่ใช้งาน)',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ตารางสถานะการผลิต';
```

#### ขั้นตอนที่ 2: เพิ่มข้อมูลสถานะ
```sql
INSERT INTO `production_statuses` (`id`, `name`, `description`, `color`, `is_active`) VALUES
(1, 'รอดำเนินการ', 'งานที่ยังไม่ได้เริ่มดำเนินการ', '#FF6B6B', 1),
(2, 'กำลังดำเนินการ', 'งานที่กำลังดำเนินการอยู่', '#4ECDC4', 1),
(3, 'รอตรวจสอบ', 'งานที่เสร็จแล้วรอการตรวจสอบ', '#45B7D1', 1),
(4, 'เสร็จสิ้น', 'งานที่เสร็จสิ้นแล้ว', '#96CEB4', 1),
(5, 'ระงับการทำงาน', 'งานที่ถูกระงับการทำงานชั่วคราว', '#FFEAA7', 1),
(6, 'ยกเลิก', 'งานที่ถูกยกเลิก', '#DDA0DD', 1),
(7, 'ล่าช้า', 'งานที่ล่าช้ากว่ากำหนด', '#FF8C42', 1),
(8, 'เร่งด่วน', 'งานที่มีความเร่งด่วนสูง', '#FF4757', 1),
(9, 'ยกเลิกการผลิต', 'งานที่ถูกยกเลิกการผลิต', '#FF4757', 1),
(10, 'งานพิเศษ', 'งานที่เพิ่มหลัง 18:00 น.', '#FFA500', 1);
```

#### ขั้นตอนที่ 3: เพิ่ม column status_id (ถ้ายังไม่มี)
```sql
ALTER TABLE `work_plans` ADD COLUMN `status_id` int(11) DEFAULT 1 COMMENT 'สถานะการผลิต';
```

#### ขั้นตอนที่ 4: เพิ่ม foreign key (ถ้ายังไม่มี)
```sql
ALTER TABLE `work_plans` ADD CONSTRAINT `fk_work_plans_status` 
FOREIGN KEY (`status_id`) REFERENCES `production_statuses` (`id`) 
ON DELETE SET NULL ON UPDATE CASCADE;
```

#### ขั้นตอนที่ 5: อัพเดทข้อมูลที่มีอยู่
```sql
UPDATE `work_plans` SET `status_id` = 1 WHERE `status_id` IS NULL;
```

### วิธีที่ 3: ใช้ MySQL Command Line
```bash
cd backend
mysql -u root -p esp_tracker < fix_database_simple.sql
```

## ตรวจสอบผลลัพธ์
หลังจากรัน SQL script แล้ว ควรมี:
- ✅ ตาราง `production_statuses` พร้อมข้อมูลสถานะ 10 รายการ
- ✅ Column `status_id` ในตาราง `work_plans`
- ✅ Foreign key constraint ระหว่างตาราง

## Restart Backend
```bash
# หยุด backend (Ctrl+C)
# รันใหม่
npm run dev
```

## สถานะที่เพิ่มเข้ามา
1. **รอดำเนินการ** - งานที่ยังไม่ได้เริ่ม
2. **กำลังดำเนินการ** - งานที่กำลังทำอยู่
3. **รอตรวจสอบ** - งานที่เสร็จแล้วรอตรวจสอบ
4. **เสร็จสิ้น** - งานที่เสร็จสิ้นแล้ว
5. **ระงับการทำงาน** - งานที่ถูกระงับชั่วคราว
6. **ยกเลิก** - งานที่ถูกยกเลิก
7. **ล่าช้า** - งานที่ล่าช้ากว่ากำหนด
8. **เร่งด่วน** - งานที่มีความเร่งด่วนสูง
9. **ยกเลิกการผลิต** - งานที่ถูกยกเลิกการผลิต
10. **งานพิเศษ** - งานที่เพิ่มหลัง 18:00 น.

## หมายเหตุ
- โค้ดได้ถูกปรับให้รองรับกรณีที่ยังไม่มี column `status_id`
- ระบบจะใช้ fallback query หากยังไม่ได้รัน SQL script
- แนะนำให้รัน SQL script เพื่อให้ฟีเจอร์ทั้งหมดทำงานได้สมบูรณ์ 