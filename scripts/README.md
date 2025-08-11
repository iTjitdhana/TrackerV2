# Scripts Directory - จัดการไฟล์ .bat

โฟลเดอร์นี้จัดเก็บไฟล์ .bat ทั้งหมดที่ใช้ในการจัดการระบบ WorkplanV6 โดยแบ่งเป็นหมวดหมู่ตามการใช้งาน

## โครงสร้างโฟลเดอร์

### 📁 docker/
ไฟล์สำหรับจัดการ Docker containers, images และ registry
- `start-docker*.bat` - เริ่มต้น Docker containers
- `fix-docker*.bat` - แก้ไขปัญหา Docker
- `build-and-push.bat` - สร้างและอัปโหลด Docker images

### 📁 database/
ไฟล์สำหรับจัดการฐานข้อมูล MySQL
- `setup-mysql*.bat` - ติดตั้งและตั้งค่า MySQL
- `fix-database*.bat` - แก้ไขปัญหาฐานข้อมูล
- `test-database*.bat` - ทดสอบการเชื่อมต่อฐานข้อมูล

### 📁 deployment/
ไฟล์สำหรับการ deploy และ production
- `deploy*.bat` - deploy ระบบ
- `build*.bat` - build ระบบ
- `production*.bat` - จัดการ production environment

### 📁 fixes/
ไฟล์สำหรับแก้ไขปัญหาต่างๆ
- `fix-*.bat` - แก้ไขปัญหาต่างๆ เช่น TypeScript, search, dropdown

### 📁 startup/
ไฟล์สำหรับเริ่มต้นระบบ
- `start-*.bat` - เริ่มต้นระบบต่างๆ
- `quick-*.bat` - เริ่มต้นแบบรวดเร็ว

### 📁 testing/
ไฟล์สำหรับทดสอบระบบ
- `test-*.bat` - ทดสอบฟีเจอร์ต่างๆ
- `check-*.bat` - ตรวจสอบสถานะระบบ

### 📁 setup/
ไฟล์สำหรับติดตั้งและตั้งค่าระบบ
- `setup-*.bat` - ติดตั้งระบบ
- `install-*.bat` - ติดตั้ง dependencies
- `create-*.bat` - สร้างไฟล์และโฟลเดอร์

## การใช้งาน

### 🚀 เริ่มต้นใช้งาน
```bash
# เมนูหลักสำหรับการใช้งานทั่วไป
scripts\quick-commands.bat

# จัดการระบบแบบครบวงจร
scripts\system-manager.bat

# ติดตั้งระบบใหม่
scripts\install-system.bat

# แสดงรายการไฟล์ที่มีอยู่จริง
scripts\list-available-scripts.bat
```

### 📋 ตรวจสอบไฟล์ที่มีอยู่
หากพบข้อผิดพลาด "The system cannot find the path specified" ให้รัน:
```bash
scripts\list-available-scripts.bat
```

### 🔧 การแก้ไขปัญหา
สคริปต์หลักจะตรวจสอบไฟล์ที่มีอยู่จริงและแสดงข้อความแจ้งเตือนหากไม่พบไฟล์

### 📁 การใช้งานไฟล์โดยตรง
หากต้องการใช้งานไฟล์โดยตรง ให้ตรวจสอบชื่อไฟล์ที่ถูกต้องในแต่ละโฟลเดอร์:
```bash
# ตัวอย่างการใช้งานไฟล์ที่มีอยู่จริง
scripts\startup\quick-start-simple.bat
scripts\startup\start-backend-simple.bat
scripts\startup\start-frontend-simple.bat
scripts\testing\check-system.bat
scripts\testing\test-network-access.bat
scripts\fixes\fix-all-typescript.bat
scripts\fixes\fix-searchbox-add-new.bat
```

## หมายเหตุ

- ไฟล์ .bat ทั้งหมดควรรันจากโฟลเดอร์หลักของโปรเจค
- ตรวจสอบ environment variables ก่อนรันสคริปต์
- บางสคริปต์อาจต้องรันด้วยสิทธิ์ Administrator
- ตรวจสอบ logs หากเกิดปัญหา
