# 图书管理系统 - 项目规格说明书

## 1. 项目概述

**项目名称：** Library Management System (LMS)
**项目类型：** 图书馆 Web 管理系统
**目标用户：** 读者（用户端）、管理员（管理端）
**核心功能：** 图书管理、借阅管理、用户管理

## 2. 技术架构

```
Flutter Web 前端 ──Firebase Hosting──→ CDN
Spring Boot 后端 ──Cloud Run──→ API
Cloud SQL MySQL ← 后端直连
GitHub Actions ← Flutter Web 构建 + 自动触发部署
```

## 3. 数据库设计

### `book` 图书表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK | 主键 |
| isbn | VARCHAR(20) | ISBN 编号（唯一） |
| title | VARCHAR(100) | 书名 |
| author | VARCHAR(50) | 作者 |
| publisher | VARCHAR(50) | 出版社 |
| category | VARCHAR(30) | 分类 |
| cover_url | VARCHAR(255) | 封面图 URL |
| stock | INT | 库存数量 |
| total | INT | 总数量 |
| price | DECIMAL(10,2) | 定价 |
| description | TEXT | 简介 |
| status | TINYINT | 状态：0=下架，1=上架 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### `reader` 读者表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK | 主键 |
| username | VARCHAR(50) | 用户名（唯一） |
| password | VARCHAR(255) | 密码（BCrypt） |
| real_name | VARCHAR(50) | 真实姓名 |
| phone | VARCHAR(20) | 手机号 |
| email | VARCHAR(50) | 邮箱 |
| status | TINYINT | 状态：0=禁用，1=启用 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### `admin` 管理员表
同医生管理系统的 admin 表

### `borrow_record` 借阅记录表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK | 主键 |
| book_id | BIGINT FK | 图书ID |
| reader_id | BIGINT FK | 读者ID |
| borrow_date | DATE | 借书日期 |
| due_date | DATE | 应还日期 |
| return_date | DATE | 实际归还日期（NULL=未还） |
| status | VARCHAR(20) | BORROWED/RETURNED/OVERDUE |
| created_at | DATETIME | 创建时间 |

## 4. API 设计

### 认证接口
```
POST /api/auth/reader/login   → { username, password } → { token, readerInfo }
POST /api/auth/admin/login    → { username, password } → { token, adminInfo }
POST /api/auth/logout
GET  /api/auth/me
```

### 图书管理（Admin）
```
GET    /api/books            → 分页列表（支持关键词/分类搜索）
POST   /api/books            → 创建图书
GET    /api/books/{id}       → 图书详情
PUT    /api/books/{id}       → 更新图书
DELETE /api/books/{id}       → 删除图书
```

### 读者管理（Admin）
```
GET    /api/readers          → 分页列表
POST   /api/readers          → 创建读者
GET    /api/readers/{id}     → 读者详情
PUT    /api/readers/{id}     → 更新读者
DELETE /api/readers/{id}     → 删除读者
```

### 借阅管理（Reader + Admin）
```
GET    /api/borrows                      → 借阅记录（读者只能看自己的，管理员全量）
POST   /api/borrows                      → 借书
PUT    /api/borrows/{id}/return          → 还书
GET    /api/borrows/my                   → 我的借阅记录（读者端）
```

### 仪表盘（Admin）
```
GET    /api/dashboard/stats              → 统计数据
```

## 5. Flutter 页面结构

### 读者端
- `/login` — 读者登录
- `/` — 首页（图书搜索）
- `/books` — 图书列表
- `/books/:id` — 图书详情
- `/my-borrows` — 我的借阅记录
- `/profile` — 个人中心

### 管理端
- `/admin/login` — 管理员登录
- `/admin` — 管理后台首页
- `/admin/books` — 图书管理
- `/admin/readers` — 读者管理
- `/admin/borrows` — 借阅管理
- `/admin/dashboard` — 数据统计
