-- ***********************
-- Group ##
-- Student1 Name: Your Name Student1 ID: #########
-- Student2 Name: Your Name Student2 ID: #########
-- Student3 Name: Your Name Student3 ID: #########
-- Date: The date of assignment completion
-- Purpose: Assignment 1 - DBS311
-- All the content other than your sql code should be put in comment block.
-- You could put your output in a comment block following with your sql code (optional).
-- Remember add ; in the end of your statement for each question.
-- ***********************

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




/*
2.  Direct Reports
Display manager ID for managers with more than one direct employee. Answer this question without using the COUNT()function.
Sort the result by manager ID.
The query returns 15 rows. See the output columns:

Manager ID
----------
*/
-- Q2 solution






/*
3.  Rest
Use your query in Q2 and SET Operator(s) to display manager ID for managers who have only one direct employee. You are still not allowed to use COUNT().
Sort the result by manager ID. 
The query returns 3 rows. See the output columns:

Manager ID
----------
*/ 
-- Q3 solution






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






/*
5.  Purchased
Write a query to display customer ID and customer name for customers who have purchased all these three products: Products with ID 31, 205, 275.
Sort the result by customer ID.
The query returns 1 row. See the following output columns:
CUSTOMER ID     NAME                                      
-----------     ----
*/
-- Q5 solution





/*
6.  Salesman
Write a query to display employee ID and the number of orders for employee(s) with the maximum number of orders (sales). Hint: A salesman is an employee.
Sort the result by employee ID. 
The query returns 1 row. See the following output:
Employee ID     Number of Orders
-----------     ----------------
*/
-- Q6 solution




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





/*
9.  Employees 
Write a query to display first names in EMPLOYEES that start with letter ‘A’ but do not exist in CONTACTS. 
Sort the result by first name.
The query returns 2 rows. See the output column as follows. 

First Name           
-----------
*/
-- Q9 solution








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










