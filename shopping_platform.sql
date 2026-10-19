-- =====================================================================
-- Online Shopping Platform - Advanced SQL Assignment
-- Author   : Ishant Bisen
-- Database : MySQL 8.0
-- =====================================================================

-- ---------------------------------------------------------------------
-- Database Setup
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS shopping_platform;
CREATE DATABASE shopping_platform;
USE shopping_platform;

-- ---------------------------------------------------------------------
-- Table: Customers
-- ---------------------------------------------------------------------
CREATE TABLE Customers (
    customer_id   INT          PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    email         VARCHAR(100) NOT NULL UNIQUE
);

-- ---------------------------------------------------------------------
-- Table: Products
-- created_date is used by the performance tuning query in Task 20.
-- ---------------------------------------------------------------------
CREATE TABLE Products (
    product_id   INT           PRIMARY KEY,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    created_date DATE
);

-- ---------------------------------------------------------------------
-- Table: Orders
-- ---------------------------------------------------------------------
CREATE TABLE Orders (
    order_id    INT  PRIMARY KEY,
    customer_id INT  NOT NULL,
    product_id  INT  NOT NULL,
    quantity    INT  NOT NULL,
    order_date  DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES Products(product_id)
);

-- ---------------------------------------------------------------------
-- Sample Data: Customers (12 customers)
-- Rahul Verma and Kavya Kulkarni have no orders (used in Task 3).
-- ---------------------------------------------------------------------
INSERT INTO Customers (customer_id, customer_name, city, email) VALUES
(1,  'Aarav Sharma',   'Mumbai',    'aarav.sharma@example.com'),
(2,  'Priya Patel',    'Ahmedabad', 'priya.patel@example.com'),
(3,  'Rohan Gupta',    'Delhi',     'rohan.gupta@example.com'),
(4,  'Sneha Reddy',    'Hyderabad', 'sneha.reddy@example.com'),
(5,  'Vikram Singh',   'Jaipur',    'vikram.singh@example.com'),
(6,  'Ananya Iyer',    'Chennai',   'ananya.iyer@example.com'),
(7,  'Karan Mehta',    'Pune',      'karan.mehta@example.com'),
(8,  'Isha Nair',      'Kochi',     'isha.nair@example.com'),
(9,  'Arjun Das',      'Kolkata',   'arjun.das@example.com'),
(10, 'Meera Joshi',    'Bengaluru', 'meera.joshi@example.com'),
(11, 'Rahul Verma',    'Lucknow',   'rahul.verma@example.com'),
(12, 'Kavya Kulkarni', 'Nagpur',    'kavya.kulkarni@example.com');

-- ---------------------------------------------------------------------
-- Sample Data: Products (13 products across 5 categories)
-- ---------------------------------------------------------------------
INSERT INTO Products (product_id, product_name, category, price, created_date) VALUES
(1,  'Wireless Mouse',           'Electronics',    799.00,  '2023-11-15'),
(2,  'Bluetooth Headphones',     'Electronics',    2499.00, '2024-02-10'),
(3,  'Smartwatch',               'Electronics',    4999.00, '2024-06-05'),
(4,  'USB-C Charger',            'Electronics',    1199.00, '2024-09-20'),
(5,  'Cotton T-Shirt',           'Clothing',       499.00,  '2023-08-01'),
(6,  'Denim Jeans',              'Clothing',       1599.00, '2024-03-12'),
(7,  'Running Shoes',            'Sports',         2999.00, '2024-01-25'),
(8,  'Yoga Mat',                 'Sports',         899.00,  '2023-12-05'),
(9,  'Cricket Bat',              'Sports',         1899.00, '2024-07-18'),
(10, 'The Pragmatic Programmer', 'Books',          649.00,  '2023-05-10'),
(11, 'Atomic Habits',            'Books',          399.00,  '2024-04-22'),
(12, 'Non-Stick Frying Pan',     'Home & Kitchen', 1299.00, '2024-10-30'),
(13, 'Electric Kettle',          'Home & Kitchen', 1099.00, '2023-10-08');

-- ---------------------------------------------------------------------
-- Sample Data: Orders (22 orders)
-- ---------------------------------------------------------------------
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date) VALUES
(1,  1,  1,  2, '2025-01-05'),
(2,  1,  3,  1, '2025-01-12'),
(3,  2,  5,  3, '2025-01-15'),
(4,  2,  11, 2, '2025-01-20'),
(5,  3,  2,  1, '2025-02-02'),
(6,  3,  7,  1, '2025-02-10'),
(7,  4,  12, 1, '2025-02-14'),
(8,  4,  10, 2, '2025-02-18'),
(9,  5,  9,  1, '2025-03-01'),
(10, 5,  8,  2, '2025-03-05'),
(11, 6,  3,  2, '2025-03-11'),
(12, 6,  13, 1, '2025-03-15'),
(13, 7,  6,  2, '2025-03-22'),
(14, 7,  4,  1, '2025-04-02'),
(15, 8,  11, 4, '2025-04-08'),
(16, 8,  5,  2, '2025-04-12'),
(17, 9,  2,  2, '2025-04-20'),
(18, 9,  1,  1, '2025-04-25'),
(19, 10, 7,  1, '2025-05-03'),
(20, 10, 4,  1, '2025-05-09'),
(21, 1,  12, 1, '2025-05-15'),
(22, 3,  9,  1, '2025-05-21');


-- =====================================================================
-- Section 1: Advanced Joins
-- =====================================================================

-- Task 1: Display each customer along with the products they ordered.
SELECT c.customer_id,
       c.customer_name,
       p.product_name,
       o.quantity,
       o.order_date
FROM Customers c
INNER JOIN Orders o   ON c.customer_id = o.customer_id
INNER JOIN Products p ON o.product_id  = p.product_id
ORDER BY c.customer_id, o.order_date;

-- Task 2: Display all possible combinations of customers and products (CROSS JOIN).
--         12 customers x 13 products = 156 rows.
SELECT c.customer_name,
       p.product_name
FROM Customers c
CROSS JOIN Products p
ORDER BY c.customer_id, p.product_id;

-- Task 3: Display all customers and their orders, including customers with no orders.
SELECT c.customer_id,
       c.customer_name,
       o.order_id,
       o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_id;


-- =====================================================================
-- Section 2: Subqueries
-- =====================================================================

-- Task 4: Find products priced above the average product price.
SELECT product_id,
       product_name,
       category,
       price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;

-- Task 5: Customers whose total purchase amount is greater than the
--         average customer purchase amount.
SELECT c.customer_id,
       c.customer_name,
       SUM(o.quantity * p.price) AS total_purchase
FROM Customers c
INNER JOIN Orders o   ON c.customer_id = o.customer_id
INNER JOIN Products p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.quantity * p.price) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(o2.quantity * p2.price) AS customer_total
        FROM Orders o2
        INNER JOIN Products p2 ON o2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) AS customer_totals
)
ORDER BY total_purchase DESC;

-- Task 6: Highest-priced product in each category (correlated subquery).
SELECT p1.category,
       p1.product_name,
       p1.price
FROM Products p1
WHERE p1.price = (
    SELECT MAX(p2.price)
    FROM Products p2
    WHERE p2.category = p1.category
)
ORDER BY p1.category;
