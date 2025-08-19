CREATE DATABASE IF NOT EXISTS demo;
USE demo;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    birth_date DATE,
    role ENUM('admin', 'user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_role ON users(role);
CREATE INDEX idx_birth_date ON users(birth_date);
CREATE INDEX idx_created_at ON users(created_at);

INSERT INTO users (name, email, phone_number, username, password, birth_date, role) VALUES 
('Admin User', 'admin@example.com', '0123456789', 'admin', 'admin123', '1990-01-01', 'admin'),
('John Doe', 'john@example.com', '0987654321', 'johndoe', 'password123', '1995-05-15', 'user'),
('Jane Smith', 'jane@example.com', '0555555555', 'janesmith', 'password456', '1992-08-20', 'user'),
('Nguyễn Văn A', 'nguyenvana@gmail.com', '0901234567', 'nguyenvana', '123456', '1988-12-10', 'user'),
('Trần Thị B', 'tranthib@gmail.com', '0912345678', 'tranthib', '123456', '1993-03-25', 'user');

DESCRIBE users;

SELECT * FROM users; 