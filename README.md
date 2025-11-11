# 🗃️ Client Data Handling – SQL Project

## 🎯 Objective
- Understand and demonstrate the process of handling client data using **MySQL**
- Cover the full cycle from **data review** and **transformation** to **analytics and reporting**

---

## ⚙️ Prerequisite
- Install **MySQL Workbench / MySQL Server**
- Import the provided **CSV file** into a new database
- Create a table named **`customers`** to store the data

---

## 📂 Dataset Overview
The provided CSV file contains customer data with the following columns:

- **Customer ID** – Unique ID for each customer  
- **Full Name** – Customer’s full name  
- **Email** – Customer’s email address  
- **Phone** – Customer’s contact number  
- **City** – Customer’s city  
- **Signup Date** – Date when the customer signed up  

---

## 🧩 Assignment Tasks

### 1️⃣ SQL & Data Familiarity

#### Q1. Data Review (Before Importing)
**Steps to review the data before importing:**
- Check for missing values, duplicates, and data type consistency  
- Validate date formats and column headers  
- Clean or standardize data using spreadsheet tools before importing into MySQL  

#### SQL Queries to Execute:
- Display all customers from the city **'Delhi'**
- Count the number of signups in the last **30 days** *(Assume today = 16th April 2025)*
- List **unique cities** where customers are based
- List **top 3 cities** by number of signups
- Find customers who have **never placed an order**, assuming another table `orders(customer_id, order_id, amount)`

📸 *Attach screenshots of query outputs for each.*

---

### 2️⃣ Data Transformation & Enrichment

Perform data enhancement operations on the `customers` table:

- **Add Column:**  
  - `is_gmail` → Mark **‘Yes’** if email domain = *gmail.com*, else **‘No’**
- **Extract:**  
  - `first_name` from `Full Name`
- **Add Column:**  
  - `signup_month` → Month name of signup date
- **Report:**  
  - Number of **Gmail customers** signed up on each **day of the week**
- **Create Table:**  
  - `vip_customers` → Customers from **Delhi, Mumbai, Bangalore** signed up in the last **60 days** from *16th April 2025*

---

### 3️⃣ Analytics & Reporting

Generate business insights using SQL queries:

- **Monthly signup count** for past 6 months → Identify growth trend  
- **Cities with more than 20 customers** → Spot high-density regions  
- **Date with highest number of signups** → Detect peak activity  
- **Add column for day of signup** and find **day with most signups** → Understand customer behavior  

---

## 🧠 Learning Outcome
- Understanding of **data review and cleaning** before import  
- Hands-on experience in **MySQL query writing**  
- Performing **data transformation and enrichment**  
- Generating **insightful business reports** from raw data  

---

## 📜 License
This project is licensed under the **MIT License** – you are free to use, modify, and distribute with attribution.
