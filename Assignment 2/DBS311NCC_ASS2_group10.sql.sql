set serveroutput on;

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
begin
    find_customer(178787877, found);
    IF found = 1 then
        DBMS_OUTPUT.PUT_LINE ('FOUND! '); 
    ELSE
        IF found = 0 then
            DBMS_OUTPUT.PUT_LINE ('DID NOT find!');
        elsif found = -1 then
            DBMS_OUTPUT.PUT_LINE ('Too many returned.');
        else
            DBMS_OUTPUT.PUT_LINE ('Unknow error!');
        end if;
    END IF;    
end;





