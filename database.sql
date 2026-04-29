-- Penguin Auto Specialists Service System
-- MySQL databsae creation script for PA3

CREATE DATABASE IF NOT EXISTS penguin_auto;
USE penguin_auto;

DROP TABLE IF EXISTS repair_parts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS repairs;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS parts;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    street_address VARCHAR(100),
    city VARCHAR(50),
    zip_code VARCHAR(10),
    email_address VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password_hash VARCHAR(255),
    two_factor_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    street_address VARCHAR(100),
    city VARCHAR(50),
    zip_code VARCHAR(10),
    email_address VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hourly_wages DECIMAL(10,2),
    position VARCHAR(50),
    hiring_date DATE,
    assigned_tasks VARCHAR(255),
    role VARCHAR(30) DEFAULT 'technician'
);

CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    color VARCHAR(30),
    license_plate_number VARCHAR(20),
    vin_number VARCHAR(50) UNIQUE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    hourly_cost DECIMAL(10,2) NOT NULL,
    estimated_hours DECIMAL(4,2) DEFAULT 1.00,
    schedule_date DATE,
    schedule_time TIME,
    technician_id INT,
    FOREIGN KEY (technician_id) REFERENCES employees(employee_id)
);

CREATE TABLE parts (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    vendor VARCHAR(100),
    cost DECIMAL(10,2),
    quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 2
);

CREATE TABLE repairs (
    repair_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    service_id INT NOT NULL,
    technician_id INT,
    repair_date DATE,
    repair_time TIME,
    planned VARCHAR(50) DEFAULT 'Scheduled',
    completed VARCHAR(50) DEFAULT 'No',
    repair_status ENUM('Requested','Scheduled','In Progress','Waiting on Parts','Completed','Invoiced','Paid') DEFAULT 'Requested',
    parts_used VARCHAR(255),
    customer_notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (technician_id) REFERENCES employees(employee_id)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    repair_id INT,
    transaction_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    routing_number VARCHAR(50),
    customer_name VARCHAR(100),
    payment_status ENUM('Pending','Authorized','Paid','Refunded') DEFAULT 'Pending',
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (repair_id) REFERENCES repairs(repair_id)
);

CREATE TABLE repair_parts (
    repair_part_id INT AUTO_INCREMENT PRIMARY KEY,
    repair_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity_used INT NOT NULL,
    FOREIGN KEY (repair_id) REFERENCES repairs(repair_id),
    FOREIGN KEY (part_id) REFERENCES parts(part_id)
);

-- Demo names to be used to populate categories
INSERT INTO customers (first_name, last_name, street_address, city, zip_code, email_address, phone_number, password_hash) VALUES
('Demo', 'Customer', '100 Main Street', 'Daytona Beach', '32114', 'customer@penguinauto.com', '386-555-0100', 'demo_hash');

INSERT INTO employees (first_name, last_name, city, email_address, phone_number, hourly_wages, position, hiring_date, assigned_tasks, role) VALUES
('Jack', 'Reacher', 'Daytona Beach', 'employee@penguinauto.com', '386-555-0200', 45.00, 'Employee', '2022-01-01', 'Approve repairs and invoices', 'Employee'),
('Jane', 'Doe', 'Daytona Beach', 'tech1@penguinauto.com', '386-555-0201', 32.00, 'Technician', '2024-03-11', 'Diagnostics and brake repair', 'technician'),
('Hugh', 'Mann', 'Daytona Beach', 'tech2@penguinauto.com', '386-555-0202', 30.00, 'Technician', '2024-05-20', 'Oil changes and tire service', 'technician');

INSERT INTO vehicles (customer_id, make, model, year, color, license_plate_number, vin_number) VALUES
(1, 'Toyota', 'Camry', 2018, 'Silver', 'ABC1234', '1HGCM82633A004352');

INSERT INTO services (service_name, hourly_cost, estimated_hours, schedule_date, schedule_time, technician_id) VALUES
('Oil Change', 65.00, 1.00, '2026-04-30', '09:00:00', 3),
('Brake Repair', 110.00, 2.50, '2026-04-30', '11:00:00', 2),
('Diagnostic Inspection', 95.00, 1.25, '2026-04-30', '14:00:00', 2),
('Tire Replacement', 90.00, 2.00, '2026-05-01', '10:00:00', 3);

INSERT INTO parts (part_name, vendor, cost, quantity, reorder_level) VALUES
('Oil Filter', 'Daytona Parts Supply', 12.99, 20, 5),
('Brake Pads', 'Coastal Auto Parts', 48.50, 8, 3),
('Air Filter', 'Daytona Parts Supply', 18.75, 15, 5),
('Tire Set', 'RoadWay Tire Vendor', 320.00, 4, 2);
