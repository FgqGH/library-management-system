-- V1__init_schema.sql 图书管理系统数据库初始化

CREATE TABLE IF NOT EXISTS book (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE COMMENT 'ISBN编号',
    title VARCHAR(100) NOT NULL COMMENT '书名',
    author VARCHAR(50) COMMENT '作者',
    publisher VARCHAR(50) COMMENT '出版社',
    category VARCHAR(30) COMMENT '分类',
    cover_url VARCHAR(255) COMMENT '封面图URL',
    stock INT DEFAULT 0 COMMENT '库存数量',
    total INT DEFAULT 0 COMMENT '总数量',
    price DECIMAL(10,2) COMMENT '定价',
    description TEXT COMMENT '简介',
    status TINYINT DEFAULT 1 COMMENT '状态：0=下架，1=上架',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书表';

CREATE TABLE IF NOT EXISTS reader (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(50) COMMENT '邮箱',
    status TINYINT DEFAULT 1 COMMENT '状态：0=禁用，1=启用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='读者表';

CREATE TABLE IF NOT EXISTS admin (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    role VARCHAR(20) DEFAULT 'ADMIN' COMMENT '角色',
    status TINYINT DEFAULT 1 COMMENT '状态',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

CREATE TABLE IF NOT EXISTS borrow_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT NOT NULL COMMENT '图书ID',
    reader_id BIGINT NOT NULL COMMENT '读者ID',
    borrow_date DATE NOT NULL COMMENT '借书日期',
    due_date DATE NOT NULL COMMENT '应还日期',
    return_date DATE COMMENT '实际归还日期',
    status VARCHAR(20) DEFAULT 'BORROWED' COMMENT 'BORROWED/RETURNED/OVERDUE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (reader_id) REFERENCES reader(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='借阅记录表';

-- 种子数据：管理员（密码: admin123）
INSERT IGNORE INTO admin (username, password, real_name, role, status) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.R2fNLRJw0eNGKLzLOa', '系统管理员', 'SUPER_ADMIN', 1);

-- 种子数据：读者（密码: reader123）
INSERT IGNORE INTO reader (username, password, real_name, phone, email, status) VALUES
('reader1', '$2a$10$ZlALkpN5T5Z9Gv0ZtNLM0OGzQZRJXJGmM8KkQJyZJzE3mE3mE3mE', '张三', '13800001001', 'zhangsan@example.com', 1),
('reader2', '$2a$10$ZlALkpN5T5Z9Gv0ZtNLM0OGzQZRJXJGmM8KkQJyZJzE3mE3mE3mE', '李四', '13800001002', 'lisi@example.com', 1);

-- 种子数据：图书
INSERT IGNORE INTO book (isbn, title, author, publisher, category, stock, total, price, description, status) VALUES
('978-7-111-54742-6', 'Flutter实战', '赵洋', '机械工业出版社', '技术', 3, 5, 79.00, 'Flutter移动应用开发实战指南', 1),
('978-7-115-42823-4', 'Spring Boot实战', '王福成', '人民邮电出版社', '技术', 2, 3, 69.00, 'Spring Boot企业级应用开发指南', 1),
('978-7-121-33678-7', 'Dart语言基础', '陈天明', '电子工业出版社', '技术', 4, 5, 59.00, 'Dart编程入门经典', 1),
('978-7-115-52258-9', 'Go语言实战', '李文周', '人民邮电出版社', '技术', 3, 3, 65.00, 'Go语言高性能并发编程', 1);
