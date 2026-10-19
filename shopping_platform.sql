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


-- =====================================================================
-- Section 3: Set Operations
-- =====================================================================

-- Task 7: Combine products from two different categories using UNION.
SELECT product_name, category, price
FROM Products
WHERE category = 'Electronics'
UNION
SELECT product_name, category, price
FROM Products
WHERE category = 'Sports'
ORDER BY category, price DESC;

-- Task 8: MySQL alternatives for INTERSECT and EXCEPT.
--         Set A = customers who ordered Electronics
--         Set B = customers who ordered Sports products

-- INTERSECT alternative (INNER JOIN): customers in both A and B.
SELECT a.customer_id,
       c.customer_name
FROM (SELECT DISTINCT o.customer_id
      FROM Orders o
      INNER JOIN Products p ON o.product_id = p.product_id
      WHERE p.category = 'Electronics') AS a
INNER JOIN (SELECT DISTINCT o.customer_id
            FROM Orders o
            INNER JOIN Products p ON o.product_id = p.product_id
            WHERE p.category = 'Sports') AS b
        ON a.customer_id = b.customer_id
INNER JOIN Customers c ON c.customer_id = a.customer_id
ORDER BY a.customer_id;

-- EXCEPT alternative (LEFT JOIN ... IS NULL): customers in A but not in B.
SELECT a.customer_id,
       c.customer_name
FROM (SELECT DISTINCT o.customer_id
      FROM Orders o
      INNER JOIN Products p ON o.product_id = p.product_id
      WHERE p.category = 'Electronics') AS a
LEFT JOIN (SELECT DISTINCT o.customer_id
           FROM Orders o
           INNER JOIN Products p ON o.product_id = p.product_id
           WHERE p.category = 'Sports') AS b
       ON a.customer_id = b.customer_id
INNER JOIN Customers c ON c.customer_id = a.customer_id
WHERE b.customer_id IS NULL
ORDER BY a.customer_id;


-- =====================================================================
-- Section 4: Window Functions
-- =====================================================================

-- Task 9: Rank products by price within each category.
SELECT category,
       product_name,
       price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank
FROM Products
ORDER BY category, price_rank;

-- Task 10: Previous product price (LAG) and running total of product prices.
SELECT product_id,
       product_name,
       price,
       LAG(price) OVER (ORDER BY product_id) AS previous_price,
       SUM(price) OVER (ORDER BY product_id
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Products
ORDER BY product_id;


-- =====================================================================
-- Section 5: Common Table Expressions (CTEs)
-- =====================================================================

-- Task 11: CTE showing customers whose total purchase amount is above the average.
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(o.quantity * p.price) AS total_purchase
    FROM Customers c
    INNER JOIN Orders o   ON c.customer_id = o.customer_id
    INNER JOIN Products p ON o.product_id  = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       total_purchase
FROM customer_totals
WHERE total_purchase > (SELECT AVG(total_purchase) FROM customer_totals)
ORDER BY total_purchase DESC;

-- Task 12: Recursive CTE generating the numbers 1 to 10.
WITH RECURSIVE numbers (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT n FROM numbers;


-- =====================================================================
-- Section 6: Views
-- =====================================================================

-- Task 13: View of products priced above 1000, then retrieve data from it.
CREATE OR REPLACE VIEW Premium_Products AS
SELECT product_id,
       product_name,
       category,
       price
FROM Products
WHERE price > 1000;

SELECT * FROM Premium_Products
ORDER BY price DESC;


-- =====================================================================
-- Section 7: Indexes and Query Performance
-- =====================================================================

-- Task 14: Create an index on the category column of Products.
CREATE INDEX idx_products_category ON Products (category);

SHOW INDEX FROM Products;

-- Task 15: Use EXPLAIN to analyze a query that filters products by category.
EXPLAIN
SELECT product_id, product_name, price
FROM Products
WHERE category = 'Electronics';

-- Same query with the index ignored, for comparison (type = ALL, full table scan).
EXPLAIN
SELECT product_id, product_name, price
FROM Products IGNORE INDEX (idx_products_category)
WHERE category = 'Electronics';


-- =====================================================================
-- Section 8: Stored Procedures and Functions
-- =====================================================================

-- Task 16: Stored procedure to retrieve products by category.
DROP PROCEDURE IF EXISTS GetProductsByCategory;

DELIMITER $$
CREATE PROCEDURE GetProductsByCategory (IN p_category VARCHAR(50))
BEGIN
    SELECT product_id,
           product_name,
           category,
           price
    FROM Products
    WHERE category = p_category
    ORDER BY price DESC;
END$$
DELIMITER ;

CALL GetProductsByCategory('Electronics');

-- Task 17: Function to calculate the total price of an order (price x quantity).
DROP FUNCTION IF EXISTS CalculateOrderTotal;

DELIMITER $$
CREATE FUNCTION CalculateOrderTotal (p_order_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT o.quantity * p.price
    INTO v_total
    FROM Orders o
    INNER JOIN Products p ON o.product_id = p.product_id
    WHERE o.order_id = p_order_id;

    RETURN v_total;
END$$
DELIMITER ;

SELECT o.order_id,
       p.product_name,
       p.price,
       o.quantity,
       CalculateOrderTotal(o.order_id) AS order_total
FROM Orders o
INNER JOIN Products p ON o.product_id = p.product_id
ORDER BY o.order_id;


-- =====================================================================
-- Section 9: Transactions
-- =====================================================================

-- Task 18: Update a product's price inside transactions using COMMIT and ROLLBACK.

-- Price before any change.
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- COMMIT: the new price is saved permanently.
START TRANSACTION;
UPDATE Products SET price = 849.00 WHERE product_id = 1;
COMMIT;

SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- ROLLBACK: the change is visible inside the transaction, then undone.
START TRANSACTION;
UPDATE Products SET price = 99.00 WHERE product_id = 1;
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;
ROLLBACK;

SELECT product_id, product_name, price FROM Products WHERE product_id = 1;


-- =====================================================================
-- Section 10: SQL Triggers
-- =====================================================================

-- Task 19: Record every new order in Order_Audit using an AFTER INSERT trigger.
CREATE TABLE Order_Audit (
    audit_id    INT         AUTO_INCREMENT PRIMARY KEY,
    order_id    INT         NOT NULL,
    customer_id INT         NOT NULL,
    product_id  INT         NOT NULL,
    quantity    INT         NOT NULL,
    order_date  DATE        NOT NULL,
    action      VARCHAR(20) NOT NULL,
    action_time DATETIME    DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_orders_after_insert;

DELIMITER $$
CREATE TRIGGER trg_orders_after_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit (order_id, customer_id, product_id, quantity, order_date, action)
    VALUES (NEW.order_id, NEW.customer_id, NEW.product_id, NEW.quantity, NEW.order_date, 'INSERT');
END$$
DELIMITER ;

-- Insert a new order; the trigger writes the audit row automatically.
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date)
VALUES (23, 11, 6, 1, '2025-06-01');

SELECT * FROM Order_Audit;
