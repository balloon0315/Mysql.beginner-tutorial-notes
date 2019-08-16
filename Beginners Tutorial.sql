/*
SELECT 
ORDER BY
WHERE (OR AND IN LIKE % ) 
REGEXP  regular expression
NULL
INNER/OUTER JOIN (self multiple across)
INSERT/UPDATE/DELETE
*/ 

USE  sql_store;

SELECT *
FROM customers
-- WHERE customer_id = 1
ORDER BY state, first_name;
    -- DESC; ASC (default)
    -- ORDER BY 1,2  :order by COL1 COL2  (the column you selected 1,2)

SELECT 
	first_name, 
    last_name,
    points,
    (points + 10) * 100 AS discount_factor   
		        -- "discount factor"
FROM customers
-- LIMIT 3 ;
LIMIT 6, 3; 
	-- : skip first 6 records, and read next 3 reccords.

SELECT DISTINCT state 
FROM customers;

SELECT name, unit_price, unit_price*1.1 AS new_products
FROM products;

-- SELECT *  
-- FROM Customers
	-- >  >=  <  <=  =  !=  <>
-- WHERE points > 3000
-- WHERE state <> "va"
-- WHERE state = "VA" OR "GA" 
-- WHERE state NOT IN ("VA","FL") 
-- WHERE phont IS NULL
	    -- IS NOT NULL

-- WHERE birth_date > "1990-01-01" OR points>1000 AND state= "VA"; 
	-- AND : evaluate first!

-- WHERE NOT (birth_date > "1990-01-01" OR points>1000);  
-- WHERE (birth_date <= "1990-01-01" AND points<=1000)

-- WHERE points >= 1000 AND points <= 3000; 
-- WHERE points BETWEEN 1000 AND 3000;

-- WHERE last_name LIKE "b%";  
	-- %    : any number of character; can be anywhere to change pattern. %b% 
	-- "_y" : be exactly two character and end with y.


-- WHERE Last_name LIKE "%field%"
-- WHERE Last_name REGEXP  "field";
	-- "field|mac|rose" : "field" or "mac" or "rose"; "field$|max$"
	-- "^field"  : name must start with "field"
	-- "field$"  : name must end with "field"
	-- "[gim]e"  : name contains "ge" "ie" "me";  [a-h]e; e[mhd];


	   -- \\\   INNER JOIN = JOIN ; OUTER JOIN = LEFT/RIGHT JOIN  \\\
SELECT *
FROM orders o  
JOIN customers c  
	ON o.customer_id = c.customer_id;
	-- orders o : alias; once used, all places should use it.  
        -- : attention these columns in different table but with same column names.
	-- INNER JOIN : only return records match this condition

SELECT 
	c.customer_id,
	c.first_name,
	o.order_id
/* 
FROM customers c
RIGHT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
        -- : order_id with NULL value not return. 
	-- : result same as inner join. cuz order by Right table orders 
*/ 
FROM orders o
RIGHT JOIN customers c
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
	-- OUTER JOIN : LEFT JOIN; RIGHT JOIN
	-- LEFT/RIGHT JOIN: all record from left table will return no matter whether condition is T/F


	   -- \\\   JOINING ACROSS DATABASES   \\\   
USE sql_store;
SELECT * 
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id; 

        
	   -- \\\   self joins   \\\
USE sql_hr;

SELECT 
    e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
JOIN employees m 
	ON e.reports_to = m. employee_id; 


	   -- \\\   joining multiple tables   \\\
USE sql_store;

SELECT 
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id;


	   -- \\\   Compound join conditions (eg. two col as primary key )   \\\
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;


	   -- \\\   Implicit Join syntax   \\\
/*
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
*/

SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;


	   -- \\\   outer joins between multiple tables   \\\
SELECT 
    o.order_id,
    o.order_date,
    c.customer_id,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh     
	-- : in this case, left shows null record while inner join not.
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id;
    

	   -- \\\   self outer joins   \\\
USE sql_hr;

SELECT *
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;


	   -- \\\   The Using Clause  \\\
SELECT 
    o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
-- ON c.customer_id = o.customer_id
    USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);
    
    /*
	-- ON oi.order_id = oin.order_id
	-- AND oi.product_id = oin.product_id;
        --->
        USING (order_id,product_id);
    */
    
    
	   -- \\\   natural joins (join two tables)  \\\
