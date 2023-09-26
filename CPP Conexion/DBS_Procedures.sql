SET SERVEROUTPUT ON;

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
CREATE OR REPLACE PROCEDURE add_order(customer_id IN NUMBER, new_order_id OUT NUMBER)
AS salesPersonID NUMBER;
status VARCHAR2 (20);
currDate DATE;
BEGIN
currDate := sysdate;
salesPersonID := 56;
status := 'Shipped';
new_order_id := generate_order_id();

   INSERT INTO orders 
   VALUES (new_order_id, customer_id, status, salesPersonID, currDate);
END;

DECLARE
new_order_id number;
BEGIN
    add_order(44, new_order_id);
    dbms_output.put_line (new_order_id);
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

--5th STORED PROCEDURE ADD ORDE ITEM
CREATE OR REPLACE PROCEDURE add_order_item (orderId IN NUMBER,
                             itemId IN NUMBER, 
                             productId IN NUMBER, 
                             quantity IN NUMBER,
                             price IN FLOAT)
AS 
BEGIN

INSERT INTO order_items 
    VALUES (orderId, itemId, productId, quantity, price);
END;

DECLARE
    orderId NUMBER := 108;
    itemId NUMBER := 6;
    productId NUMBER := 183;
    quantity NUMBER := 79;
    price FLOAT :=899.99;
BEGIN
    add_order_item(orderId, itemId, productId, quantity, price);
END;

--6th STORED PROCEDURE CUSTOMER ORDER
CREATE OR REPLACE PROCEDURE customer_order (customerId IN NUMBER, orderId IN OUT NUMBER)
AS
BEGIN

SELECT order_id INTO orderID
FROM orders
WHERE customer_id = customerID AND order_id = orderId;

 EXCEPTION
 WHEN no_data_found  THEN orderId := 0;
END;

DECLARE
    customerId NUMBER := 9;
    orderId NUMBER := 93331;
BEGIN
    customer_order(customerId, orderId);
    
    if orderId > 0 then
        dbms_output.put_line ('Customer number: ' || customerId || ' has an order number: ' || orderId);
    else 
        dbms_output.put_line ('Customer number: ' || customerId || ' DOES NOT HAVE an order with the given order number');
    end if;
END;

--7th STORED PROCEDURE DISPLAY ORDER STATUS
CREATE OR REPLACE PROCEDURE display_order_status(orderId IN NUMBER, status OUT VARCHAR2 )
AS 
BEGIN 
    SELECT status INTO status
    FROM orders
    WHERE order_id = orderId;
    
EXCEPTION
 WHEN no_data_found  THEN status := NULL;
END;

DECLARE
    orderId NUMBER := 93;
    status VARCHAR2(20);
BEGIN
    display_order_status(orderId, status);
    
    if status IS NULL THEN
        dbms_output.put_line ('There is no order with id: ' || orderId);
    else 
        dbms_output.put_line ('Order number: ' || orderId || ' status is ' || status);
    end if;
END;

--8th STORED PROCEDURE DISPLAY ORDER STATUS
CREATE OR REPLACE PROCEDURE cancel_order (orderId IN NUMBER, cancelStatus OUT NUMBER)
AS
orderStatus VARCHAR2(20) := NULL;
BEGIN
      SELECT status INTO orderStatus FROM orders WHERE order_id = orderId;
      
IF orderStatus IS NOT NULL THEN
    IF orderStatus LIKE 'Canceled' then cancelStatus :=1;        
    ELSE IF orderStatus LIKE 'Shipped' THEN cancelStatus := 2;
    ELSE cancelStatus := 3;
        UPDATE orders
        SET status = 'Canceled'
        WHERE order_id = orderId;
    END IF;   END IF; END IF; 
    
    EXCEPTION WHEN no_data_found THEN cancelStatus := 0; END;

DECLARE
    orderId NUMBER := 108; cancelStatus NUMBER;
BEGIN
    cancel_order(orderId, cancelStatus);
        dbms_output.put_line ('cancelStatus variable returned as: ' || cancelStatus);  END;














