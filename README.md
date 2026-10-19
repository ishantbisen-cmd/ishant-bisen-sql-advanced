# Online Bookstore – SQL Fundamentals Assignment

## Assignment Overview

As a Database Developer for an online bookstore, the goal of this assignment is to design a small
relational database for books and their authors, populate it with sample data, and write SQL queries
that the business team can use to retrieve, analyze and manage the data.

The assignment covers:

| Section | Topic | Tasks |
|---|---|---|
| 1 | Basic Queries (`SELECT`, column aliases, `DISTINCT`) | 1 – 4 |
| 2 | Filtering Data (`WHERE`, `BETWEEN`, `LIKE`) | 5 – 9 |
| 3 | Sorting and Limiting Results (`ORDER BY`, `LIMIT`) | 10 – 11 |
| 4 | Aggregate Functions (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) | 12 |
| 5 | `GROUP BY` and `HAVING` | 13 – 14 |
| 6 | Joins (`INNER`, `LEFT`, `RIGHT`) | 15 – 17 |
| 7 | Data Manipulation (`INSERT`, `UPDATE`, `DELETE`) | 18 – 20 |
| 8 | Creating Tables and Constraints | 21 |

All statements are in a single script, [`bookstore.sql`](bookstore.sql), organised in task order with
`-- Task N` comments.

**Database:** MySQL 8.0 (run in Docker)

## Repository Structure

```
.
├── bookstore.sql        # CREATE TABLE, sample INSERTs and queries for Tasks 1–21
├── docker-compose.yml   # Starts a MySQL 8.0 container with the script mounted
├── screenshots/         # Execution screenshots
└── README.md
```

## Database Schema

```
Authors (1) ────────< (many) Books
```

### Authors

| Column | Data Type | Constraints |
|---|---|---|
| author_id | INT | PRIMARY KEY |
| author_name | VARCHAR(100) | NOT NULL |
| country | VARCHAR(50) | |

### Books

| Column | Data Type | Constraints |
|---|---|---|
| book_id | INT | PRIMARY KEY |
| title | VARCHAR(100) | NOT NULL |
| author_id | INT | FOREIGN KEY → Authors(author_id) |
| category | VARCHAR(50) | |
| price | DECIMAL(10,2) | |
| published_year | INT | |

### Publishers (Task 21)

| Column | Data Type | Constraints |
|---|---|---|
| publisher_id | INT | PRIMARY KEY |
| publisher_name | VARCHAR(100) | NOT NULL, UNIQUE |
| country | VARCHAR(50) | NOT NULL, DEFAULT 'India' |
| established_year | INT | |

### Sample Data

- **6 authors** from 6 countries: USA, India, Israel, United Kingdom, Japan, Brazil.
  Paulo Coelho (Brazil) intentionally has no books, so he appears with `NULL` in the LEFT JOIN (Task 16).
- **12 books** across 4 categories: Programming, History, Fiction, Fantasy.

## Steps to Execute the SQL Script

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running

### 1. Clone the repository

```bash
git clone https://github.com/ishantbisen-cmd/bookstore-sql-assignment.git
cd bookstore-sql-assignment
```

### 2. Start MySQL

```bash
docker compose up -d
```

The first start downloads the MySQL image and takes about a minute. Check that it is ready:

```bash
docker exec bookstore-mysql mysqladmin ping -uroot -proot
# mysqld is alive
```

### 3. Run the full script

```bash
docker exec -i bookstore-mysql mysql -uroot -proot --table < bookstore.sql
```

This creates the `bookstore` database, the tables and sample data, and prints the result of every task.

> The script starts with `CREATE DATABASE bookstore;`, so it expects a fresh server. To run it again,
> drop the database first:
>
> ```bash
> docker exec bookstore-mysql mysql -uroot -proot -e "DROP DATABASE IF EXISTS bookstore;"
> ```

### 4. Run individual queries (optional)

Open an interactive MySQL shell connected to the database:

```bash
docker exec -it bookstore-mysql mysql -uroot -proot bookstore
```

Then paste any query from `bookstore.sql`, for example `SELECT * FROM Books;`. Type `exit` to leave.

A GUI client (MySQL Workbench, DBeaver, etc.) can also connect using:

| Host | Port | User | Password | Database |
|---|---|---|---|---|
| 127.0.0.1 | 3306 | root | root | bookstore |

> Table names are case-sensitive in MySQL on Linux (Docker): use `Books`, not `books`.

### 5. Stop MySQL

```bash
docker compose down
```

## Screenshots

### Aggregate Functions (Task 12)

![Task 12 – Aggregate Functions](screenshots/task12_aggregate_functions.png)

### INNER JOIN (Task 15)

![Task 15 – INNER JOIN](screenshots/task15_inner_join.png)

### CREATE TABLE with Constraints (Task 21)

![Task 21 – CREATE TABLE](screenshots/task21_create_table.png)

### Additional Screenshots

| Task | Screenshot |
|---|---|
| Task 1 – Sample data in Authors and Books | [task01_all_books_and_sample_data.png](screenshots/task01_all_books_and_sample_data.png) |
| Tasks 3 & 4 – Column aliases and DISTINCT | [task03_04_aliases_and_distinct.png](screenshots/task03_04_aliases_and_distinct.png) |
| Tasks 10 & 11 – ORDER BY and LIMIT | [task10_11_sorting_and_limit.png](screenshots/task10_11_sorting_and_limit.png) |
| Task 13 – GROUP BY | [task13_group_by.png](screenshots/task13_group_by.png) |
| Task 14 – HAVING | [task14_having.png](screenshots/task14_having.png) |
