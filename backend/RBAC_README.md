# RBAC (Role-Based Access Control) System

ระบบจัดการสิทธิ์การเข้าถึงเมนูตามบทบาทของผู้ใช้

## 📋 ภาพรวม

ระบบ RBAC นี้ถูกออกแบบมาเพื่อควบคุมการเข้าถึงเมนู "ระบบจัดการข้อมูล" ตามบทบาทของผู้ใช้ โดยมีฟีเจอร์หลักดังนี้:

- **จัดการเมนู**: กำหนดเมนูที่แต่ละบทบาทสามารถเข้าถึงได้
- **Audit Trail**: บันทึกประวัติการเปลี่ยนแปลงสิทธิ์
- **API Protection**: ป้องกันการเข้าถึง API ที่ไม่มีสิทธิ์
- **Frontend Integration**: ซ่อน/แสดงเมนูตามสิทธิ์

## 🗄️ โครงสร้างฐานข้อมูล

### ตารางหลัก

1. **menu_catalog** - เก็บข้อมูลเมนูทั้งหมด
   - `menu_key` (unique): คีย์ของเมนู (เช่น 'logs', 'users')
   - `label`: ชื่อที่แสดงในเมนู
   - `path`: URL path ของเมนู
   - `menu_group`: กลุ่มของเมนู
   - `sort_order`: ลำดับการแสดงผล

2. **role_menu_permissions** - เก็บสิทธิ์ของบทบาทต่อเมนู
   - `role_id`: ID ของบทบาท
   - `menu_key`: คีย์ของเมนู
   - `can_view`: สิทธิ์การเข้าถึง (true/false)

3. **role_menu_audits** - เก็บประวัติการเปลี่ยนแปลงสิทธิ์
   - `actor_user_id`: ผู้ที่ทำการเปลี่ยนแปลง
   - `role_id`: บทบาทที่ถูกเปลี่ยนแปลง
   - `action`: การกระทำ (grant/revoke/bulk_update)
   - `before_data`/`after_data`: ข้อมูลก่อน/หลังการเปลี่ยนแปลง

## 🔗 API Endpoints

### Menu Catalog
- `GET /api/admin/menu-catalog` - ดึงรายการเมนูทั้งหมด

### Role Management
- `GET /api/admin/roles` - ดึงรายการบทบาทพร้อมสรุปสิทธิ์
- `GET /api/admin/roles/:roleId/permissions` - ดึงสิทธิ์ของบทบาท
- `GET /api/admin/roles/:roleId/menu-keys` - ดึงเมนูที่บทบาทเข้าถึงได้
- `PUT /api/admin/roles/:roleId/permissions` - อัปเดตสิทธิ์ของบทบาท

### Individual Permissions
- `POST /api/admin/roles/:roleId/permissions/:menuKey/grant` - ให้สิทธิ์เมนู
- `POST /api/admin/roles/:roleId/permissions/:menuKey/revoke` - เพิกถอนสิทธิ์เมนู

### Audit
- `GET /api/admin/roles/:roleId/audit-logs` - ดึงประวัติการเปลี่ยนแปลงของบทบาท
- `GET /api/admin/audit-logs` - ดึงประวัติการเปลี่ยนแปลงทั้งหมด
- `GET /api/admin/audit-summary` - ดึงสรุปประวัติการเปลี่ยนแปลง

### User Permissions
- `GET /api/me/permissions` - ดึงสิทธิ์เมนูของผู้ใช้ปัจจุบัน
- `GET /api/me/permissions/:menuKey/check` - ตรวจสอบสิทธิ์เมนูของผู้ใช้

## 🛡️ Middleware

### การใช้งาน Middleware

```javascript
const { requireMenuPermission, requireAdminRole } = require('./middleware/roleMenuMiddleware');

// ตรวจสอบสิทธิ์เมนูเดียว
app.get('/admin/users', requireMenuPermission('users'), handler);

// ตรวจสอบสิทธิ์หลายเมนู (ต้องมีอย่างน้อย 1 เมนู)
app.get('/admin/dashboard', requireAnyMenuPermission(['logs', 'production']), handler);

// ตรวจสอบสิทธิ์หลายเมนู (ต้องมีทุกเมนู)
app.get('/admin/reports', requireAllMenuPermissions(['reports', 'logs']), handler);

// ตรวจสอบบทบาท admin
app.get('/admin/settings', requireAdminRole(), handler);
```

## 🚀 การติดตั้งและใช้งาน

### 1. รัน Script Seed ข้อมูล
```bash
cd backend
node seed-role-menu-data.js
```

