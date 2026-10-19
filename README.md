# Online Shopping Platform – Advanced SQL Assignment

**Author:** Ishant Bisen
**Database:** MySQL 8.0 (run in Docker)

## Assignment Overview

An online shopping platform stores customer, product and order data in a relational database and has
grown rapidly in both data volume and user activity. As part of a database modernization initiative,
this assignment implements advanced SQL solutions for business reporting, sales analysis, database
automation, transaction management and query optimization.

All statements are in a single script, [`shopping_platform.sql`](shopping_platform.sql), organised
section-wise with `-- Section N` and `-- Task N` comments:

| Section | Topic | Tasks |
|---|---|---|
| 1 | Advanced Joins | 1 – 3 |
| 2 | Subqueries | 4 – 6 |
| 3 | Set Operations | 7 – 8 |
| 4 | Window Functions | 9 – 10 |
| 5 | Common Table Expressions (CTEs) | 11 – 12 |
| 6 | Views | 13 |
| 7 | Indexes and Query Performance | 14 – 15 |
| 8 | Stored Procedures and Functions | 16 – 17 |
| 9 | Transactions | 18 |
| 10 | SQL Triggers | 19 |
| 11 | Performance Tuning | 20 |

## Repository Structure

```
.
├── shopping_platform.sql   # Tables, sample data and solutions for Tasks 1–20
├── docker-compose.yml      # Starts a MySQL 8.0 container on port 3307
├── screenshots/            # Execution screenshots
└── README.md
```

## Database Schema

```
Customers (1) ───< (many) Orders (many) >─── (1) Products
                            │
                            └── AFTER INSERT trigger ──> Order_Audit
```

### Customers

| Column | Data Type | Constraints |
|---|---|---|
| customer_id | INT | PRIMARY KEY |
| customer_name | VARCHAR(100) | NOT NULL |
| city | VARCHAR(50) | |
| email | VARCHAR(100) | NOT NULL, UNIQUE |

### Products

| Column | Data Type | Constraints |
|---|---|---|
| product_id | INT | PRIMARY KEY |
| product_name | VARCHAR(100) | NOT NULL |
| category | VARCHAR(50) | NOT NULL |
| price | DECIMAL(10,2) | NOT NULL |
| created_date | DATE | Used by the performance tuning query in Task 20 |

### Orders

| Column | Data Type | Constraints |
|---|---|---|
| order_id | INT | PRIMARY KEY |
| customer_id | INT | NOT NULL, FOREIGN KEY → Customers(customer_id) |
| product_id | INT | NOT NULL, FOREIGN KEY → Products(product_id) |
| quantity | INT | NOT NULL |
| order_date | DATE | NOT NULL |

### Order_Audit (Task 19)

| Column | Data Type | Constraints |
|---|---|---|
| audit_id | INT | AUTO_INCREMENT, PRIMARY KEY |
| order_id | INT | NOT NULL |
| customer_id | INT | NOT NULL |
| product_id | INT | NOT NULL |
| quantity | INT | NOT NULL |
| order_date | DATE | NOT NULL |
| action | VARCHAR(20) | NOT NULL |
| action_time | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### Sample Data

- **12 customers** from 12 Indian cities. Two of them (Rahul Verma, Kavya Kulkarni) have no orders,
  so they appear with `NULL` order columns in the LEFT JOIN (Task 3).
- **13 products** across 5 categories: Electronics, Clothing, Sports, Books, Home & Kitchen.
  Prices range from ₹399 to ₹4,999, with 8 products above ₹1,000 for the view in Task 13.
- **22 orders** placed between January and May 2025.

### Database Objects

| Object | Name | Task |
|---|---|---|
| View | `Premium_Products` | 13 |
| Index | `idx_products_category` | 14 (replaced in Task 20) |
| Index | `idx_products_category_created` | 20 |
| Stored Procedure | `GetProductsByCategory(category)` | 16 |
| Function | `CalculateOrderTotal(order_id)` | 17 |
| Trigger | `trg_orders_after_insert` | 19 |

## Steps to Execute the SQL Script

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running

### 1. Clone the repository

```bash
git clone https://github.com/ishantbisen-cmd/ishant-bisen-sql-advanced.git
cd ishant-bisen-sql-advanced
```

### 2. Start MySQL

```bash
docker compose up -d
```

The first start downloads the MySQL image and takes about a minute. Check that it is ready:

```bash
docker exec shopping-mysql mysqladmin ping -uroot -proot
# mysqld is alive
```

### 3. Run the full script

```bash
docker exec -i shopping-mysql mysql -uroot -proot --table < shopping_platform.sql
```

