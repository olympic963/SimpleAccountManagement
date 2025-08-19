-- Database Update Script for ManageAccount
-- This script adds username and password columns to the existing users table

-- Connect to your database first
USE demo;

-- Add new columns to the users table
ALTER TABLE users 
ADD COLUMN username VARCHAR(50) NOT NULL UNIQUE AFTER phone_number,
ADD COLUMN password VARCHAR(255) NOT NULL AFTER username;

-- Add indexes for better performance
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_email ON users(email);

-- Update existing records with default values (if any)
-- Note: You should update these with actual values for existing users
UPDATE users SET username = CONCAT('user_', id), password = 'default_password' WHERE username IS NULL OR username = '';

-- Make username and email unique
ALTER TABLE users 
ADD UNIQUE KEY unique_username (username),
ADD UNIQUE KEY unique_email (email);

-- Verify the table structure
DESCRIBE users;

-- Sample data for testing (optional)
-- INSERT INTO users (name, email, phone_number, username, password) VALUES 
-- ('John Doe', 'john@example.com', '1234567890', 'johndoe', 'password123'),
-- ('Jane Smith', 'jane@example.com', '0987654321', 'janesmith', 'password456'),
-- ('Admin User', 'admin@example.com', '5555555555', 'admin', 'admin123'); 