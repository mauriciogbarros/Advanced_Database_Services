


--Question 1. Hired
--Write a query to display employee ID, first name, last name, 
--and hire date for employees who have been hired after the last 
--employee hired in April 2016 but two months before the first employee
--hired in August 2016.

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

--Question 2. Direct Reports
--Display manager ID for managers with more than one direct employee. 
--Answer this question without using the COUNT()function.
--Sort the result by manager ID.
--The query returns 15 rows. See the output columns
--Manager ID
------------

SELECT DISTINCT manager_id AS "Manager ID"
FROM employees p
WHERE employee_id <> ANY (SELECT employee_id
                          FROM employees
                          WHERE manager_id = p.manager_id)
ORDER BY "Manager ID";

--Question 3.	Rest
--Use your query in Q2 and SET Operator(s) to display manager ID for managers who have 
--only one direct employee. You are still not allowed to use COUNT().
--Sort the result by manager ID. 
--The query returns 3 rows. See the output columns:
--Manager ID
------------
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

-- Question 4. Frequent Ordered Products
-- Write a SQL query to display products that have been ordered multiple 
-- times (in different orders) on the same day in 2015.
-- Display product ID, order date, and the number of times the product has 
-- been ordered on that day.
-- Sort the result by order date and product ID.
-- The query returns 2 rows. See the following output columns:
-- Product ID   Order Date     Number of orders
-- ----------   ----------     ----------------

SELECT product_id, order_date, COUNT(DISTINCT oi.order_id) AS "number of orders"
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE order_date > TO_CHAR(TO_DATE('01-01-2015', 'DD-MM-YYYY')) 
                   AND order_date < TO_CHAR(TO_DATE('01-01-2016', 'DD-MM-YYYY')) 
GROUP BY product_id, order_date
HAVING COUNT( DISTINCT oi.order_id) > 1  
ORDER BY product_id;

--5. Purchased
--Write a query to display customer ID and customer name for customers who have 
--purchased all these three products: Products with ID 31, 205, 275.
--Sort the result by customer ID.
--The query returns 1 row. See the following output columns:
--CUSTOMER ID     NAME                                      
-------------     ----

select o.customer_id
from order_items oi
left join orders o
on oi.order_id = o.order_id
left join customers c
on c.customer_id = o.customer_id
where oi.product_id in (31, 205, 275) and count(product_id) = 3;
group by o.customer_id;



/*6.	Salesman
Write a query to display employee ID and the number of orders for employee(s) 
with the maximum number of orders (sales). Hint: A salesman is an employee.
Sort the result by employee ID. 
The query returns 1 row. See the following output:
Employee ID     Number of Orders
-----------     ---------------- */

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
ORDER BY e.employee_id


/*7.	Order Amount
Write a query to display the month number, month name, year, total number 
of orders, and total sales amount for each month in 2016. 
Sort the result according to month number. 
The query returns 9 rows. See the output result as follows. 
*/

