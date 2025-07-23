# WorkplansV4 - ระบบจัดการแผนการผลิตครัวกลาง

ระบบจัดการแผนการผลิตครัวกลาง บริษัท จิตต์ธนา จำกัด (สำนักงานใหญ่)

## 🚀 คุณสมบัติหลัก

- **จัดการแผนการผลิต**: สร้าง แก้ไข และติดตามแผนการผลิตรายวัน/รายสัปดาห์
- **ระบบผู้ปฏิบัติงาน**: จัดการข้อมูลผู้ปฏิบัติงานและการมอบหมายงาน
- **ติดตามสถานะ**: ติดตามสถานะการผลิตแบบเรียลไทม์
- **บันทึกข้อมูล**: บันทึกเวลาเริ่ม-สิ้นสุดงาน และหมายเหตุ
- **ส่งออกข้อมูล**: ส่งข้อมูลไป Google Sheets อัตโนมัติ
- **ระบบแบบร่าง**: บันทึกแบบร่างและแปลงเป็นแผนจริง

## 🛠️ เทคโนโลยีที่ใช้

### Frontend
- **Next.js 15** - React Framework
- **TypeScript** - Type Safety
- **Tailwind CSS** - Styling
- **Shadcn/ui** - UI Components
- **Lucide React** - Icons

### Backend
- **Node.js** - Runtime Environment
- **Express.js** - Web Framework
- **MySQL** - Database
- **CORS** - Cross-Origin Resource Sharing
- **Helmet** - Security Middleware

## 📋 ข้อกำหนดระบบ

- Node.js 18+ 
- MySQL 8.0+
- npm หรือ yarn

## 🔧 การติดตั้ง

### 1. Clone Repository
```bash
git clone https://github.com/iTjitdhana/WorkplansV4.git
cd WorkplansV4
```

### 2. ติดตั้ง Dependencies

#### Backend
```bash
cd backend
npm install
```

#### Frontend
```bash
cd frontend
npm install
```

### 3. ตั้งค่า Database
- สร้างฐานข้อมูล MySQL
- Import ไฟล์ SQL ที่อยู่ในโฟลเดอร์ `backend/`
- ตั้งค่าการเชื่อมต่อในไฟล์ `backend/config/database.js`

### 4. การรันระบบ

#### วิธีที่ 1: รันแยกกัน
```bash
# Terminal 1 - Backend
cd backend
npm run dev

# Terminal 2 - Frontend  
cd frontend
npm run dev
```

#### วิธีที่ 2: ใช้ Script (Windows)
```bash
start-dev.bat
```

#### วิธีที่ 3: ใช้ Script (Linux/Mac)
```bash
./start-dev.sh
```

## 🌐 การเข้าถึงระบบ

- **Frontend**: http://192.168.0.94:3011
- **Backend API**: http://192.168.0.94:3101
- **Tracker**: http://192.168.0.94:3011/tracker

## 📁 โครงสร้างโปรเจค

```
WorkplansV4/
├── backend/                 # Backend API Server
│   ├── config/             # Database Configuration
│   ├── controllers/        # API Controllers
│   ├── middleware/         # Express Middleware
│   ├── models/            # Database Models
│   ├── routes/            # API Routes
│   └── server.js          # Main Server File
├── frontend/               # Frontend Next.js App
│   ├── app/               # Next.js App Router
│   ├── components/        # React Components
│   ├── hooks/             # Custom Hooks
│   ├── lib/               # Utilities
│   └── styles/            # CSS Styles
├── assets/                # Static Assets
├── start-dev.bat          # Windows Start Script
├── start-dev.sh           # Linux/Mac Start Script
└── README.md              # Documentation
```

## 🔗 API Endpoints

### Work Plans
- `GET /api/work-plans` - ดึงรายการแผนการผลิต
- `POST /api/work-plans/drafts` - สร้างแบบร่าง
- `PUT /api/work-plans/drafts/:id` - แก้ไขแบบร่าง
- `DELETE /api/work-plans/drafts/:id` - ลบแบบร่าง

### Users & Resources
- `GET /api/users` - ดึงรายการผู้ใช้
- `GET /api/machines` - ดึงรายการเครื่องจักร
- `GET /api/production-rooms` - ดึงรายการห้องผลิต

### Tracking
- `GET /api/logs/work-plan/:id` - ดึงประวัติการทำงาน
- `POST /api/logs` - บันทึกเวลาเริ่ม/หยุดงาน

## 🎯 การใช้งาน

### 1. สร้างแผนการผลิต
- เลือกวันที่ผลิต
- ค้นหาและเลือกงานผลิต
- กำหนดผู้ปฏิบัติงาน (1-4 คน)
- ตั้งเวลาเริ่ม-สิ้นสุด
- เลือกเครื่องจักรและห้องผลิต
- บันทึกแบบร่างหรือบันทึกเสร็จสิ้น

### 2. ติดตามการผลิต
- เข้าหน้า Tracker
- เลือกแผนการผลิต
- เริ่ม/หยุดขั้นตอนการทำงาน
- ดูสถานะและเวลาที่ใช้

### 3. ส่งออกข้อมูล
- กดปุ่ม "Sync พิมพ์ใบงานผลิต"
- ระบบจะส่งข้อมูลไป Google Sheets
- เปิด Google Sheets เพื่อดูผลลัพธ์

## 🔒 ความปลอดภัย

- CORS Policy สำหรับ Cross-Origin Requests
- Helmet.js สำหรับ Security Headers
- Rate Limiting สำหรับป้องกัน DDoS
- Input Validation และ Sanitization

## 🐛 การแก้ไขปัญหา

### Backend ไม่เริ่มต้น
- ตรวจสอบการเชื่อมต่อฐานข้อมูล
- ตรวจสอบ Port 3101 ว่าว่างหรือไม่

### Frontend ไม่เริ่มต้น
- ตรวจสอบ Port 3011 ว่าว่างหรือไม่
- ลบโฟลเดอร์ `.next` และรัน `npm run dev` ใหม่

### API ไม่ทำงาน
- ตรวจสอบ CORS Configuration
- ตรวจสอบ IP Address ในการตั้งค่า

## 👥 ผู้พัฒนา

- แผนกเทคโนโลยีสารสนเทศ บริษัท จิตต์ธนา จำกัด (สำนักงานใหญ่)

## 📄 License

© 2025 บริษัท จิตต์ธนา จำกัด (สำนักงานใหญ่) - All Rights Reserved 