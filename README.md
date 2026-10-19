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
