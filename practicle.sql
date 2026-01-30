CREATE DATABASE telecom_db;
USE telecom_db;

SELECT DATABASE();
-- TASK 1: DATABASE DESIGN & NORMALIZATION--

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Plan (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    monthly_fee DECIMAL(10,2) NOT NULL CHECK (monthly_fee >= 0),
    data_limit_gb INT NOT NULL,
    call_minutes INT NOT NULL,
    sms_limit INT NOT NULL
);

CREATE TABLE SIM (
    sim_id INT AUTO_INCREMENT PRIMARY KEY,
    sim_number VARCHAR(20) UNIQUE NOT NULL,
    activation_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);


CREATE TABLE Subscription (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    plan_id INT NOT NULL,
    sim_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (plan_id) REFERENCES Plan(plan_id),
    FOREIGN KEY (sim_id) REFERENCES SIM(sim_id)
);


CREATE TABLE Device (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    device_name VARCHAR(100),
    device_type VARCHAR(50),
    manufacturer VARCHAR(50)
);


CREATE TABLE SIM_Device (
    sim_id INT,
    device_id INT,
    PRIMARY KEY (sim_id, device_id),
    FOREIGN KEY (sim_id) REFERENCES SIM(sim_id),
    FOREIGN KEY (device_id) REFERENCES Device(device_id)
);


CREATE TABLE Call_Record (
    call_id INT AUTO_INCREMENT PRIMARY KEY,
    sim_id INT NOT NULL,
    call_duration_sec INT NOT NULL CHECK (call_duration_sec >= 0),
    call_date DATETIME NOT NULL,
    FOREIGN KEY (sim_id) REFERENCES SIM(sim_id)
);


CREATE TABLE Data_Usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    sim_id INT NOT NULL,
    data_used_mb DECIMAL(10,2) NOT NULL,
    usage_date DATE NOT NULL,
    FOREIGN KEY (sim_id) REFERENCES SIM(sim_id)
);


CREATE TABLE Invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    invoice_month DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'UNPAID',
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
);


CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid >= 0),
    payment_method VARCHAR(30),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);


