/*
1.  Hired
Write a query to display employee ID, first name, last name, and hire date for employees who have been hired after the last employee hired in April 2016 but two months before the first employee hired in August 2016.
Sort the result by hire date and employee ID.
The query returns 6 rows.
See the output columns:

EMPLOYEE_ID    FIRST_NAME    LAST_NAME   HIRE_DATE
-- -----------    ----------    ---------   ---------- 
*/
-- Q1 solution
COLUMN first_name FORMAT A15;
COLUMN last_name FORMAT A15;
SELECT employee_id, first_name, last_name, hire_date
FROM employees
WHERE hire_date > (SELECT MAX(hire_date) 
                    FROM employees
                    WHERE hire_date < TO_CHAR(TO_DATE('01-MAY-2016', 'DD-MON-YYYY')))
AND hire_date < (SELECT add_months(MIN(hire_date), -2)
                 FROM employees
                 WHERE hire_date < TO_CHAR(TO_DATE('01-SEP-2016', 'DD-MON-YYYY'))
                 AND hire_date > TO_CHAR(TO_DATE('31-JUL-2016', 'DD-MON-YYYY')))
ORDER BY hire_date, employee_id;

/*
2.  Direct Reports
Display manager ID for managers with more than one direct employee. Answer this question without using the COUNT()function.
Sort the result by manager ID.
The query returns 15 rows. See the output columns:

Manager ID
----------
*/
-- Q2 solution
SELECT DISTINCT manager_id AS "Manager ID"
FROM employees p
WHERE employee_id <> ANY (SELECT employee_id
                          FROM employees
                          WHERE manager_id = p.manager_id)
ORDER BY "Manager ID";

/*
3.  Rest
Use your query in Q2 and SET Operator(s) to display manager ID for managers who have only one direct employee. You are still not allowed to use COUNT().
Sort the result by manager ID. 
The query returns 3 rows. See the output columns:

Manager ID
----------
*/ 
-- Q3 solution
SELECT manager_id AS "Manager ID"
FROM employees p
WHERE employee_id = ANY (SELECT employee_id
                          FROM employees
                          WHERE manager_id = p.manager_id) 
MINUS

SELECT manager_id 
FROM employees p
WHERE employee_id <> ANY (SELECT employee_id
                          FROM employees
                          WHERE manager_id = p.manager_id)
ORDER BY "Manager ID";

/*
4.  Frequent Ordered Products
Write a SQL query to display products that have been ordered multiple times (in different orders) on the same day in 2015.
Display product ID, order date, and the number of times the product has been ordered on that day.
Sort the result by order date and product ID.
The query returns 2 rows. See the following output columns:
Product ID   Order Date     Number of orders
----------   ----------     ----------------
*/
-- Q4 solution
SELECT product_id, order_date, COUNT(DISTINCT oi.order_id) AS "number of orders"
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE order_date > TO_CHAR(TO_DATE('01-01-2015', 'DD-MM-YYYY')) 
                   AND order_date < TO_CHAR(TO_DATE('01-01-2016', 'DD-MM-YYYY')) 
GROUP BY product_id, order_date
HAVING COUNT( DISTINCT oi.order_id) > 1  
ORDER BY product_id;

/*
5.  Purchased
Write a query to display customer ID and customer name for customers who have purchased all these three products: Products with ID 31, 205, 275.
Sort the result by customer ID.
The query returns 1 row. See the following output columns:
CUSTOMER ID     NAME                                      
-----------     ----
*/
-- Q5 solution
SELECT O.customer_id, C.NAME
FROM order_items oi
LEFT JOIN orders O
ON oi.order_id = O.order_id
LEFT JOIN customers C
ON C.customer_id = O.customer_id
WHERE oi.product_id = (31)
INTERSECT 
SELECT O.customer_id, C.NAME
FROM order_items oi
LEFT JOIN orders O
ON oi.order_id = O.order_id
LEFT JOIN customers C
ON C.customer_id = O.customer_id
WHERE oi.product_id = (205)
INTERSECT
SELECT O.customer_id, C.NAME
FROM order_items oi
LEFT JOIN orders O
ON oi.order_id = O.order_id
LEFT JOIN customers C
ON C.customer_id = O.customer_id
WHERE oi.product_id = (275);

/*
6.  Salesman
Write a query to display employee ID and the number of orders for employee(s) with the maximum number of orders (sales). Hint: A salesman is an employee.
Sort the result by employee ID. 
The query returns 1 row. See the following output:
Employee ID     Number of Orders
-----------     ----------------
*/
-- Q6 solution
SELECT e.employee_id AS "Employee ID", COUNT(o.order_id) AS "Number of Orders"
FROM employees e
    JOIN orders o
        ON e.employee_id = o.salesman_id
GROUP BY e.employee_id
HAVING COUNT(o.order_id) = 
(
    SELECT MAX(orderCount)
    FROM
    (
        SELECT e.employee_id, COUNT(o.order_id) orderCount
        FROM employees e
            JOIN orders o
                ON e.employee_id = o.salesman_id
        GROUP BY e.employee_id
    )
)
ORDER BY e.employee_id;