The script starts with `DROP DATABASE IF EXISTS shopping_platform;`, so it can be run any number of
times and always starts from a clean state.

### 4. Run individual queries (optional)

```bash
docker exec -it shopping-mysql mysql -uroot -proot shopping_platform
```

Then paste any query from the script, for example:

```sql
CALL GetProductsByCategory('Sports');
SELECT CalculateOrderTotal(11);
SELECT * FROM Premium_Products;
```

A GUI client (MySQL Workbench, DBeaver, etc.) can connect using:

| Host | Port | User | Password | Database |
|---|---|---|---|---|
| 127.0.0.1 | 3307 | root | root | shopping_platform |

### 5. Stop MySQL

```bash
docker compose down
```

## Summary of Implemented Advanced SQL Concepts

| Concept | Where | What it demonstrates |
|---|---|---|
| **INNER JOIN (3 tables)** | Task 1 | Combines Customers, Orders and Products to show who ordered what |
| **CROSS JOIN** | Task 2 | Cartesian product: every customer paired with every product (12 × 13 = 156 rows) |
| **LEFT JOIN** | Task 3 | Keeps customers with no orders, showing `NULL` for their order columns |
| **Scalar subquery** | Task 4 | Compares each price against `(SELECT AVG(price) FROM Products)` |
| **Nested subquery in HAVING** | Task 5 | Compares each customer's total with the average of all customer totals (a derived table) |
| **Correlated subquery** | Task 6 | Inner query re-runs per row, finding `MAX(price)` for that row's category |
| **UNION** | Task 7 | Merges Electronics and Sports products into one result, removing duplicates |
| **INTERSECT / EXCEPT alternatives** | Task 8 | `INNER JOIN` keeps customers in both sets; `LEFT JOIN ... WHERE b.customer_id IS NULL` keeps customers only in the first set |
| **RANK()** | Task 9 | Ranks products by price within each category using `PARTITION BY` |
| **LAG() and running total** | Task 10 | Previous row's price, and a cumulative `SUM() OVER (... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` |
| **CTE** | Task 11 | `WITH customer_totals AS (...)` computes totals once and reuses them for the average and the filter |
| **Recursive CTE** | Task 12 | Anchor `SELECT 1` plus recursive `n + 1` until `n = 10` |
| **View** | Task 13 | `Premium_Products` stores the "price above ₹1,000" query so it can be reused like a table |
| **Index** | Task 14 | B-tree index on `category` to avoid full table scans |
| **EXPLAIN** | Task 15 | With the index: `type = ref`, 4 rows examined. With the index ignored: `type = ALL`, 13 rows (full scan) |
| **Stored procedure** | Task 16 | `GetProductsByCategory` takes an `IN` parameter and returns the matching products |
| **Stored function** | Task 17 | `CalculateOrderTotal` returns `quantity × price` for an order and can be used inside `SELECT` |
| **Transactions** | Task 18 | `COMMIT` makes a price change permanent; `ROLLBACK` undoes a change that was visible inside the transaction |
| **Trigger** | Task 19 | `AFTER INSERT` trigger on Orders writes an audit row to `Order_Audit` automatically |
| **Performance tuning** | Task 20 | Removes `SELECT *` and `DISTINCT`, replaces `YEAR(created_date) = 2024` with a date range, and adds a composite index. EXPLAIN shows the optimized query uses both index columns (`type = range`, `key_len = 206`) instead of only `category` (`key_len = 202`) |

## Screenshots

### Advanced Join (Tasks 1 and 3)

![Advanced Join](screenshots/01_advanced_join.png)

### Subquery (Tasks 4 – 6)

![Subquery](screenshots/02_subquery.png)

### Window Function (Tasks 9 – 10)

![Window Function](screenshots/04_window_function.png)

### CTE (Tasks 11 – 12)

![CTE](screenshots/05_cte.png)

### View (Task 13)

![View](screenshots/06_view.png)

### EXPLAIN Query Output (Tasks 14 – 15)

![EXPLAIN](screenshots/07_explain.png)

### Stored Procedure and Function (Tasks 16 – 17)

![Stored Procedure and Function](screenshots/08_stored_procedure_function.png)

### Transaction – COMMIT / ROLLBACK (Task 18)

![Transaction](screenshots/09_transaction.png)

### Trigger Execution (Task 19)

![Trigger](screenshots/10_trigger.png)

### Additional Screenshots

| Section | Screenshot |
|---|---|
| Set Operations (Tasks 7 – 8) | [03_set_operations.png](screenshots/03_set_operations.png) |
| Performance Tuning (Task 20) | [11_performance_tuning.png](screenshots/11_performance_tuning.png) |
