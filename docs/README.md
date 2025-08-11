# Documentation Directory

โฟลเดอร์นี้เก็บเอกสารและคู่มือต่างๆ สำหรับระบบ WorkplanV6

## 📁 โครงสร้าง

### guides/
คู่มือการใช้งานและ setup
- `QUICK_START_GUIDE.md` - คู่มือเริ่มต้นใช้งาน
- `ENVIRONMENT_SETUP.md` - คู่มือตั้งค่าสภาพแวดล้อม
- `DOCKER_REGISTRY_GUIDE.md` - คู่มือ Docker Registry
- `GITHUB_CONTAINER_REGISTRY_GUIDE.md` - คู่มือ GitHub Container Registry

### fixes/
เอกสารการแก้ไขปัญหา
- `FIX_API_URL_ISSUE.md` - แก้ไขปัญหา API URL
- `FIX_DELETE_SAVE_ISSUES.md` - แก้ไขปัญหา Delete/Save
- `FIX_NODEJS_ISSUES.md` - แก้ไขปัญหา Node.js
- `FIX_SEARCH_ISSUE.md` - แก้ไขปัญหาการค้นหา

### updates/
เอกสารการอัปเดตระบบ
- `PRODUCTION_LOGS_UPDATE.md` - อัปเดต Production Logs
- `REPORTS_SYSTEM_UPDATE.md` - อัปเดตระบบ Reports
- `GOOGLE_SHEET_SYNC_FIX.md` - แก้ไขการ sync Google Sheets
- `GOOGLE_SHEET_API_ANALYSIS.md` - การวิเคราะห์ Google Sheets API

### deployment/
คู่มือการ deploy
- `PRODUCTION_DEPLOYMENT_GUIDE.md` - คู่มือ deploy production
- `SERVER_DEPLOYMENT_GUIDE.md` - คู่มือ deploy server
- `DOCKER_UPDATE_GUIDE.md` - คู่มืออัปเดต Docker

### system/
เอกสารระบบและ architecture
- `LOGS_SYSTEM_README.md` - เอกสารระบบ Logs
- `NEW_JOBS_SYSTEM_README.md` - เอกสารระบบ New Jobs
- `Machine_Mapping_Logic.md` - ตรรกะการ map เครื่องจักร

## 📚 เอกสารหลัก

### Master.md
เอกสารหลักที่รวมข้อมูลทั้งหมดของระบบ

### README_DOCKER.md
คู่มือการใช้งาน Docker

### TROUBLESHOOTING.md
คู่มือการแก้ไขปัญหา

### MD_FILES_ORGANIZATION_SUMMARY.md
สรุปการจัดระเบียบไฟล์ MD

## 🔍 การค้นหาเอกสาร

### ตามประเภทปัญหา
- **API Issues**: ดูใน `fixes/`
- **Deployment Issues**: ดูใน `deployment/`
- **System Updates**: ดูใน `updates/`

### ตามระบบ
- **Logs System**: ดูใน `system/LOGS_SYSTEM_README.md`
- **New Jobs System**: ดูใน `system/NEW_JOBS_SYSTEM_README.md`
- **Machine Mapping**: ดูใน `system/Machine_Mapping_Logic.md`

## 📝 การอัปเดตเอกสาร

เมื่อมีการเปลี่ยนแปลงระบบ:
1. อัปเดตเอกสารที่เกี่ยวข้อง
2. เพิ่มรายการใน `updates/` หากมีการเปลี่ยนแปลงใหญ่
3. อัปเดต `Master.md` หากจำเป็น
4. ตรวจสอบความถูกต้องของลิงก์

## 🚀 การใช้งาน

### ค้นหาเอกสาร
```bash
# ค้นหาไฟล์ MD
find docs/ -name "*.md" -type f

# ค้นหาข้อความในเอกสาร
grep -r "คำค้นหา" docs/
```

### อ่านเอกสาร
- ใช้ Markdown viewer
- หรือเปิดใน GitHub/GitLab
- หรือใช้ VS Code with Markdown preview