SELECT 
    o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;
    /* But not recommend, database engine guess the joint,
    you don't have control of it. So might produce unexpect result.*/
    

	   -- \\\   cross joins   \\\
SELECT *
FROM customers c
CROSS JOIN products p;  
	-- :explicit syntax (more clear)
-- FROM customers c, products p  
        --: implicit syntax
	-- : combine all records in two tables
        -- : recommend using when the table has variables such as size/color...


	   -- \\\   Unions (combine rows in multiple tables)   \\\
SELECT
    order_id,
    order_date,
    "active" AS status
FROM orders
WHERE order_date >= "2019-01-01"
UNION   
SELECT
    order_id,
    order_date,
    "archived" AS status
FROM orders
WHERE order_date < "2019-01-01";
	-- : two combined tables should have same number columns.
        -- : if different, the col in first table will determine the col of result.


	   -- \\\   columns attributes   \\\
/*
column name
datatype: 
	int,
	VARCHAR(max#) - variablecharacter : string,texture.
        CHAR(max#) - empty space will be filled by blank for #; waste space. 
PK - primary key (marked by yellow key)
NN - not NULL; accept NULL value or not
AI - make column as AUTO_INCREMENT (normally used for PK)
*/


	   -- \\\   inserting a single row   \\\
INSERT INTO customers
VALUES (
    DEFAULT,
    "John",
    "Smith",
    "1990-01-01",
    NULL,
    "address",
    "city",
    "CA",
    DEFAULT
    );     
    -- : (default or number you need,,date/phone or NULL)
 
 INSERT INTO customers (
    first_name,
    last_name,
    address,
    city,
    state)
VALUES (
    "John",
    "Smith",
    "address",
    "city",
    "CA"
    );  
    -- : we can assign values to several specific cols,
    -- : we can change the order of columns.
    -- : check attributes table (NN) to determine which value must be set.
    
    
	   -- \\\   inserting multiple rows   \\\
INSERT INTO shippers (name)
VALUES 
	("shipper1"),
	("shipper2"),
	("shipper3");
	-- : one column with multiple rows.

INSERT INTO products (name,quantity_in_stock,unit_price)
VALUES 
	("p1",10,1.95),
	("p2",10,1.95),
	("p3",10,1.95);
	-- : multiple column with multiple rows.
        
        
	   -- \\\   inserting hierarchical rows   \\\
INSERT INTO orders (customer_id, order_date, status)
VALUES (1,"2019-01-02",1);
	 /* two tables have same col order_id. MySQL will generate an id for new order.
       in order to access to insert the items in this table. Function need to be used.*/ 
INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(),1,1,2.95),
	(LAST_INSERT_ID(),2,1,2.95);

-- SELECT LAST_INSERT_ID()


	   -- \\\   create a copy of a table   \\\
CREATE TABLE orders_archived AS
SELECT * FROM orders;  
	-- (subquery)
    -- :Using this tech , MySQL will ignore PK AI attributes.
    -- :Truncate Table to clean all records in that table */

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < "2019-01-01";

USE sql_invoicing;
CREATE TABLE invoices_paid AS 
SELECT 
    i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
FROM invoices i
JOIN clients c
	USING (client_id)
WHERE payment_date IS NOT NULL;


	   -- \\\   updating a single row   \\\
UPDATE invoices
SET payment_total = 10, payment_date = "2019-03-01"
WHERE invoice_id = 1 ;
	-- : if made wrong, change back. Can check attributes table for default value.
      
 
	   -- \\\   updating multiple rows   \\\
UPDATE invoices
SET 
    payment_total = invoice_total * 0.5, 
    payment_date = due_date
WHERE client_id = 3 ;
	/* BUT workbench has safe mode, only allow to change a single record.
       Can be change in mac preference - SQL editor - safe update 
       reopen workbench then execute*/
       
       
	   -- \\\   using subqueries in updates   \\\
UPDATE invoices
SET 
    payment_total = invoice_total * 0.5, 
    payment_date = due_date
WHERE client_id IN 
			(SELECT client_id
			FROM clients
			WHERE state IN ("CA","NY"));
	-- : where =/in which one should be use depends on range of "where" in subquery .


	   -- \\\   deleting rows   \\\
DELETE FROM invoices
WHERE client_id = (
	SELECT * 
	FROM clients
	WHERE name = "Myworks"
)


	   -- \\\   Restoring the databases   \\\
/* 
- open sql script 
- open the orginal database
- execute 
- refresh schemas
*/


