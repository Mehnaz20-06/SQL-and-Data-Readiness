
CREATE DATABASE IF NOT EXISTS xeno_assignment;
USE xeno_assignment;

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT PRIMARY KEY,
  full_name VARCHAR(200),
  email VARCHAR(255),
  phone VARCHAR(50),
  city VARCHAR(100),
  signup_date DATE
);

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT @@sql_mode;


LOAD DATA LOCAL INFILE 'C:\Users\shafe\OneDrive\Desktop\Xeno\TAM_INTERN_TABLE - TAM_INTERN_TABLE.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(customer_id, full_name, email, phone, city, @signup_date)
SET signup_date = STR_TO_DATE(TRIM(@signup_date), '%d/%m/%Y');

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(customer_id, full_name, email, phone, city, @signup_date)
SET signup_date = STR_TO_DATE(TRIM(@signup_date), '%d/%m/%Y');


SELECT COUNT(*) FROM customers;
SELECT * FROM customers LIMIT 5;
SELECT * FROM customers WHERE signup_date IS NULL;

SELECT * FROM customers ORDER BY signup_date DESC LIMIT 10;

-- Count signups from 2025-03-17 through 2025-04-16 (inclusive)
SELECT COUNT(*) AS signups_last_30_days
FROM customers
WHERE signup_date BETWEEN DATE_SUB('2025-04-16', INTERVAL 30 DAY) AND '2025-04-16';

SELECT DISTINCT TRIM(city) AS city
FROM customers
WHERE city IS NOT NULL AND TRIM(city) <> ''
ORDER BY city;

SELECT TRIM(city) AS city, COUNT(*) AS signup_count
FROM customers
WHERE city IS NOT NULL AND TRIM(city) <> ''
GROUP BY TRIM(city)
ORDER BY signup_count DESC
LIMIT 3;

SELECT VERSION() AS mysql_version;
SHOW COLUMNS FROM customers;

SELECT 
  SUM(CASE WHEN COLUMN_NAME = 'is_gmail' THEN 1 ELSE 0 END) AS has_is_gmail,
  SUM(CASE WHEN COLUMN_NAME = 'first_name' THEN 1 ELSE 0 END) AS has_first_name,
  SUM(CASE WHEN COLUMN_NAME = 'signup_month' THEN 1 ELSE 0 END) AS has_signup_month
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'xeno_assignment' AND TABLE_NAME = 'customers';

ALTER TABLE customers ADD COLUMN is_gmail ENUM('Yes','No') DEFAULT 'No';
ALTER TABLE customers ADD COLUMN first_name VARCHAR(100);
ALTER TABLE customers ADD COLUMN signup_month VARCHAR(20);
SHOW COLUMNS FROM customers;

UPDATE customers
SET is_gmail = CASE
  WHEN LOWER(TRIM(SUBSTRING_INDEX(COALESCE(email,''), '@', -1))) = 'gmail.com' THEN 'Yes'
  ELSE 'No'
END;
-- Extract first name
UPDATE customers
SET first_name = NULLIF(TRIM(SUBSTRING_INDEX(TRIM(COALESCE(full_name,'')), ' ', 1)), '');
SELECT 
  customer_id, 
  full_name, 
  first_name, 
  email, 
  is_gmail
FROM customers
ORDER BY signup_date DESC
LIMIT 15;

-- Signup month
UPDATE customers
SET signup_month = CASE
  WHEN signup_date IS NULL THEN NULL
  ELSE MONTHNAME(signup_date)
END;
SELECT 
  customer_id, 
  full_name, 
  signup_date, 
  signup_month
FROM customers
ORDER BY signup_date DESC
LIMIT 15;

SELECT 
  DAYNAME(signup_date) AS weekday,
  COUNT(*) AS gmail_signups
FROM customers
WHERE is_gmail = 'Yes' AND signup_date IS NOT NULL
GROUP BY weekday
ORDER BY FIELD(weekday,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
DROP TABLE IF EXISTS vip_customers;

CREATE TABLE vip_customers AS
SELECT *
FROM customers
WHERE TRIM(LOWER(city)) IN ('delhi','mumbai','bangalore','bengaluru')
  AND signup_date BETWEEN DATE_SUB('2025-04-16', INTERVAL 60 DAY) AND '2025-04-16';

SELECT * FROM vip_customers ORDER BY signup_date DESC;


SELECT TRIM(city) AS city, COUNT(*) AS customers_count
FROM customers
WHERE city IS NOT NULL AND TRIM(city) <> ''
GROUP BY TRIM(city)
HAVING customers_count > 20
ORDER BY customers_count DESC;

SELECT signup_date, COUNT(*) AS signups
FROM customers
WHERE signup_date IS NOT NULL
GROUP BY signup_date
ORDER BY signups DESC, signup_date DESC
LIMIT 1;

ALTER TABLE customers
  ADD COLUMN signup_day VARCHAR(20);

UPDATE customers
SET signup_day = CASE WHEN signup_date IS NULL THEN NULL ELSE DAYNAME(signup_date) END;

SELECT signup_day, COUNT(*) AS signups
FROM customers
WHERE signup_day IS NOT NULL
GROUP BY signup_day
ORDER BY COUNT(*) DESC
LIMIT 1;




SELECT DATE_FORMAT(signup_date, '%Y-%m') AS month_label,
       COUNT(*) AS signups
FROM customers
WHERE signup_date BETWEEN DATE_SUB('2025-04-16', INTERVAL 6 MONTH) AND '2025-04-16'
GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
ORDER BY 1;

USE xeno_assignment;

SELECT m.month_label, m.signups
FROM (
  SELECT DATE_FORMAT(signup_date, '%Y-%m') AS month_label,
         COUNT(*) AS signups
  FROM customers
  WHERE signup_date BETWEEN DATE_SUB('2025-04-16', INTERVAL 6 MONTH) AND '2025-04-16'
  GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
) AS m
ORDER BY m.month_label;