### 2. ตรวจสอบข้อมูลที่ถูกสร้าง
```sql
-- ดูเมนูทั้งหมด
SELECT * FROM menu_catalog;

-- ดูสิทธิ์ของบทบาท
SELECT 
  rc.display_name,
  mc.label,
  rmp.can_view
FROM role_menu_permissions rmp
JOIN role_configurations rc ON rmp.role_id = rc.id
JOIN menu_catalog mc ON rmp.menu_key = mc.menu_key
ORDER BY rc.display_name, mc.sort_order;
```

### 3. ทดสอบ API
```bash
# ดึงรายการเมนู
curl http://localhost:3101/api/admin/menu-catalog

# ดึงสิทธิ์ของบทบาท
curl http://localhost:3101/api/admin/roles/2/permissions

# ดึงสิทธิ์ของผู้ใช้ปัจจุบัน
curl http://localhost:3101/api/me/permissions
```

## 📊 การกำหนดสิทธิ์เริ่มต้น

### บทบาทและสิทธิ์

1. **Planner (ID: 1)**
   - หน้าหลัก, ระบบจัดการ Logs, ติดตามการผลิต

2. **Admin (ID: 2)**
   - ทุกเมนู (หน้าหลัก, ระบบจัดการ Logs, ติดตามการผลิต, รายงาน, จัดการผู้ใช้, ตั้งค่าระบบ, ติดตามสถานะ)

3. **Viewer (ID: 4)**
   - หน้าหลัก, ระบบจัดการ Logs, รายงาน

4. **Operation (ID: 5)**
   - หน้าหลัก, ระบบจัดการ Logs, ติดตามการผลิต, รายงาน, ติดตามสถานะ

## 🔧 การปรับแต่ง

### เพิ่มเมนูใหม่
```sql
INSERT INTO menu_catalog (menu_key, label, path, menu_group, sort_order, is_active)
VALUES ('new-menu', 'เมนูใหม่', '/admin/new-menu', 'system', 80, true);
```

### กำหนดสิทธิ์ให้บทบาท
```javascript
// ผ่าน API
PUT /api/admin/roles/1/permissions
{
  "menu_permissions": [
    { "menu_key": "new-menu", "can_view": true }
  ],
  "reason": "เพิ่มสิทธิ์เมนูใหม่"
}
```

### ใช้ Middleware ใน Route
```javascript
// ในไฟล์ route
const { requireMenuPermission } = require('../middleware/roleMenuMiddleware');

router.get('/admin/new-menu', requireMenuPermission('new-menu'), (req, res) => {
  // Handler code
});
```

## 🎯 การใช้งานใน Frontend

### 1. ดึงสิทธิ์ของผู้ใช้
```javascript
const response = await fetch('/api/me/permissions');
const { data } = await response.json();
const userMenus = data.menu_keys; // ['home', 'logs', 'production']
```

### 2. ซ่อน/แสดงเมนู
```javascript
const menuItems = [
  { key: 'home', label: 'หน้าหลัก', path: '/admin/home' },
  { key: 'logs', label: 'ระบบจัดการ Logs', path: '/admin/logs' },
  { key: 'users', label: 'จัดการผู้ใช้', path: '/admin/users' }
];

const visibleMenus = menuItems.filter(menu => 
  userMenus.includes(menu.key)
);
```

### 3. Route Guard
```javascript
// ตรวจสอบสิทธิ์ก่อนเข้าหน้า
const hasPermission = userMenus.includes('users');
if (!hasPermission) {
  // Redirect to unauthorized page
  window.location.href = '/unauthorized';
}
```

## 🔍 การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

1. **ไม่พบข้อมูลเมนู**
   - รัน `node seed-role-menu-data.js` อีกครั้ง

2. **API ส่ง 403 Forbidden**
   - ตรวจสอบว่า `req.user.role_id` มีค่าถูกต้อง
   - ตรวจสอบสิทธิ์ในตาราง `role_menu_permissions`

3. **Frontend ไม่แสดงเมนู**
   - ตรวจสอบ API `/api/me/permissions`
   - ตรวจสอบการ filter เมนูใน frontend

### การ Debug
```javascript
// เพิ่ม logging ใน middleware
console.log('User role ID:', req.user?.role_id);
console.log('Checking menu:', menuKey);
console.log('Has permission:', hasPermission);
```

## 📝 หมายเหตุ

- ระบบนี้ต้องการการเชื่อมต่อกับระบบ Authentication ที่มี `req.user.role_id`
- ข้อมูล Audit จะถูกเก็บไว้ 1 ปี (สามารถปรับได้ใน `RoleMenuAudit.cleanOldLogs()`)
- การเปลี่ยนแปลงสิทธิ์จะถูกบันทึกใน Audit log ทุกครั้ง