/*
7.  Order Amount
Write a query to display the month number, month name, year, total number of orders, and total sales amount for each month in 2016.
Sort the result according to month number.
The query returns 9 rows. See the output result as follows.
Month Number Month           Year Total Number of Orders Sales Amount
------------ --------- ---------- ---------------------- ------------
           2 February        2016                      3    996895.71
           5 May             2016                      2    1264918.9
           6 June            2016                      7   3334935.14
           7 July            2016                      1    616763.19
           8 August          2016                      5   3665979.49
           9 September       2016                     10   3776557.12
          10 October         2016                      9   2700781.78
          11 November        2016                      5   2148981.02
          12 December        2016                      8   2983793.75
*/
-- Q7 solution
SELECT TO_NUMBER(TO_CHAR(o.order_date,'fmMM')) AS "Month Number",
        TO_CHAR(o.order_date,'Month') AS "Month", 
        TO_NUMBER(TO_CHAR(o.order_date, 'fmYYYY')) AS "Year",
        COUNT(DISTINCT (oi.order_id)) AS "Total Number of Orders",
        SUM(oi.quantity * oi.unit_price) AS "Sales Amount"
FROM orders o
JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE 
    TO_NUMBER(TO_CHAR(o.order_date,'yyyy')) = 2016 
GROUP BY TO_NUMBER(TO_CHAR(o.order_date,'fmMM')),
        TO_CHAR(o.order_date,'Month'), 
        TO_NUMBER(TO_CHAR(o.order_date, 'fmYYYY'))
ORDER BY "Month Number";

/*
8.  Monthly Sales
Write a query to display month number, month name, and average sales amount (per order) for each month in 2016 where the average sales amount is greater than the average sales amount (per order) for the entire year.
Round the average amount to two decimal places.
Sort the result by the month number.
HINT: In this query, you will calculate the average sales amount for each month in 2016 and compare it to the overall average sales amount for the entire year. Using a WITH clause will simplify your code greatly.

The query returns 5 rows. See the output result as follows:
Month Number Month     Average Sales Amount
------------ --------- --------------------
           5 May                  632459.45
           6 June                 476419.31
           7 July                 616763.19
           8 August                733195.9
          11 November              429796.2
*/
-- Q8 solution
SELECT 
    "Month Number",
    "Month",
    ROUND(AVG("Total Sales per Order"),2) AS "Average Sales Amount"
FROM
(
    SELECT
        TO_NUMBER(TO_CHAR(o.order_date,'fmMM')) AS "Month Number",
        TO_CHAR(o.order_date,'Month') AS "Month",
        SUM(oi.quantity * oi.unit_price) AS "Total Sales per Order"
    FROM orders o JOIN
        order_items oi ON o.order_id = oi.order_id
    WHERE 
        TO_NUMBER(TO_CHAR(o.order_date,'yyyy')) = 2016 
    GROUP BY 
        TO_NUMBER(TO_CHAR(o.order_date,'fmMM')), 
        TO_CHAR(o.order_date,'Month'),
        oi.order_id
)
HAVING AVG("Total Sales per Order") > 
(
    SELECT AVG("Total")
    FROM
    (
        SELECT oi.order_id, SUM(oi.quantity * oi.unit_price) AS "Total"
        FROM order_items oi
            JOIN orders o ON oi.order_id = o.order_id
        WHERE TO_NUMBER(TO_CHAR(o.order_date,'yyyy')) = 2016
        GROUP BY oi.order_id
    )
)
GROUP BY
    "Month Number",
    "Month"
ORDER BY "Month Number";

/*
9.  Employees 
Write a query to display first names in EMPLOYEES that start with letter ‘A’ but do not exist in CONTACTS. 
Sort the result by first name.
The query returns 2 rows. See the output column as follows. 

First Name           
-----------
*/
-- Q9 solution
SELECT first_name
FROM employees 
WHERE UPPER(first_name) LIKE 'A%' AND first_name NOT IN (
                                        SELECT first_name
                                        FROM contacts)
ORDER BY first_name;

/*
10. Calculation
Write a query to generate the following output with the calculated values filled in. 
OUTPUT                                                                                                             
---------------------------------------------------------------------------------
The number of employees with total order amount over average order amount: x
The number of employees with total number of orders greater than 10: x
The number of employees with no order: xx
The number of employees with orders: x

Average order amount is the average amount during salesman. While calculating the average order amount, you should exclude the orders that without a salesman.
Hint: Using a WITH clause will simplify your code.
*/
-- Q10 solution
SELECT CONCAT ('The number of employees with total order amount over average order amount: ', (COUNT (*))) FROM (
SELECT O.salesman_id
FROM orders O
LEFT JOIN order_items oi
ON O.order_id = oi.order_id
WHERE O.salesman_id IS NOT NULL
GROUP BY O.salesman_id
HAVING (SUM(oi.quantity * oi.unit_price)) > (SELECT (SUM(quantity * unit_price))/COUNT(DISTINCT order_id)
FROM order_items
WHERE order_id IN (SELECT order_id FROM orders WHERE salesman_id IS NOT NULL)))

UNION ALL

SELECT CONCAT('The number of employees with total number of orders greater than 10: ', COUNT(ALL "Orders"))
FROM
(
    SELECT COUNT(order_id) AS "Orders"
    FROM orders
    WHERE salesman_id IS NOT NULL
    HAVING COUNT(order_id) > 10
    GROUP BY salesman_id
)

UNION ALL

SELECT CONCAT('The number of employees with no order: ', COUNT(employee_id))
FROM
(
    SELECT employee_id
    FROM employees
    MINUS
    SELECT salesman_id
    FROM orders
    WHERE salesman_id IS NOT NULL
)

UNION ALL

SELECT CONCAT('The number of employees with orders: ', COUNT(DISTINCT salesman_id))
FROM orders;