CREATE TABLE Region (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE Tower (
    tower_id INT AUTO_INCREMENT PRIMARY KEY,
    tower_code VARCHAR(20) UNIQUE NOT NULL
);


CREATE TABLE Tower_Region (
    tower_id INT,
    region_id INT,
    PRIMARY KEY (tower_id, region_id),
    FOREIGN KEY (tower_id) REFERENCES Tower(tower_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);


 -- TASK 2: SAMPLE DATA & VIEWS--
 
INSERT INTO Customer (full_name, email, phone_number, address) VALUES
('Rahul Sharma', 'rahul@gmail.com', '9000000001', 'Delhi'),
('Anita Verma', 'anita@gmail.com', '9000000002', 'Mumbai'),
('Amit Singh', 'amit@gmail.com', '9000000003', 'Pune'),
('Neha Kapoor', 'neha@gmail.com', '9000000004', 'Chandigarh'),
('Rohit Mehta', 'rohit@gmail.com', '9000000005', 'Jaipur'),
('Pooja Malhotra', 'pooja@gmail.com', '9000000006', 'Gurgaon'),
('Karan Patel', 'karan@gmail.com', '9000000007', 'Ahmedabad'),
('Sneha Iyer', 'sneha@gmail.com', '9000000008', 'Chennai'),
('Vikas Rao', 'vikas@gmail.com', '9000000009', 'Bangalore'),
('Mehul Jain', 'mehul@gmail.com', '9000000010', 'Indore'),
('Simran Kaur', 'simran@gmail.com', '9000000011', 'Amritsar'),
('Arjun Nair', 'arjun@gmail.com', '9000000012', 'Kochi'),
('Riya Das', 'riya@gmail.com', '9000000013', 'Kolkata'),
('Saurabh Mishra', 'saurabh@gmail.com', '9000000014', 'Lucknow'),
('Nitin Aggarwal', 'nitin@gmail.com', '9000000015', 'Noida');

INSERT INTO Plan (plan_name, monthly_fee, data_limit_gb, call_minutes, sms_limit) VALUES
('Basic 199', 199, 5, 300, 100),
('Standard 299', 299, 10, 500, 200),
('Smart 399', 399, 20, 1000, 300),
('Premium 599', 599, 50, 2000, 500),
('Ultra 799', 799, 100, 5000, 1000);


INSERT INTO SIM (sim_number, activation_date, status) VALUES
('SIM1001','2024-01-01','ACTIVE'),
('SIM1002','2024-01-02','ACTIVE'),
('SIM1003','2024-01-03','ACTIVE'),
('SIM1004','2024-01-04','ACTIVE'),
('SIM1005','2024-01-05','ACTIVE'),
('SIM1006','2024-01-06','ACTIVE'),
('SIM1007','2024-01-07','ACTIVE'),
('SIM1008','2024-01-08','ACTIVE'),
('SIM1009','2024-01-09','ACTIVE'),
('SIM1010','2024-01-10','ACTIVE'),
('SIM1011','2024-01-11','ACTIVE'),
('SIM1012','2024-01-12','ACTIVE'),
('SIM1013','2024-01-13','ACTIVE'),
('SIM1014','2024-01-14','ACTIVE'),
('SIM1015','2024-01-15','ACTIVE');


INSERT INTO Device (device_name, device_type, manufacturer) VALUES
('Galaxy S22','Smartphone','Samsung'),
('iPhone 13','Smartphone','Apple'),
('Redmi Note 12','Smartphone','Xiaomi'),
('OnePlus 11','Smartphone','OnePlus'),
('iPhone 14','Smartphone','Apple'),
('Galaxy A54','Smartphone','Samsung');

INSERT INTO Region (region_name) VALUES
('North'),('South'),('East'),('West'),('Central');

INSERT INTO Tower (tower_code) VALUES
('TWR-N-01'),('TWR-N-02'),('TWR-S-01'),
('TWR-E-01'),('TWR-W-01');


INSERT INTO Subscription (customer_id, plan_id, sim_id, start_date) VALUES
(1,4,1,'2024-01-01'),
(2,2,2,'2024-01-02'),
(3,3,3,'2024-01-03'),
(4,1,4,'2024-01-04'),
(5,5,5,'2024-01-05'),
(6,3,6,'2024-01-06'),
(7,2,7,'2024-01-07'),
(8,4,8,'2024-01-08'),
(9,1,9,'2024-01-09'),
(10,5,10,'2024-01-10'),
(11,2,11,'2024-01-11'),
(12,3,12,'2024-01-12'),
(13,4,13,'2024-01-13'),
(14,1,14,'2024-01-14'),
(15,5,15,'2024-01-15');

INSERT INTO Call_Record (sim_id, call_duration_sec, call_date) VALUES
(1,120,'2024-03-01 10:00'),
(2,300,'2024-03-01 11:00'),
(3,600,'2024-03-02 09:30'),
(4,200,'2024-03-02 12:15'),
(5,450,'2024-03-03 14:00'),
(6,180,'2024-03-03 16:30'),
(7,240,'2024-03-04 10:45'),
(8,360,'2024-03-04 18:00'),
(9,150,'2024-03-05 09:20'),
(10,500,'2024-03-05 21:10');

INSERT INTO Data_Usage (sim_id, data_used_mb, usage_date) VALUES
(1,1200,'2024-03-01'),
(2,3400,'2024-03-01'),
(3,5600,'2024-03-02'),
(4,800,'2024-03-02'),
(5,10200,'2024-03-03'),
(6,4500,'2024-03-03'),
(7,3000,'2024-03-04'),
(8,9800,'2024-03-04'),
(9,1500,'2024-03-05'),
(10,12000,'2024-03-05');


INSERT INTO Invoice (subscription_id, invoice_month, total_amount, status) VALUES
(1,'2024-03-01',599,'PAID'),
(2,'2024-03-01',299,'PAID'),
(3,'2024-03-01',399,'UNPAID'),
(4,'2024-03-01',199,'PAID'),
(5,'2024-03-01',799,'PAID'),
(6,'2024-03-01',399,'PAID'),
(7,'2024-03-01',299,'UNPAID'),
(8,'2024-03-01',599,'PAID'),
(9,'2024-03-01',199,'PAID'),
(10,'2024-03-01',799,'PAID'),
(11,'2024-03-01',299,'PAID'),
(12,'2024-03-01',399,'UNPAID'),
(13,'2024-03-01',599,'PAID'),
(14,'2024-03-01',199,'PAID'),
(15,'2024-03-01',799,'PAID');


INSERT INTO Payment (invoice_id, payment_date, amount_paid, payment_method) VALUES
(1,'2024-03-05',599,'UPI'),
(2,'2024-03-06',299,'CARD'),
(4,'2024-03-06',199,'CASH'),
(5,'2024-03-07',799,'UPI'),
(6,'2024-03-07',399,'CARD'),
(8,'2024-03-08',599,'UPI'),
(9,'2024-03-08',199,'UPI'),
(10,'2024-03-09',799,'CARD'),
(11,'2024-03-09',299,'UPI'),
(13,'2024-03-10',599,'UPI');








CREATE OR REPLACE VIEW vw_revenue_per_plan AS
SELECT
    p.plan_name,
    COUNT(i.invoice_id) AS total_invoices,
    SUM(i.total_amount) AS total_revenue
FROM invoice i
JOIN subscription s ON i.subscription_id = s.subscription_id
JOIN plan p ON s.plan_id = p.plan_id
GROUP BY p.plan_name;

SELECT * FROM vw_revenue_per_plan;


CREATE OR REPLACE VIEW vw_monthly_data_usage AS
SELECT
    sim_id,
    DATE_FORMAT(usage_date, '%Y-%m') AS usage_month,
    SUM(data_used_mb) AS total_data_mb
FROM data_usage
GROUP BY sim_id, DATE_FORMAT(usage_date, '%Y-%m');


SELECT * FROM vw_monthly_data_usage;





-- TASK 3: ADVANCED SQL ANALYTICS --

-- Query 1 – Multi-Table JOIN + GROUP BY

SELECT 
    c.full_name,
    SUM(i.total_amount) AS total_spent
FROM Customer c
JOIN Subscription s ON c.customer_id = s.customer_id
JOIN Invoice i ON s.subscription_id = i.subscription_id
GROUP BY c.full_name
ORDER BY total_spent DESC;


-- Query 2 – CASE + HAVING
SELECT
    d.sim_id,
    SUM(d.data_used_mb) AS total_data,
    CASE
        WHEN SUM(d.data_used_mb) >= 8000 THEN 'Heavy User'
        ELSE 'Normal User'
    END AS usage_type
FROM data_usage d
GROUP BY d.sim_id
HAVING total_data >= 3000;

-- Query 3 – Subquery
SELECT full_name
FROM Customer
WHERE customer_id IN (
    SELECT s.customer_id
    FROM Subscription s
    JOIN Invoice i ON s.subscription_id = i.subscription_id
    WHERE i.status = 'UNPAID'
);

-- Query 4 – Window Function
SELECT 
    c.full_name,
    SUM(i.total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(i.total_amount) DESC) AS spending_rank
FROM Customer c
JOIN Subscription s ON c.customer_id = s.customer_id
JOIN Invoice i ON s.subscription_id = i.subscription_id
GROUP BY c.full_name;

-- QUERY 5 - Correlated Subquery + Business Insight
SELECT
    p.plan_name,
    SUM(i.total_amount) AS total_revenue
FROM plan p
JOIN subscription s ON p.plan_id = s.plan_id
JOIN invoice i ON s.subscription_id = i.subscription_id
GROUP BY p.plan_id
HAVING total_revenue >
(
    SELECT AVG(plan_revenue)
    FROM (
        SELECT SUM(i2.total_amount) AS plan_revenue
        FROM subscription s2
        JOIN invoice i2 ON s2.subscription_id = i2.subscription_id
        GROUP BY s2.plan_id
    ) avg_table
);




-- Stored Procedure and Functions
DELIMITER //

CREATE PROCEDURE Generate_Invoice (
    IN sub_id INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    INSERT INTO Invoice (subscription_id, invoice_month, total_amount)
    VALUES (sub_id, CURDATE(), amount);
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION Calculate_Overage(data_used INT, data_limit INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    IF data_used > data_limit THEN
        RETURN (data_used - data_limit) * 0.05;
    ELSE
        RETURN 0;
    END IF;
END //

DELIMITER ;











