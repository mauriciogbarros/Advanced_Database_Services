set serveroutput on;


--1st STORED PROCEDURE FIND CUSTOMER
CREATE OR REPLACE PROCEDURE find_customer (m_customer_id IN NUMBER, found OUT NUMBER)
AS 
BEGIN 
            SELECT COUNT(customer_id) INTO found
            FROM customers
            WHERE customer_id = m_customer_id;
 
 EXCEPTION
 WHEN no_data_found  THEN
 found := 0;
 WHEN too_many_rows  THEN
 found := -1;
 WHEN OTHERS THEN
 found := -2;
END;
 
declare
    found  number;
    customer_code number;
begin
    customer_code := 12232;

    find_customer(customer_code, found);
    IF found = 1 then
        DBMS_OUTPUT.PUT_LINE ('We found the customer with id: ' || customer_code); 
    ELSE
        IF found = 0 then
            DBMS_OUTPUT.PUT_LINE ('We did not find customer with id: ' || customer_code);
        elsif found = -1 then
            DBMS_OUTPUT.PUT_LINE ('Too many returned.');
        else
            DBMS_OUTPUT.PUT_LINE ('Unknow error!');
        end if;
    END IF;    
end;


--2nd STORED PROCEDURE FIND_PRODUCT
CREATE OR REPLACE PROCEDURE find_product (m_productId IN NUMBER,price OUT FLOAT, productName OUT STRING)
AS 
currMonth number;
catId NUMBER;
BEGIN

select to_char(sysdate, 'MM') into currMonth
from dual;
            
            SELECT list_price, product_name, category_id INTO price, productName, catId
            FROM products
            WHERE product_id = m_productId;
            
            IF((currMonth = 11  OR currMonth = 12) AND (catId = 2 OR catId = 5)) then price := price*.90;   END IF;   
 
 EXCEPTION
 WHEN no_data_found  THEN price := 0; productName := null;
 WHEN too_many_rows  THEN price := -1;
 WHEN OTHERS THEN price := -2;
END;

DECLARE
    productName STRING(255); price FLOAT; prod_code NUMBER;
BEGIN
    prod_code := 6;
    find_product(prod_code, price, productName);
    
    IF price > 0 then
        DBMS_OUTPUT.PUT_LINE ('We found the prod id: ' || prod_code); 
        DBMS_OUTPUT.PUT_LINE ('Product name is: ' || productName);
        DBMS_OUTPUT.PUT_LINE ('Price for this product is: ' || price);
    ELSE
        IF price = 0 then DBMS_OUTPUT.PUT_LINE ('We did not find the prod id: ' || prod_code);
        elsif price = -1 then DBMS_OUTPUT.PUT_LINE ('Too many returned.');
        else DBMS_OUTPUT.PUT_LINE ('!Unknow error!');
        end if;
    END IF;    
END;

--3rd STORED PROCEDURE ADD ORDER

CREATE OR REPLACE PROCEDURE add_order (customer_id IN NUMBER, new_order_id OUT NUMBER)
AS 
currMonth number;
catId NUMBER;
BEGIN

select to_char(sysdate, 'MM') into currMonth
from dual;
            
            SELECT list_price, product_name, category_id INTO price, productName, catId
            FROM products
            WHERE product_id = m_productId;
            
            IF((currMonth = 11  OR currMonth = 12) AND (catId = 2 OR catId = 5)) then price := price*.90;   END IF;   
 
 EXCEPTION
 WHEN no_data_found  THEN price := 0; productName := null;
 WHEN too_many_rows  THEN price := -1;
 WHEN OTHERS THEN price := -2;
END;

DECLARE
    productName STRING(255); price FLOAT; prod_code NUMBER;
BEGIN
    prod_code := 6;
    find_product(prod_code, price, productName);
    
    IF price > 0 then
        DBMS_OUTPUT.PUT_LINE ('We found the prod id: ' || prod_code); 
        DBMS_OUTPUT.PUT_LINE ('Product name is: ' || productName);
        DBMS_OUTPUT.PUT_LINE ('Price for this product is: ' || price);
    ELSE
        IF price = 0 then DBMS_OUTPUT.PUT_LINE ('We did not find the prod id: ' || prod_code);
        elsif price = -1 then DBMS_OUTPUT.PUT_LINE ('Too many returned.');
        else DBMS_OUTPUT.PUT_LINE ('!Unknow error!');
        end if;
    END IF;    
END;

--4th STORED PROCEDURE (function) GENERATE ORDER ID

CREATE OR REPLACE FUNCTION generate_order_id
RETURN number
IS
    nextID number := 0;
BEGIN
    SELECT MAX(order_id) into nextID
    FROM orders;
RETURN nextID + 1;
END generate_order_id;

DECLARE
    nextID NUMBER := 0;
BEGIN
    
    nextID := generate_order_id();
    dbms_output.put_line (nextID);
END;

------------------





































